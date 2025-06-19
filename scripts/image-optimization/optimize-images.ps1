# Image Optimization Script for Little Juneberry Photography
# This script compresses large images to improve website performance

param(
    [string]$ImagePath = "assets\images\portfolio",
    [int]$MaxWidth = 1920,
    [int]$Quality = 85,
    [int]$MaxSizeKB = 500
)

Write-Host "=== Little Juneberry Photography - Image Optimization ===" -ForegroundColor Cyan
Write-Host "Starting image optimization process..." -ForegroundColor Green

# Check if ImageMagick is available
$magickAvailable = $false
try {
    $null = magick -version
    $magickAvailable = $true
    Write-Host "✓ ImageMagick found - will use for optimization" -ForegroundColor Green
} catch {
    Write-Host "⚠ ImageMagick not found - will provide alternative solutions" -ForegroundColor Yellow
}

# Get all portfolio images
$portfolioPath = Join-Path $PWD $ImagePath
if (-not (Test-Path $portfolioPath)) {
    Write-Host "❌ Portfolio path not found: $portfolioPath" -ForegroundColor Red
    exit 1
}

$images = Get-ChildItem -Path $portfolioPath -Filter "*.jpg" | Sort-Object Name
Write-Host "Found $($images.Count) images to analyze" -ForegroundColor Cyan

# Analyze current sizes
$largeImages = @()
$totalSizeBefore = 0

foreach ($image in $images) {
    $sizeKB = [math]::Round(($image.Length / 1KB), 2)
    $totalSizeBefore += $sizeKB
    
    if ($sizeKB -gt $MaxSizeKB) {
        $largeImages += [PSCustomObject]@{
            Name = $image.Name
            Path = $image.FullName
            CurrentSizeKB = $sizeKB
            ReductionNeeded = $true
        }
        Write-Host "⚠ Large image: $($image.Name) - $sizeKB KB" -ForegroundColor Yellow
    }
}

Write-Host "`nSummary:" -ForegroundColor Cyan
Write-Host "Total images: $($images.Count)"
Write-Host "Total size: $([math]::Round($totalSizeBefore, 2)) KB"
Write-Host "Images over $MaxSizeKB KB: $($largeImages.Count)"

if ($largeImages.Count -eq 0) {
    Write-Host "✓ All images are already optimized!" -ForegroundColor Green
    exit 0
}

# Create backup folder
$backupPath = Join-Path $portfolioPath "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
Write-Host "Created backup folder: $backupPath" -ForegroundColor Green

if ($magickAvailable) {
    Write-Host "`nOptimizing images with ImageMagick..." -ForegroundColor Cyan
    
    foreach ($img in $largeImages) {
        Write-Host "Processing: $($img.Name)..." -ForegroundColor White
        
        # Backup original
        Copy-Item $img.Path $backupPath
        
        # Optimize image
        $tempPath = $img.Path + ".tmp"
        try {
            # Resize and compress
            & magick $img.Path -resize "${MaxWidth}x${MaxWidth}>" -quality $Quality $tempPath
            
            # Check if optimization was successful
            if (Test-Path $tempPath) {
                $newSize = [math]::Round(((Get-Item $tempPath).Length / 1KB), 2)
                $reduction = [math]::Round((($img.CurrentSizeKB - $newSize) / $img.CurrentSizeKB * 100), 1)
                
                # Replace original with optimized version
                Move-Item $tempPath $img.Path -Force
                
                Write-Host "  ✓ $($img.Name): $($img.CurrentSizeKB) KB → $newSize KB (-$reduction%)" -ForegroundColor Green
            } else {
                Write-Host "  ❌ Failed to optimize $($img.Name)" -ForegroundColor Red
            }
        } catch {
            Write-Host "  ❌ Error optimizing $($img.Name): $($_.Exception.Message)" -ForegroundColor Red
            if (Test-Path $tempPath) { Remove-Item $tempPath -Force }
        }
    }
} else {
    Write-Host "`n=== Manual Optimization Required ===" -ForegroundColor Yellow
    Write-Host "Since ImageMagick is not available, please manually optimize these images:" -ForegroundColor White
    
    foreach ($img in $largeImages) {
        Write-Host "• $($img.Name) - Current: $($img.CurrentSizeKB) KB - Target: under $MaxSizeKB KB" -ForegroundColor White
    }
    
    Write-Host "`nRecommended tools:" -ForegroundColor Cyan
    Write-Host "• Online: TinyPNG, Squoosh.app, Compressor.io"
    Write-Host "• Desktop: GIMP, Paint.NET, Photoshop"
    Write-Host "• Install ImageMagick: https://imagemagick.org/script/download.php#windows"
    
    Write-Host "`nOptimization settings:" -ForegroundColor Cyan
    Write-Host "• Max width: $MaxWidth pixels"
    Write-Host "• Quality: $Quality%"
    Write-Host "• Target size: under $MaxSizeKB KB each"
}

# Final summary
$finalImages = Get-ChildItem -Path $portfolioPath -Filter "*.jpg"
$totalSizeAfter = ($finalImages | Measure-Object Length -Sum).Sum / 1KB

Write-Host "`n=== Optimization Complete ===" -ForegroundColor Green
Write-Host "Images processed: $($largeImages.Count)"
Write-Host "Total size before: $([math]::Round($totalSizeBefore, 2)) KB"
Write-Host "Total size after: $([math]::Round($totalSizeAfter, 2)) KB"
if ($totalSizeBefore -gt 0) {
    $totalReduction = [math]::Round((($totalSizeBefore - $totalSizeAfter) / $totalSizeBefore * 100), 1)
    Write-Host "Total reduction: $totalReduction%" -ForegroundColor Green
}

Write-Host "`nBackup location: $backupPath" -ForegroundColor Cyan
Write-Host "Optimization complete! Your website should load faster now." -ForegroundColor Green
