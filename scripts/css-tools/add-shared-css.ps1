# PowerShell script to add shared CSS to all HTML files
$htmlFiles = @(
    "contact.html",
    "wedding.html",
    "engagement.html",
    "family.html",
    "special-occasion.html",
    "services.html"
)

$cssLink = '  <!-- Header and Footer Shared Styles -->
  <link rel="stylesheet" href="assets/css/header-footer.css">'

foreach ($file in $htmlFiles) {
    if (Test-Path $file) {
        Write-Host "Processing $file..."
        
        # Read the file content
        $content = Get-Content $file -Raw
        
        # Find the last stylesheet link and add our CSS after it
        $content = $content -replace '(<link rel="stylesheet"[^>]*>)(?![\s\S]*<link rel="stylesheet")', "`$1`n$cssLink"
        
        # If no stylesheet found, add before </head>
        if ($content -notmatch 'header-footer\.css') {
            $content = $content -replace '</head>', "$cssLink`n</head>"
        }
        
        # Write back to file
        Set-Content $file $content -NoNewline
        
        Write-Host "Added shared CSS to $file"
    } else {
        Write-Host "File $file not found"
    }
}

Write-Host "CSS update completed!"
