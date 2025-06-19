# Simple Image Optimizer for Little Juneberry Photography
# Uses Windows built-in .NET libraries to compress images

Write-Host "=== Image Optimization Starting ===" -ForegroundColor Green

# Parameters
$portfolioPath = "assets\images\portfolio"
$maxSizeKB = 500
$quality = 85
$maxWidth = 1920

# Check if portfolio folder exists
if (-not (Test-Path $portfolioPath)) {
    Write-Host "Portfolio folder not found: $portfolioPath" -ForegroundColor Red
    exit 1
}

# Load .NET assemblies for image processing
Add-Type -AssemblyName System.Drawing

# Find large images
$images = Get-ChildItem -Path $portfolioPath -Filter "*.jpg"
$largeImages = $images | Where-Object { $_.Length -gt ($maxSizeKB * 1KB) }

Write-Host "Found $($largeImages.Count) images that need optimization" -ForegroundColor Yellow

if ($largeImages.Count -eq 0) {
    Write-Host "All images are already optimized!" -ForegroundColor Green
    exit 0
}

# Create backup folder
$backupFolder = Join-Path $portfolioPath "backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
Write-Host "Backup folder created: $backupFolder" -ForegroundColor Cyan

# Process each large image
foreach ($image in $largeImages) {
    $originalSize = [math]::Round($image.Length / 1KB, 2)
    Write-Host "Processing: $($image.Name) ($originalSize KB)" -ForegroundColor White
    
    try {
        # Backup original
        Copy-Item $image.FullName $backupFolder
        
        # Load image
        $bitmap = [System.Drawing.Image]::FromFile($image.FullName)
        
        # Calculate new dimensions
        $newWidth = $bitmap.Width
        $newHeight = $bitmap.Height
        
        if ($bitmap.Width -gt $maxWidth) {
            $ratio = $maxWidth / $bitmap.Width
            $newWidth = $maxWidth
            $newHeight = [int]($bitmap.Height * $ratio)
        }
        
        # Create resized image
        $newBitmap = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($newBitmap)
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.DrawImage($bitmap, 0, 0, $newWidth, $newHeight)
        
        # Setup JPEG encoder with quality setting
        $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
        $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $quality)
        
        # Save optimized image
        $tempFile = $image.FullName + ".tmp"
        $newBitmap.Save($tempFile, $jpegCodec, $encoderParams)
        
        # Cleanup objects
        $bitmap.Dispose()
        $newBitmap.Dispose()
        $graphics.Dispose()
        
        # Replace original with optimized version
        Move-Item $tempFile $image.FullName -Force
        
        # Show results
        $newSize = [math]::Round((Get-Item $image.FullName).Length / 1KB, 2)
        $savings = [math]::Round(($originalSize - $newSize) / $originalSize * 100, 1)
        Write-Host "  ✓ Compressed: $originalSize KB → $newSize KB (-$savings%)" -ForegroundColor Green
        
    } catch {
        Write-Host "  ❌ Error processing $($image.Name): $($_.Exception.Message)" -ForegroundColor Red
        
        # Cleanup on error
        if ($bitmap) { $bitmap.Dispose() }
        if ($newBitmap) { $newBitmap.Dispose() }
        if ($graphics) { $graphics.Dispose() }
        if (Test-Path ($image.FullName + ".tmp")) {
            Remove-Item ($image.FullName + ".tmp") -Force
        }
    }
}

# Final summary
$finalImages = Get-ChildItem -Path $portfolioPath -Filter "*.jpg"
$totalSize = ($finalImages | Measure-Object Length -Sum).Sum / 1KB

Write-Host "`n=== Optimization Complete ===" -ForegroundColor Green
Write-Host "Total images: $($finalImages.Count)"
Write-Host "Total size now: $([math]::Round($totalSize, 2)) KB"
Write-Host "Backup location: $backupFolder"

# Show any remaining large files
$stillLarge = $finalImages | Where-Object { $_.Length -gt ($maxSizeKB * 1KB) }
if ($stillLarge.Count -gt 0) {
    Write-Host "`nFiles still over $maxSizeKB KB:" -ForegroundColor Yellow
    foreach ($file in $stillLarge) {
        $size = [math]::Round($file.Length / 1KB, 2)
        Write-Host "  $($file.Name): $size KB" -ForegroundColor White
    }
} else {
    Write-Host "`n✓ All images are now under $maxSizeKB KB!" -ForegroundColor Green
}

Write-Host "`nYour website should now load much faster! 🚀" -ForegroundColor Cyan
