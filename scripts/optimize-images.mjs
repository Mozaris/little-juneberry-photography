// Image optimizer for Little Juneberry Photography
// Run with: npm run build
//
// What it does: walks assets/images, and for any JPEG/PNG that is larger than
// the web needs (over ~2000px on the long edge OR over ~500 KB), it re-encodes
// a smaller, web-optimized version IN PLACE — but only if the result is actually
// smaller. Files that are already lean are skipped, so the command is safe to
// run again and again without degrading quality.

import { readdir, stat, readFile, writeFile } from 'node:fs/promises';
import { join, extname } from 'node:path';
import sharp from 'sharp';

const IMAGES_DIR = new URL('../assets/images/', import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, '$1');
const MAX_EDGE = 2000;        // px — plenty for full-screen display on modern screens
const SIZE_THRESHOLD = 500 * 1024; // 500 KB — only touch files heavier than this
const JPEG_QUALITY = 80;

let totalBefore = 0;
let totalAfter = 0;
let optimized = 0;
let skipped = 0;

async function walk(dir) {
  const entries = await readdir(dir, { withFileTypes: true });
  for (const entry of entries) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) {
      await walk(full);
    } else {
      const ext = extname(entry.name).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].includes(ext)) {
        await optimize(full, ext);
      }
    }
  }
}

async function optimize(file, ext) {
  const { size } = await stat(file);
  // Read the whole file into memory first so we never hold a read handle open
  // on the same path we're about to overwrite (avoids OneDrive/Windows locks).
  const input = await readFile(file);
  const meta = await sharp(input).metadata();
  const longEdge = Math.max(meta.width || 0, meta.height || 0);

  // Already lean enough — leave it alone.
  if (size <= SIZE_THRESHOLD && longEdge <= MAX_EDGE) {
    skipped++;
    return;
  }

  const pipeline = sharp(input)
    .rotate() // respect EXIF orientation
    .resize({ width: MAX_EDGE, height: MAX_EDGE, fit: 'inside', withoutEnlargement: true });

  const buffer = ext === '.png'
    ? await pipeline.png({ quality: JPEG_QUALITY, compressionLevel: 9 }).toBuffer()
    : await pipeline.jpeg({ quality: JPEG_QUALITY, mozjpeg: true }).toBuffer();

  // Only write if we actually saved space.
  if (buffer.length < size) {
    await writeFile(file, buffer);
    totalBefore += size;
    totalAfter += buffer.length;
    optimized++;
    const rel = file.slice(IMAGES_DIR.length);
    console.log(
      `  ✓ ${rel.padEnd(48)} ${(size / 1024).toFixed(0).padStart(6)} KB → ${(buffer.length / 1024).toFixed(0).padStart(6)} KB`
    );
  } else {
    skipped++;
  }
}

console.log('\nOptimizing images in assets/images …\n');
await walk(IMAGES_DIR);
console.log('\n──────────────────────────────────────────────');
console.log(`  Optimized: ${optimized} file(s)   Skipped: ${skipped} file(s)`);
if (optimized > 0) {
  const saved = (totalBefore - totalAfter) / 1024 / 1024;
  console.log(`  Saved:     ${saved.toFixed(2)} MB  (${(totalBefore / 1024 / 1024).toFixed(2)} MB → ${(totalAfter / 1024 / 1024).toFixed(2)} MB)`);
}
console.log('──────────────────────────────────────────────\n');
console.log('Done. Commit the changes and `git push` to publish to GitHub Pages.\n');
