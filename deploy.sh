#!/usr/bin/env bash
# deploy.sh — stage a clean copy of a website folder and deploy it to a live URL via Vercel.
# Usage:
#   deploy.sh <path-to-folder>            -> throwaway: <name>-<rand>.weblink.dev (fresh each run)
#   deploy.sh <path-to-folder> update     -> update-in-place: <name>.weblink.dev (stable; also "prod")
# Custom domain defaults to weblink.dev. Override with DEPLOY_DOMAIN=other.com,
# or set DEPLOY_DOMAIN= (empty) to fall back to plain *.vercel.app URLs.
set -euo pipefail

SRC="${1:?usage: deploy.sh <path-to-folder> [update]}"
if [ ! -d "$SRC" ]; then
  echo "ERROR: '$SRC' is not a directory" >&2
  exit 1
fi
SRC="$(cd "$SRC" && pwd)"

# Mode: "update"/"prod" (2nd arg) or DEPLOY_UPDATE=1 -> stable production URL.
MODE="${2:-}"
PROD=0
case "$MODE" in update|prod|--prod) PROD=1 ;; esac
[ -n "${DEPLOY_UPDATE:-}" ] && PROD=1

# Default custom domain. Override with DEPLOY_DOMAIN=other.com; set empty to disable.
DEPLOY_DOMAIN="${DEPLOY_DOMAIN-weblink.dev}"

# Derive a clean, URL-friendly project name from the folder name.
BASE="$(basename "$SRC" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')"
[ -z "$BASE" ] && BASE="site"

# Stage a copy in temp so the source folder stays pristine (no .vercel written into it)
# and the deploy URL gets a clean name based on the folder.
STAGE_ROOT="$(mktemp -d)"
STAGE="$STAGE_ROOT/$BASE"
mkdir -p "$STAGE"
rsync -a --exclude '.git' --exclude 'node_modules' --exclude '.vercel' "$SRC"/ "$STAGE"/

LOG="$STAGE_ROOT/vercel-deploy.log"

# Deploy. CLI is already authenticated via `vercel login`, so no token needed.
# --yes auto-confirms project setup. stdout is the deployment URL.
# In update mode, --prod deploys to the project's stable production URL.
PRODFLAG=""; [ "$PROD" = "1" ] && PRODFLAG="--prod"
if ! URL="$(cd "$STAGE" && vercel deploy --yes $PRODFLAG 2>"$LOG")"; then
  echo "ERROR: deploy failed. Vercel output:" >&2
  cat "$LOG" >&2
  exit 1
fi

# Vercel enables Deployment Protection (SSO login) on new projects by default, which would
# gate the URL behind a Vercel login. Disable it so the URL is genuinely public. Reuses the
# CLI's own stored token + the project's org id — no separate token needed. Best-effort.
AUTH="$HOME/Library/Application Support/com.vercel.cli/auth.json"
PROJ_JSON="$STAGE/.vercel/project.json"
if [ -f "$AUTH" ] && [ -f "$PROJ_JSON" ]; then
  TOKEN="$(python3 -c "import json;print(json.load(open('$AUTH'))['token'])" 2>/dev/null || true)"
  ORGID="$(python3 -c "import json;print(json.load(open('$PROJ_JSON'))['orgId'])" 2>/dev/null || true)"
  PROJID="$(python3 -c "import json;print(json.load(open('$PROJ_JSON'))['projectId'])" 2>/dev/null || true)"
  if [ -n "$TOKEN" ] && [ -n "$PROJID" ]; then
    Q=""; [ -n "$ORGID" ] && Q="?teamId=$ORGID"
    curl -s -X PATCH "https://api.vercel.com/v9/projects/${PROJID}${Q}" \
      -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
      -d '{"ssoProtection": null}' >>"$LOG" 2>&1 || \
      echo "WARN: could not disable deployment protection (URL may require Vercel login)." >&2
  fi
fi

# $URL is the raw per-deployment URL from `vercel deploy`. Alias from it.
DEPLOY_URL="$URL"

# Preferred path: alias onto the custom domain (Vercel manages the zone, so the record +
# SSL auto-provision). Update mode -> clean stable <name>.domain; throwaway -> <name>-<rand>.domain.
if [ -n "$DEPLOY_DOMAIN" ]; then
  if [ "$PROD" = "1" ]; then
    HOST="${BASE}.${DEPLOY_DOMAIN}"
  else
    HOST="${BASE}-$(openssl rand -hex 2).${DEPLOY_DOMAIN}"
  fi
  if (cd "$STAGE" && vercel alias set "$DEPLOY_URL" "$HOST" >>"$LOG" 2>&1); then
    echo "https://$HOST"
    exit 0
  else
    echo "WARN: custom-domain alias failed, falling back to a vercel.app URL. See log:" >&2
    tail -8 "$LOG" >&2
  fi
fi

# Fallback (no custom domain, or alias failed): in update mode prefer the stable *.vercel.app
# domain (constant across redeploys) over the per-deployment hashed URL.
if [ "$PROD" = "1" ] && [ -n "${TOKEN:-}" ] && [ -n "${PROJID:-}" ]; then
  DQ=""; [ -n "${ORGID:-}" ] && DQ="?teamId=$ORGID"
  STABLE="$(curl -s "https://api.vercel.com/v9/projects/${PROJID}/domains${DQ}" \
    -H "Authorization: Bearer $TOKEN" 2>/dev/null | python3 -c "
import json,sys
try:
    d=json.load(sys.stdin)
    c=[x['name'] for x in d.get('domains',[]) if x.get('name','').endswith('.vercel.app')]
    print(c[0] if c else '')
except Exception:
    print('')" 2>/dev/null || true)"
  [ -n "$STABLE" ] && DEPLOY_URL="https://$STABLE"
fi

echo "$DEPLOY_URL"
