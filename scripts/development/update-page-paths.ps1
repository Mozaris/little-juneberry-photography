# Update asset paths for moved pages
# This script updates all asset references in pages moved to the pages/ folder

$pagesDir = "c:\Users\levie\Desktop\Nurses Compass Media\HTML\pages"
$htmlFiles = Get-ChildItem -Path $pagesDir -Filter "*.html"

foreach ($file in $htmlFiles) {
    Write-Host "Updating paths in: $($file.Name)" -ForegroundColor Green
    
    $content = Get-Content $file.FullName -Raw
    
    # Update asset paths
    $content = $content -replace 'href="assets/', 'href="../assets/'
    $content = $content -replace 'src="assets/', 'src="../assets/'
    $content = $content -replace 'url\("assets/', 'url("../assets/'
    $content = $content -replace "url\('assets/", "url('../assets/"
    
    # Update font paths
    $content = $content -replace 'src.*?fonts/', 'src="../fonts/'
    $content = $content -replace "url\('fonts/", "url('../fonts/"
    $content = $content -replace 'url\("fonts/', 'url("../fonts/'
    
    # Update includes paths
    $content = $content -replace 'src="includes/', 'src="../includes/'
    
    # Update navigation links to go back to root for main pages
    $content = $content -replace 'href="index.html"', 'href="../index.html"'
    $content = $content -replace 'href="about.html"', 'href="../about.html"'
    $content = $content -replace 'href="contact.html"', 'href="../contact.html"'
    
    # Save the updated content
    Set-Content -Path $file.FullName -Value $content -NoNewline
}

Write-Host "Path updates completed!" -ForegroundColor Green
