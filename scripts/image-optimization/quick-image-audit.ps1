# Simple Image Optimization Script
# Compress large images to improve website performance

Write-Host "=== Image Optimization for Little Juneberry Photography ===" -ForegroundColor Cyan

# Check current large images
$portfolioPath = "assets\images\portfolio"
$largeImages = Get-ChildItem -Path $portfolioPath -Filter "*.jpg" | Where-Object { $_.Length -gt 500KB }

Write-Host "Found $($largeImages.Count) images over 500KB that need optimization:" -ForegroundColor Yellow

foreach ($img in $largeImages) {
    $sizeKB = [math]::Round($img.Length / 1KB, 2)
    Write-Host "- $($img.Name): $sizeKB KB" -ForegroundColor White
}

Write-Host "`nRecommended optimization steps:" -ForegroundColor Cyan
Write-Host "1. Use an image editor to resize images to max 1920px width" -ForegroundColor White
Write-Host "2. Compress quality to 80-85%" -ForegroundColor White  
Write-Host "3. Target file size under 300KB each" -ForegroundColor White
Write-Host "4. Convert to WebP format for even better compression" -ForegroundColor White

Write-Host "`nOnline tools you can use:" -ForegroundColor Green
Write-Host "- TinyPNG (tinypng.com)" -ForegroundColor White
Write-Host "- Squoosh (squoosh.app)" -ForegroundColor White
Write-Host "- Compressor.io" -ForegroundColor White

$totalCurrentSize = ($largeImages | Measure-Object Length -Sum).Sum
$totalCurrentSizeKB = [math]::Round($totalCurrentSize / 1KB, 2)
$estimatedOptimizedSize = $totalCurrentSizeKB * 0.3  # Estimate 70% reduction

Write-Host "`nPotential savings:" -ForegroundColor Cyan
Write-Host "Current size: $totalCurrentSizeKB KB" -ForegroundColor White
Write-Host "Estimated after optimization: $([math]::Round($estimatedOptimizedSize, 2)) KB" -ForegroundColor Green
Write-Host "Potential savings: $([math]::Round($totalCurrentSizeKB - $estimatedOptimizedSize, 2)) KB" -ForegroundColor Green

Write-Host "`nThis optimization will significantly improve your website loading speed!" -ForegroundColor Green
