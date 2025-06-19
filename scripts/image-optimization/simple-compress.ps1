# Image Compressor - Simple Version
param([int]$Quality = 85)

Write-Host "Starting image compression..." -ForegroundColor Green

# Load .NET imaging
Add-Type -AssemblyName System.Drawing

$path = "assets\images\portfolio"
$maxKB = 500

# Find large images
$large = Get-ChildItem $path -Filter "*.jpg" | Where-Object {$_.Length -gt ($maxKB * 1024)}

Write-Host "Found $($large.Count) large images to compress" -ForegroundColor Yellow

if($large.Count -eq 0) {
    Write-Host "No images need compression!" -ForegroundColor Green
    exit
}

# Create backup
$backup = Join-Path $path "backup-$(Get-Date -Format 'MMdd-HHmm')"
mkdir $backup -Force | Out-Null
Write-Host "Backup: $backup" -ForegroundColor Cyan

foreach($img in $large) {
    $size1 = [math]::Round($img.Length/1KB, 1)
    Write-Host "Compressing: $($img.Name) ($size1 KB)"
    
    # Backup original
    copy $img.FullName $backup
    
    # Load and compress
    $bmp = [System.Drawing.Image]::FromFile($img.FullName)
    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object {$_.MimeType -eq "image/jpeg"}
    $params = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, $Quality)
    
    $temp = $img.FullName + ".tmp"
    $bmp.Save($temp, $codec, $params)
    $bmp.Dispose()
    
    # Replace original
    move $temp $img.FullName -Force
    
    $size2 = [math]::Round((Get-Item $img.FullName).Length/1KB, 1)
    $saved = [math]::Round(($size1-$size2)/$size1*100, 1)
    Write-Host "  $size1 KB -> $size2 KB (-$saved%)" -ForegroundColor Green
}

Write-Host "Compression complete!" -ForegroundColor Green
