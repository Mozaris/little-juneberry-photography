# Little Juneberry Photography

Wedding photography website for **Little Juneberry Photography**, serving Duluth, MN,
Superior, WI, and couples across Minnesota & Wisconsin. A fast, static site hosted free on
GitHub Pages.

## Pages
| File | Page |
| --- | --- |
| `index.html` | Home: hero, packages, timeline, testimonials, FAQ |
| `portfolio.html` | Wedding gallery (filterable + lightbox) |
| `about.html` | About Allie |
| `contact.html` | Inquiry form (Formspree) |

Everything else at the root (`wedding.html`, `family.html`, etc.) and in `pages/` are small
**redirect stubs** that send old/bookmarked links to the right new page so nothing breaks.

## The two commands you'll use

First time only, install the tools:

```bash
npm install
```

**Preview the site on your computer** (opens in your browser and auto-refreshes as you edit):

```bash
npm start
```

**Optimize images before publishing** (shrinks any large photos you add, safe to run anytime):

```bash
npm run build
```

## Publishing (it's free)

This site is hosted on **GitHub Pages**, so publishing is just:

```bash
git add .
git commit -m "Update site"
git push
```

A minute or two after you push, the live site updates automatically at
**littlejuneberryphotography.com**. No build step is required to publish; `npm run build`
is only for trimming image file sizes.

## Editing tips
- **Add photos:** drop them in `assets/images/portfolio/` (or `assets/images/wedding/`),
  run `npm run build` to optimize, then add an `<a class="masonry__item">…</a>` block in
  `portfolio.html`. Always include descriptive `alt` text; it helps Google.
- **Testimonials:** on `index.html`, search for `Couple Name, Venue` and replace the three
  placeholder quotes with real reviews.
- **Pricing:** edit the three package cards in `index.html` (search for `package__price`).
- **Show an email/phone:** in `contact.html`, uncomment the block marked
  "Want to show an email or phone publicly?" and add your details.
- **Colors & fonts:** all defined once at the top of `assets/css/styles.css` under `:root`.

## SEO notes
- Each page has its own title, description, Open Graph tags, and canonical URL.
- Structured data (JSON-LD) is included: LocalBusiness, FAQ, breadcrumbs.
- `sitemap.xml` and `robots.txt` are set up. After a big change, you can resubmit the
  sitemap in [Google Search Console](https://search.google.com/search-console).
