# Favicon Regeneration Script
# This script helps regenerate favicons with better centering

Write-Host "Favicon Regeneration Helper" -ForegroundColor Green
Write-Host "Current favicon source: assets\images\favicon.png" -ForegroundColor Yellow

# Check if source favicon exists
if (Test-Path "assets\images\favicon.png") {
    Write-Host "Source favicon found" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "RECOMMENDATIONS:" -ForegroundColor Cyan
    Write-Host "1. The source favicon (favicon.png) should be a square image (512x512 or 1024x1024)"
    Write-Host "2. The logo should be centered with some padding around the edges"
    Write-Host "3. Background should be transparent or match your brand color"
    Write-Host ""
    Write-Host "CURRENT ISSUE:" -ForegroundColor Red
    Write-Host "The favicon appears cropped because the source image might not be properly centered"
    Write-Host "or the logo extends too close to the edges of the source image."
    Write-Host ""
    Write-Host "SOLUTIONS:" -ForegroundColor Yellow
    Write-Host "Option 1: Edit the source favicon.png to add more padding around the logo"
    Write-Host "Option 2: Use an online favicon generator with the current source"
    Write-Host "Option 3: Create a new square version of your logo with proper centering"
    Write-Host ""
    Write-Host "ONLINE FAVICON GENERATORS:" -ForegroundColor Cyan
    Write-Host "- https://favicon.io/favicon-generator/"
    Write-Host "- https://realfavicongenerator.net/"
    Write-Host "- https://www.favicon-generator.org/"
    Write-Host ""
    
    # Show current favicon files
    Write-Host "Current favicon files:" -ForegroundColor Green
    Get-ChildItem "assets\icons\favicon*" | ForEach-Object {
        $sizeKB = [math]::Round($_.Length/1024, 2)
        Write-Host "  - $($_.Name) ($sizeKB KB)"
    }
} else {
    Write-Host "Source favicon not found!" -ForegroundColor Red
}

Write-Host ""
Write-Host "Would you like to:" -ForegroundColor Yellow
Write-Host "1. Keep current favicons and make manual adjustments"
Write-Host "2. Use an online generator to create new ones"
Write-Host "3. Edit the source image first"
