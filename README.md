# deploy-site

Give Claude the ability to deploy a local folder of website code to a live, shareable URL.

This is **Stage 0**: a personal Claude Code skill that wraps the Vercel CLI. You point
Claude at a folder, say "deploy it," and get back a public URL.

## How it works

```
You:    @my-site deploy this website
Claude: (runs deploy.sh → vercel deploy → captures URL)
        Live at https://my-site-a1b2c3.vercel.app
```

- **Hosting:** Vercel (your account; authenticated locally via `vercel login`).
- **URLs:** fresh, unique, throwaway per deploy.
- **Source-safe:** deploys a staged copy, never touches your original folder.
- **Stacks:** static HTML or framework apps (Next.js, Vite, etc.) — auto-detected.

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition + instructions Claude follows |
| `STYLE.md` | House design system for generated pages |
| `deploy.sh` | The deploy script (stage → deploy → return URL) |

## Install

The skill is symlinked into `~/.claude/skills/deploy-site`, so Claude Code picks it up
automatically. The project source lives here in `~/Documents/deploy-site`.

## Requirements

- [Vercel CLI](https://vercel.com/docs/cli) installed (`npm i -g vercel`)
- Logged in once: `vercel login`

## URLs

Deploys land on **`weblink.dev`** (the default domain, managed by Vercel — subdomains
auto-provision DNS + SSL):

```bash
# throwaway: fresh URL each run, e.g. roadmap-a1b2.weblink.dev
~/.claude/skills/deploy-site/deploy.sh <folder>

# update-in-place: clean stable URL, e.g. roadmap.weblink.dev
~/.claude/skills/deploy-site/deploy.sh <folder> update
```

The subdomain is derived from the folder name. Override the domain with
`DEPLOY_DOMAIN=other.com`, or set `DEPLOY_DOMAIN=` (empty) to use plain `*.vercel.app`.

## Roadmap

- **Stage 0** (this) — personal skill, your Vercel, throwaway URLs.
- **Stage 1** — open-source bring-your-own-Vercel plugin / MCP server.
- **Stage 2** — hosted backend (you own the hosting + domain); free + paid tiers.
- **Stage 3** — framework builds sandboxed + public deploy API for any agent.
