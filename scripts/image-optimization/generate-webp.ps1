# WebP Generation Script for Little Juneberry Photography
# This script creates WebP versions of images for better performance

param(
    [string]$ImagePath = "assets\images",
    [int]$Quality = 85
)

Write-Host "=== WebP Image Generation ===" -ForegroundColor Cyan

# Check if cwebp is available
$cwebpAvailable = $false
try {
    $null = cwebp -version 2>$null
    $cwebpAvailable = $true
    Write-Host "✓ cwebp found - will generate WebP images" -ForegroundColor Green
} catch {
    Write-Host "⚠ cwebp not found - will provide alternative solutions" -ForegroundColor Yellow
}

# Get all image files
$imagePath = Join-Path $PWD $ImagePath
$allImages = @()
$allImages += Get-ChildItem -Path $imagePath -Filter "*.jpg" -Recurse
$allImages += Get-ChildItem -Path $imagePath -Filter "*.jpeg" -Recurse
$allImages += Get-ChildItem -Path $imagePath -Filter "*.png" -Recurse

Write-Host "Found $($allImages.Count) images to convert" -ForegroundColor Cyan

if ($cwebpAvailable) {
    $converted = 0
    $totalSaved = 0
    
    foreach ($image in $allImages) {
        $webpPath = $image.FullName -replace '\.(jpg|jpeg|png)$', '.webp'
        
        # Skip if WebP already exists and is newer
        if ((Test-Path $webpPath) -and ((Get-Item $webpPath).LastWriteTime -gt $image.LastWriteTime)) {
            continue
        }
        
        Write-Host "Converting: $($image.Name)..." -ForegroundColor White
        
        try {
            & cwebp -q $Quality $image.FullName -o $webpPath
            
            if (Test-Path $webpPath) {
                $originalSize = $image.Length
                $webpSize = (Get-Item $webpPath).Length
                $savedBytes = $originalSize - $webpSize
                $savedPercent = [math]::Round(($savedBytes / $originalSize * 100), 1)
                
                Write-Host "  ✓ Saved $savedPercent% ($([math]::Round($savedBytes/1KB, 1)) KB)" -ForegroundColor Green
                
                $converted++
                $totalSaved += $savedBytes
            }
        } catch {
            Write-Host "  ❌ Failed to convert $($image.Name)" -ForegroundColor Red
        }
    }
    
    Write-Host "`n=== WebP Generation Complete ===" -ForegroundColor Green
    Write-Host "Images converted: $converted"
    Write-Host "Total space saved: $([math]::Round($totalSaved/1KB, 1)) KB"
    
} else {
    Write-Host "`n=== Manual WebP Generation Required ===" -ForegroundColor Yellow
    Write-Host "Install WebP tools to automatically generate WebP images:" -ForegroundColor White
    Write-Host "• Download: https://developers.google.com/speed/webp/download"
    Write-Host "• Or use online converters for key images"
    
    Write-Host "`nPriority images to convert:" -ForegroundColor Cyan
    $priorityImages = $allImages | Where-Object { $_.Length -gt 200KB } | Sort-Object Length -Descending | Select-Object -First 10
    foreach ($img in $priorityImages) {
        $sizeKB = [math]::Round($img.Length / 1KB, 1)
        Write-Host "• $($img.Name) - $sizeKB KB" -ForegroundColor White
    }
}

Write-Host "`nWebP generation process complete!" -ForegroundColor Green
