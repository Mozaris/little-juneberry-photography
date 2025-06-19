# PowerShell script to fix CSS loading order on all pages
$htmlFiles = @(
    "index.html",
    "about.html", 
    "contact.html",
    "portfolio.html",
    "wedding.html",
    "engagement.html",
    "family.html",
    "special-occasion.html"
)

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        Write-Host "Fixing CSS loading order in $file..."
        
        # Read the file content
        $content = Get-Content $file -Raw
        
        # Remove existing header-footer.css link
        $content = $content -replace '.*header-footer\.css.*\n?', ''
        
        # Add header-footer.css just before </head> to ensure it loads last
        $content = $content -replace '</head>', '  <!-- Header and Footer Shared Styles - loaded last to override page-specific styles -->
  <link rel="stylesheet" href="assets/css/header-footer.css">
</head>'
        
        # Write back to file
        Set-Content $file $content -NoNewline
        
        Write-Host "Fixed $file"
    } else {
        Write-Host "File $file not found"
    }
}

Write-Host "CSS loading order fix completed!"
