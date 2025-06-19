# Performance Monitoring Script for Little Juneberry Photography
# This script analyzes website performance and provides recommendations

param(
    [string]$SitePath = ".",
    [switch]$Detailed
)

Write-Host "=== Little Juneberry Photography - Performance Analysis ===" -ForegroundColor Cyan

# Function to analyze file sizes
function Get-FileSizeAnalysis {
    param([string]$Path, [string]$Extension)
    
    $files = Get-ChildItem -Path $Path -Filter "*.$Extension" -Recurse
    $totalSize = ($files | Measure-Object Length -Sum).Sum
    $avgSize = if ($files.Count -gt 0) { $totalSize / $files.Count } else { 0 }
    
    return [PSCustomObject]@{
        Type = $Extension.ToUpper()
        Count = $files.Count
        TotalSizeKB = [math]::Round($totalSize / 1KB, 2)
        AvgSizeKB = [math]::Round($avgSize / 1KB, 2)
        LargestFile = if ($files.Count -gt 0) { ($files | Sort-Object Length -Descending | Select-Object -First 1).Name } else { "None" }
        LargestSizeKB = if ($files.Count -gt 0) { [math]::Round(($files | Sort-Object Length -Descending | Select-Object -First 1).Length / 1KB, 2) } else { 0 }
    }
}

# Analyze different file types
$imageAnalysis = Get-FileSizeAnalysis -Path $SitePath -Extension "jpg"
$pngAnalysis = Get-FileSizeAnalysis -Path $SitePath -Extension "png"
$cssAnalysis = Get-FileSizeAnalysis -Path $SitePath -Extension "css"
$jsAnalysis = Get-FileSizeAnalysis -Path $SitePath -Extension "js"
$htmlAnalysis = Get-FileSizeAnalysis -Path $SitePath -Extension "html"

Write-Host "`n=== File Size Analysis ===" -ForegroundColor Green
$analyses = @($imageAnalysis, $pngAnalysis, $cssAnalysis, $jsAnalysis, $htmlAnalysis)
$analyses | Format-Table -AutoSize

# Check for performance optimizations
Write-Host "=== Performance Optimization Status ===" -ForegroundColor Green

# Check for lazy loading
$htmlFiles = Get-ChildItem -Path $SitePath -Filter "*.html" -Recurse
$lazyLoadingFiles = 0
$totalImages = 0

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    $imageMatches = [regex]::Matches($content, '<img[^>]*>')
    $lazyMatches = [regex]::Matches($content, 'loading="lazy"')
    
    $totalImages += $imageMatches.Count
    if ($lazyMatches.Count -gt 0) {
        $lazyLoadingFiles++
    }
}

$lazyLoadingPercent = if ($htmlFiles.Count -gt 0) { [math]::Round(($lazyLoadingFiles / $htmlFiles.Count) * 100, 1) } else { 0 }

Write-Host "✓ Lazy Loading Implementation: $lazyLoadingPercent% of HTML files ($lazyLoadingFiles/$($htmlFiles.Count))" -ForegroundColor $(if ($lazyLoadingPercent -gt 80) { "Green" } else { "Yellow" })

# Check for WebP images
$webpImages = Get-ChildItem -Path $SitePath -Filter "*.webp" -Recurse
$webpPercent = if ($imageAnalysis.Count -gt 0) { [math]::Round(($webpImages.Count / $imageAnalysis.Count) * 100, 1) } else { 0 }

Write-Host "✓ WebP Image Format: $webpPercent% coverage ($($webpImages.Count)/$($imageAnalysis.Count) images)" -ForegroundColor $(if ($webpPercent -gt 50) { "Green" } elseif ($webpPercent -gt 0) { "Yellow" } else { "Red" })

# Check for minification
$minifiedCSS = ($cssAnalysis.Count -gt 0) -and (Get-ChildItem -Path $SitePath -Filter "*.min.css" -Recurse).Count -gt 0
$minifiedJS = ($jsAnalysis.Count -gt 0) -and (Get-ChildItem -Path $SitePath -Filter "*.min.js" -Recurse).Count -gt 0

Write-Host "✓ CSS Minification: $(if ($minifiedCSS) { 'Enabled' } else { 'Not Detected' })" -ForegroundColor $(if ($minifiedCSS) { "Green" } else { "Yellow" })
Write-Host "✓ JS Minification: $(if ($minifiedJS) { 'Enabled' } else { 'Not Detected' })" -ForegroundColor $(if ($minifiedJS) { "Green" } else { "Yellow" })

# Check for compression
$gzipFiles = Get-ChildItem -Path $SitePath -Filter "*.gz" -Recurse
Write-Host "✓ Gzip Compression: $(if ($gzipFiles.Count -gt 0) { 'Detected' } else { 'Not Detected' })" -ForegroundColor $(if ($gzipFiles.Count -gt 0) { "Green" } else { "Yellow" })

# Performance Score Calculation
$performanceScore = 0
$maxScore = 100

# Image optimization (30 points)
if ($imageAnalysis.AvgSizeKB -lt 200) { $performanceScore += 15 }
elseif ($imageAnalysis.AvgSizeKB -lt 500) { $performanceScore += 10 }
elseif ($imageAnalysis.AvgSizeKB -lt 1000) { $performanceScore += 5 }

if ($webpPercent -gt 50) { $performanceScore += 15 }
elseif ($webpPercent -gt 20) { $performanceScore += 10 }
elseif ($webpPercent -gt 0) { $performanceScore += 5 }

# Lazy loading (20 points)
if ($lazyLoadingPercent -gt 80) { $performanceScore += 20 }
elseif ($lazyLoadingPercent -gt 50) { $performanceScore += 15 }
elseif ($lazyLoadingPercent -gt 20) { $performanceScore += 10 }

# Code optimization (25 points)
if ($minifiedCSS) { $performanceScore += 10 }
if ($minifiedJS) { $performanceScore += 10 }
if ($cssAnalysis.TotalSizeKB -lt 100) { $performanceScore += 5 }

# Resource optimization (25 points)
if ($gzipFiles.Count -gt 0) { $performanceScore += 10 }
$totalSizeKB = $imageAnalysis.TotalSizeKB + $cssAnalysis.TotalSizeKB + $jsAnalysis.TotalSizeKB
if ($totalSizeKB -lt 2000) { $performanceScore += 15 }
elseif ($totalSizeKB -lt 5000) { $performanceScore += 10 }
elseif ($totalSizeKB -lt 10000) { $performanceScore += 5 }

Write-Host "`n=== Performance Score ===" -ForegroundColor Cyan
$scoreColor = if ($performanceScore -gt 80) { "Green" } elseif ($performanceScore -gt 60) { "Yellow" } else { "Red" }
Write-Host "Overall Score: $performanceScore/$maxScore" -ForegroundColor $scoreColor

# Recommendations
Write-Host "`n=== Recommendations ===" -ForegroundColor Cyan

if ($imageAnalysis.AvgSizeKB -gt 500) {
    Write-Host "🔧 HIGH PRIORITY: Compress large images (current avg: $($imageAnalysis.AvgSizeKB) KB)" -ForegroundColor Red
    Write-Host "   Run: .\optimize-images.ps1" -ForegroundColor White
}

if ($webpPercent -lt 50) {
    Write-Host "🔧 MEDIUM PRIORITY: Convert images to WebP format for better compression" -ForegroundColor Yellow
    Write-Host "   Run: .\generate-webp.ps1" -ForegroundColor White
}

if ($lazyLoadingPercent -lt 80) {
    Write-Host "🔧 MEDIUM PRIORITY: Implement lazy loading on more pages" -ForegroundColor Yellow
}

if (-not $minifiedCSS -or -not $minifiedJS) {
    Write-Host "🔧 LOW PRIORITY: Consider minifying CSS and JavaScript files" -ForegroundColor Yellow
}

if ($totalSizeKB -gt 5000) {
    Write-Host "🔧 HIGH PRIORITY: Total page weight is high ($([math]::Round($totalSizeKB, 0)) KB)" -ForegroundColor Red
}

# Detailed analysis if requested
if ($Detailed) {
    Write-Host "`n=== Detailed File Analysis ===" -ForegroundColor Cyan
    
    # Show largest images
    $largeImages = Get-ChildItem -Path $SitePath -Filter "*.jpg" -Recurse | 
                   Sort-Object Length -Descending | 
                   Select-Object -First 10 | 
                   Select-Object Name, @{Name="SizeKB"; Expression={[math]::Round($_.Length/1KB, 2)}}
    
    Write-Host "`nLargest Images:" -ForegroundColor White
    $largeImages | Format-Table -AutoSize
    
    # Show page sizes
    Write-Host "HTML Page Analysis:" -ForegroundColor White
    $htmlFiles | Select-Object Name, 
                               @{Name="SizeKB"; Expression={[math]::Round($_.Length/1KB, 2)}}, 
                               @{Name="LastModified"; Expression={$_.LastWriteTime.ToString("yyyy-MM-dd")}} | 
                 Sort-Object SizeKB -Descending | 
                 Format-Table -AutoSize
}

Write-Host "`nPerformance analysis complete!" -ForegroundColor Green
Write-Host "Tip: Run this script with -Detailed flag for more information" -ForegroundColor Cyan
