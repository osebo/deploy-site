# House style for generated webpages

Every webpage created for deployment with this skill MUST follow this design system.
It is modeled on https://web-strategy.weblink.dev/ — a quiet, editorial, essay-like
aesthetic: warm off-white paper, near-black ink, serif display type, hairline rules,
and restrained monochrome accents. No loud colors, no heavy shadows, no gradients.

## Core tokens

```css
:root{
  --bg:#fbfaf8;      /* warm off-white page background */
  --ink:#1b1a18;     /* near-black text */
  --soft:#8a877f;    /* warm gray for labels, captions, metadata */
  --hair:#e7e4dd;    /* hairline borders and rules */
  --serif:"Newsreader",Georgia,"Times New Roman",serif;
  --sans:"Inter",-apple-system,BlinkMacSystemFont,system-ui,sans-serif;
}
```

Fonts via Google Fonts:

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;1,6..72,400&family=Inter:wght@400;500&display=swap" rel="stylesheet">
```

## Layout rules

- Single centered column: `max-width:640px; margin:0 auto; padding:0 28px`.
- Body: sans, `17px`, `line-height:1.65`, on `var(--bg)`.
- Generous top space: header padding `104px 0 8px` (72px on mobile).
- Sections separated by `border-top:1px solid var(--hair)` — hairlines, never boxes.
- Footer: hairline top border, `var(--soft)` text, `.86rem`, big bottom margin.

## Typography

- **H1 (page title):** serif, weight 500, `2.6rem`, `letter-spacing:-.01em`, `line-height:1.05`.
  Followed by a `<time>` or subtitle line in `var(--soft)`, `.9rem`.
- **Section headings (H2):** serif, weight 500, `1.5rem`, tight tracking.
- **Eyebrow labels (H3):** sans, `.82rem`, uppercase, `letter-spacing:.12em`, `var(--soft)`.
  Use numbered form: `01 · The evidence`.
- **Pull quotes / ledes:** serif, larger (`1.12–1.32rem`), often italic, slightly muted ink.
- **Bold** is weight 500 (not 700) in `var(--ink)`.
- Max two font families. Never add a third.

## Components

- **Metric cards:** 3-column grid (`gap:12px`), white background, `1px solid var(--hair)`,
  `border-radius:12px`, `padding:20px 18px`. Big serif number (`2.1rem`) over a small
  `var(--soft)` label. Collapse to 1 column under 520px.
- **Bullet lists:** no discs — a 5px horizontal dash (`width:5px;height:1px;background:var(--soft)`)
  positioned left of each item. `padding-left:20px`.
- **Tables:** quiet. Hairline row borders only, no vertical lines, no zebra striping.
  Uppercase `.74rem` letterspaced soft-gray `thead`. Right-align numbers with
  `font-variant-numeric:tabular-nums`. Italic soft-gray `caption` above.
- **Notes/callouts:** no panels or side borders — a dash marker plus an inline uppercase
  tag (e.g. `GOOD`, `LIMIT`) in front of the text.
- **Code/commands:** monospace `.82rem`, background `#f1efe9`, `1px solid var(--hair)`,
  `border-radius:8px`, `padding:10px 12px`.
- **Status/metadata chips:** right-aligned in a flex row with the heading,
  `.82rem`, `var(--soft)`, `tabular-nums` (e.g. `833K / week`).

## Tone

- Monochrome: ink, soft gray, hairline, paper. Emphasis = weight + serif size, never color.
- White (`#fff`) only inside cards; everything else sits on `var(--bg)`.
- Border radii: 12px cards, 8px code blocks. No pills, no shadows.
- Mobile breakpoint at 520px: shrink H1 to `2.1rem`, stack cards.

## Starter template

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Page Title</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Newsreader:ital,opsz,wght@0,6..72,400;0,6..72,500;1,6..72,400&family=Inter:wght@400;500&display=swap" rel="stylesheet">
<style>
  :root{
    --bg:#fbfaf8; --ink:#1b1a18; --soft:#8a877f; --hair:#e7e4dd;
    --serif:"Newsreader",Georgia,"Times New Roman",serif;
    --sans:"Inter",-apple-system,BlinkMacSystemFont,system-ui,sans-serif;
  }
  *{box-sizing:border-box}
  html{-webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility}
  body{margin:0;background:var(--bg);color:var(--ink);font-family:var(--sans);font-size:17px;line-height:1.65}
  .container{max-width:640px;margin:0 auto;padding:0 28px}
  header.intro{padding:104px 0 8px}
  header.intro h1{font-family:var(--serif);font-weight:500;font-size:2.6rem;letter-spacing:-.01em;margin:0;line-height:1.05}
  header.intro time{display:block;margin-top:10px;color:var(--soft);font-size:.9rem}
  article p{margin:1.35em 0;color:#2a2925}
  article p strong{font-weight:500;color:var(--ink)}
  .pull{font-family:var(--serif);font-size:1.32rem;line-height:1.5;color:#26241f;margin:1.1em 0}
  section.list{margin-top:64px}
  section.list > h3{font-family:var(--sans);font-weight:500;font-size:.82rem;text-transform:uppercase;letter-spacing:.12em;color:var(--soft);margin:0 0 6px}
  .group{padding:24px 0;border-top:1px solid var(--hair)}
  .row{display:flex;align-items:baseline;justify-content:space-between;gap:18px}
  .row h2{font-family:var(--serif);font-weight:500;font-size:1.5rem;letter-spacing:-.01em;margin:0;line-height:1.2}
  .status{flex:none;font-size:.82rem;color:var(--soft);font-variant-numeric:tabular-nums;white-space:nowrap}
  .lede{font-family:var(--serif);font-size:1.12rem;color:#3a3833;margin:.5rem 0 .9rem;font-style:italic}
  .cards{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin:.6rem 0 .2rem}
  .card{background:#fff;border:1px solid var(--hair);border-radius:12px;padding:20px 18px}
  .card .big{font-family:var(--serif);font-weight:500;font-size:2.1rem;line-height:1;letter-spacing:-.02em;color:var(--ink)}
  .card .lbl{color:var(--soft);font-size:.86rem;margin-top:9px;line-height:1.45}
  ul.points{list-style:none;margin:.4rem 0 0;padding:0;display:grid;gap:8px}
  ul.points li{position:relative;padding-left:20px;color:#46443e;font-size:.97rem;line-height:1.5}
  ul.points li::before{content:"";position:absolute;left:2px;top:.72em;width:5px;height:1px;background:var(--soft)}
  table{width:100%;border-collapse:collapse;margin:.7rem 0 .2rem;font-size:.95rem}
  caption{caption-side:top;text-align:left;color:var(--soft);font-size:.88rem;font-style:italic;margin-bottom:8px}
  th,td{text-align:left;padding:9px 2px;border-bottom:1px solid var(--hair)}
  thead th{font-weight:500;font-size:.74rem;text-transform:uppercase;letter-spacing:.1em;color:var(--soft)}
  td.num,th.num{text-align:right;font-variant-numeric:tabular-nums}
  .cmd{display:block;margin-top:9px;font-family:ui-monospace,SFMono-Regular,Menlo,monospace;font-size:.82rem;background:#f1efe9;border:1px solid var(--hair);border-radius:8px;padding:10px 12px;color:#2a2925;overflow-x:auto;white-space:pre-wrap;word-break:break-word}
  footer{margin:80px 0 96px;border-top:1px solid var(--hair);padding-top:22px;color:var(--soft);font-size:.86rem}
  @media (max-width:520px){
    header.intro{padding-top:72px}
    header.intro h1{font-size:2.1rem}
    .row h2{font-size:1.3rem}
    th,td{font-size:.88rem}
    .cards{grid-template-columns:1fr;gap:10px}
  }
</style>
</head>
<body>
  <div class="container">
    <header class="intro">
      <h1>Page Title</h1>
      <time>Updated Jun 2026</time>
    </header>
    <article>
      <p><strong>Opening thesis sentence in medium weight.</strong> Supporting context follows in regular weight.</p>
      <p class="pull">A serif pull quote that states the core argument in one or two lines.</p>
    </article>
    <section class="list">
      <h3>01 · Section label</h3>
      <div class="group">
        <div class="row">
          <h2>Section heading</h2>
          <span class="status">metadata</span>
        </div>
        <p class="lede">An italic serif lede summarizing the section.</p>
      </div>
    </section>
    <footer>Footer text.</footer>
  </div>
</body>
</html>
```
