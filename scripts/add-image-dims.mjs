// Adds intrinsic width/height to <img> tags that point at local images and
// don't already have them. This reserves layout space before images load,
// which cuts Cumulative Layout Shift (a Core Web Vitals / SEO factor).
// Run with: node scripts/add-image-dims.mjs

import { readFile, writeFile, stat } from 'node:fs/promises';
import sharp from 'sharp';

const ROOT = new URL('../', import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1');
const files = ['index.html', 'portfolio.html', 'about.html', 'contact.html'];

const dimCache = new Map();
async function dims(rel) {
  if (dimCache.has(rel)) return dimCache.get(rel);
  const path = ROOT + rel;
  try {
    await stat(path);
    const buf = await readFile(path);
    const m = await sharp(buf).metadata();
    const d = { w: m.width, h: m.height };
    dimCache.set(rel, d);
    return d;
  } catch {
    return null;
  }
}

let added = 0;
for (const file of files) {
  let html = await readFile(ROOT + file, 'utf8');
  const imgRe = /<img\b[^>]*>/g;
  const tags = html.match(imgRe) || [];
  for (const tag of tags) {
    if (/\bwidth=/.test(tag)) continue;            // already has dimensions
    const srcM = tag.match(/\bsrc="(assets\/images\/[^"]+)"/);
    if (!srcM) continue;
    const d = await dims(srcM[1]);
    if (!d) continue;
    const newTag = tag.replace(/^<img\b/, `<img width="${d.w}" height="${d.h}"`);
    html = html.replace(tag, newTag);
    added++;
  }
  await writeFile(ROOT + file, html);
}
console.log(`Added width/height to ${added} image tag(s).`);
