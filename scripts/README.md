# Development Scripts

This folder contains PowerShell scripts organized by category to help with development tasks.

## Image Optimization
Scripts for compressing and optimizing images:
- `compress-images.ps1` - Compress existing images
- `generate-webp.ps1` - Generate WebP versions of images
- `optimize-images.ps1` - Main image optimization script
- `optimize-images-fixed.ps1` - Fixed version of optimization script
- `quick-image-audit.ps1` - Quick audit of image sizes
- `simple-compress.ps1` - Simple image compression

## Development Tools
Scripts for development tasks:
- `dev-helper.ps1` - Main development helper script
- `performance-audit.ps1` - Performance analysis
- `update-headers.ps1` - Update HTML headers
- `update-page-paths.ps1` - Update asset paths for reorganized pages

## CSS Tools
Scripts for CSS management:
- `add-shared-css.ps1` - Add shared CSS to pages
- `fix-css-order.ps1` - Fix CSS load order

## Usage
Run scripts from their respective directories or from the project root using relative paths.

Example:
```powershell
# From project root
.\scripts\image-optimization\compress-images.ps1

# From script directory
cd scripts\image-optimization
.\compress-images.ps1
```
