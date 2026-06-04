# CLAUDE.md

Guidance for working in this repo. Read this first.

## What this is
Marketing website for **Little Juneberry Photography**, a **wedding-only** photographer.
Photographer: **Allie Eastwood**. Based in **Solon Springs, WI** (northwest Wisconsin);
marketed to **Duluth, MN and Superior, WI** (the "Twin Ports") and across **Minnesota & Wisconsin**.
Static HTML site hosted free on **GitHub Pages** at **littlejuneberryphotography.com**.

## Commands
- `npm install` once.
- `npm start` — local preview with live reload (browser-sync, default port 4321; port 3000 is
  used by another project on this machine).
- `npm run build` — optimizes images in `assets/images` with sharp (`scripts/optimize-images.mjs`).
  Safe to re-run; only shrinks files that are oversized.
- `node scripts/add-image-dims.mjs` — injects intrinsic width/height into `<img>` tags (reduces CLS).
- **Deploy = `git push` to `main`.** GitHub Pages serves the repo root; no build step needed to publish.

## Structure
- Four real pages, all at the repo root, each fully self-contained (header/footer are **inlined**,
  not loaded via JS): `index.html`, `portfolio.html`, `about.html`, `contact.html`. Plus `404.html`.
- Every other root `*.html` (`wedding.html`, `family.html`, etc.) and everything in `pages/` are
  **meta-refresh redirect stubs** that send old/bookmarked URLs to the right new page. Keep them.
- `assets/css/styles.css` — single stylesheet. Design tokens live in `:root` at the top.
- `assets/js/main.js` — nav, scroll-reveal, FAQ accordion, back-to-top, portfolio filter + lightbox.
- `assets/images/{portfolio,wedding,about}` — photos. `assets/icons` — favicons.

## Conventions and rules (important)
- **No em dashes** anywhere in copy. The owner considers them an AI giveaway. Use commas,
  periods, colons, or parentheses. Avoid en dashes in prose too.
- **Wedding only.** No family/kid/portrait content. Engagement/couples content is fine (it supports
  the included engagement session).
- **Style wording:** "warm & timeless," "relaxed, natural posing," "true-to-color edit."
  Do NOT describe it as "candid" or "documentary."
- **Location framing:** lead with Duluth & Superior for SEO; base is "northwest Wisconsin" with a
  single light "Solon Springs" mention in the About bio. Don't headline Solon Springs.
- **Icons are inline SVG**, defined once per page as a hidden sprite (`<svg class="svg-sprite">`,
  ids `#ic-*`) and used via `<svg class="ic"><use href="#ic-name"></use></svg>`, styled by `.ic`.
  **Do not reintroduce Font Awesome or any external icon font.**
- **Fonts:** Cormorant Garamond (display headings), Lato (body/UI), Signatura Monoline Script
  (the wordmark/logo only). Keep the brand palette (olive #48503a, sage #6b7753, sand #c2b59e,
  cream #e2d4c3).
- **Scroll reveal** is gated behind a `.js` class on `<html>` (added by an inline script in each
  `<head>`), so content is always visible without JS. Don't hide content with bare `opacity:0`.
- **Contact form** posts to Formspree endpoint `mleqvgpz`. Keep it. There is a honeypot anti-spam field.
- **Mobile CTA:** a persistent "Inquire" bar (`.mobile-cta`) shows on small screens on home/portfolio/about.

## Testimonials
The testimonials section on `index.html` is **commented out** and contains clearly-labeled
placeholders. There are **no fabricated reviews**, and there is intentionally **no Review/
AggregateRating schema** until real reviews exist (fake review markup violates Google policy).
When real quotes arrive: replace the placeholders, remove the comment markers, and add Review schema.

## SEO
- Each page has its own title, meta description, canonical, Open Graph, and JSON-LD
  (home: LocalBusiness + FAQPage; others: BreadcrumbList / ContactPage).
- `sitemap.xml` and `robots.txt` are maintained at root. Re-submit the sitemap in Google Search
  Console after major changes.
- Biggest remaining off-site levers (not code): Google Business Profile + reviews, directory
  listings (The Knot/WeddingWire/Zola), and venue/blog content for long-tail terms.

## When adding photos
1. Drop them in the right `assets/images/...` folder.
2. `npm run build` to optimize, then `node scripts/add-image-dims.mjs`.
3. Add the `<a class="masonry__item">` markup in `portfolio.html` with descriptive `alt` text.
