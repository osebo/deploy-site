---
name: deploy-site
description: Deploy a local folder of website code to a live, publicly shareable URL via Vercel. Use when the user wants to deploy, publish, ship, or "put online" a website/site/folder, or asks to turn local code into a link they can visit or share. Handles static HTML and framework apps (Next.js, Vite, etc.). When creating new webpages to deploy, always follow the house style in STYLE.md.
---

# Deploy a website to a live URL

Turn a local folder of website code into a public URL the user can open anywhere.
The deploy script handles staging, deploying via the Vercel CLI, and returning the URL.

## House style (required when creating pages)

When this skill is used to **create or generate a webpage** (not just deploy existing
code), the page MUST follow the design system in [`STYLE.md`](STYLE.md): warm off-white
background (`#fbfaf8`), near-black ink, Newsreader serif headings + Inter body, a single
640px centered column, hairline rules, monochrome metric cards, and quiet tables.
Read `STYLE.md` and start from its template before writing any HTML. Only deviate if
the user explicitly asks for a different look.

## When to use

The user references a folder (often via `@`) and asks to deploy / publish / ship it,
or wants "a website at a URL I can visit." Examples:
- "`@my-site` deploy this website"
- "put this folder online"
- "give me a shareable link for this site"

## How to run it

1. **Identify the target folder.** It's whatever the user pointed at with `@`, or the
   folder they describe. If ambiguous (multiple candidates, or they just said "deploy"
   with no clear folder), ask which folder before deploying. If they reference a single
   file like `index.html`, use its containing folder.

2. **Pick the mode:**
   - **Throwaway (default)** — a fresh, unique URL each run. Use for one-off "show this
     somewhere" deploys, or the first deploy of something new.
   - **Update-in-place** — a stable production URL that stays the same across redeploys.
     Use this when the user wants to *change an existing site*, "update the same page,"
     or keep one shareable link. Pass `update` as the second argument.

   ```bash
   # throwaway URL
   ~/.claude/skills/deploy-site/deploy.sh "<absolute-path-to-folder>"

   # update-in-place: same stable URL every time
   ~/.claude/skills/deploy-site/deploy.sh "<absolute-path-to-folder>" update
   ```

   - The CLI is already authenticated via `vercel login` — no token needed.
   - The script stages a clean copy (excludes `.git`, `node_modules`, `.vercel`) so the
     user's source folder is never modified.
   - The **stable URL is derived from the folder name** — redeploying the *same folder*
     in update mode hits the *same* URL. Keep the folder name stable to keep the URL stable.
   - On success, the **last line of stdout is the live URL.** Report it to the user
     clearly, e.g. `✅ Live at <url>`.
   - If the user previously got a throwaway link and now wants to edit "the same site,"
     switch to update mode going forward and give them the new stable URL once.

3. **On failure**, the script prints `ERROR:` plus the Vercel output to stderr. Read it
   and explain the cause plainly (most common: a framework build error in the user's
   code). Don't retry blindly — surface what broke.

## Custom domain (optional, off by default)

Once the user owns a domain and has added a wildcard (`*.theirdomain.com`) in Vercel,
set the `DEPLOY_DOMAIN` env var and the script will alias each deploy to
`<folder>-<rand>.theirdomain.com` instead of the default `*.vercel.app`:

```bash
DEPLOY_DOMAIN=theirdomain.com ~/.claude/skills/deploy-site/deploy.sh "<folder>"
```

If the alias step fails, the script falls back to the default Vercel URL and warns.

## Notes

- Deploying publishes content to a **public** URL. If the user seems unsure, confirm
  before the first deploy of sensitive content.
- To take a deploy down later: `vercel rm <project-name> --yes`.
