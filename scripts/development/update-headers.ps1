# PowerShell script to update headers in HTML files
$htmlFiles = @(
    "wedding.html",
    "engagement.html", 
    "family.html",
    "special-occasion.html",
    "services.html"
)

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        Write-Host "Processing $file..."
        
        # Read the file content
        $content = Get-Content $file -Raw
        
        # Replace header sections with placeholder
        $content = $content -replace '<!-- Header.*?</header>', '<!-- Header placeholder - loaded via JavaScript -->
  <div id="header-placeholder"></div>'
        
        # Add includes.js script before closing body tag if not already present
        if ($content -notmatch 'includes\.js') {
            $content = $content -replace '</body>', '  <!-- Include system -->
  <script src="assets/js/includes.js"></script>
</body>'
        }
        
        # Write back to file
        Set-Content $file $content -NoNewline
        
        Write-Host "Updated $file"
    } else {
        Write-Host "File $file not found"
    }
}

Write-Host "Header update completed!"
