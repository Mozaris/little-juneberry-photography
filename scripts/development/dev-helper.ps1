# Little Juneberry Photography - Development Helper Script

# This script helps with common development tasks

Write-Host "Little Juneberry Photography - Development Helper" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Green

# Function to check if files exist
function Test-ProjectStructure {
    Write-Host "`nChecking project structure..." -ForegroundColor Yellow
    
    $requiredFiles = @(
        "index.html",
        "assets\css\main.css",
        "assets\js\main.js",
        "includes\header.html",
        "includes\footer.html"
    )
    
    $allExist = $true
    foreach ($file in $requiredFiles) {
        if (Test-Path $file) {
            Write-Host "✓ $file exists" -ForegroundColor Green
        } else {
            Write-Host "✗ $file missing" -ForegroundColor Red
            $allExist = $false
        }
    }
    
    if ($allExist) {
        Write-Host "`nProject structure is complete!" -ForegroundColor Green
    } else {
        Write-Host "`nSome files are missing. Check the PROJECT_STRUCTURE.md file." -ForegroundColor Red
    }
}

# Function to optimize images
function Optimize-Images {
    Write-Host "`nOptimizing images..." -ForegroundColor Yellow
    if (Test-Path "optimize-images.ps1") {
        & ".\optimize-images.ps1"
    } else {
        Write-Host "optimize-images.ps1 not found. Skipping image optimization." -ForegroundColor Yellow
    }
}

# Function to validate HTML
function Test-HTMLValidation {
    Write-Host "`nBasic HTML validation..." -ForegroundColor Yellow
    
    $htmlFiles = Get-ChildItem -Filter "*.html" -Name
    foreach ($file in $htmlFiles) {
        if ((Get-Content $file) -match "<!DOCTYPE html>") {
            Write-Host "✓ $file has DOCTYPE declaration" -ForegroundColor Green
        } else {
            Write-Host "✗ $file missing DOCTYPE declaration" -ForegroundColor Red
        }
    }
}

# Menu
do {
    Write-Host "`nSelect an option:" -ForegroundColor Cyan
    Write-Host "1. Check project structure"
    Write-Host "2. Optimize images"
    Write-Host "3. Validate HTML files"
    Write-Host "4. Open project in browser"
    Write-Host "5. Exit"
    
    $choice = Read-Host "Enter your choice (1-5)"
    
    switch ($choice) {
        "1" { Test-ProjectStructure }
        "2" { Optimize-Images }
        "3" { Test-HTMLValidation }
        "4" { 
            if (Test-Path "index.html") {
                Start-Process "index.html"
                Write-Host "Opening index.html in default browser..." -ForegroundColor Green
            } else {
                Write-Host "index.html not found!" -ForegroundColor Red
            }
        }
        "5" { 
            Write-Host "Goodbye!" -ForegroundColor Green
            break 
        }
        default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
    }
} while ($choice -ne "5")
