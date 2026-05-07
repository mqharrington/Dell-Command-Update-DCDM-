
clear-host

<#
        .Author
        Matt Harrington
        mqharrington@gmail.com

        .SYNOPSIS
        Download the Dell CatalogPC.cab that is used by Dell Command Update
         

        .DESCRIPTION
        This will download the catalogPC.cab file which contains the CatalogPC.xml.  That file has all Release ID's in it.  These Release ID's can then be added
        to the DCU .admx file (i.e. GPO's) or to DCU via CLI to block those Release ID's from installing when DCU runs.   
           

        .PREREQUISITES
        n/a 
      

        .NOTES
        Entire process assumes you are using Dell h/w and Dell Command Update 5.7

    #>

  # Dell CatalogPC.cab Download Script
  

$Url        = "https://dl.dell.com/catalog/CatalogPC.cab"
$FolderPath = "C:\Dell\CatalogXML"
$FilePath   = Join-Path $FolderPath "CatalogPC.cab"

# Create folder if needed
if (-not (Test-Path $FolderPath)) {
    New-Item -Path $FolderPath -ItemType Directory -Force | Out-Null
}

# Browser-like headers
$Headers = @{
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36"
}

Write-Host "Downloading Dell CatalogPC.cab..."
Write-Host "Source: $Url"
Write-Host "Destination: $FilePath"

try {
    Invoke-WebRequest `
        -Uri $Url `
        -Headers $Headers `
        -OutFile $FilePath

    Write-Host ""
    Write-Host "Download completed successfully." -ForegroundColor Green

    $FileInfo = Get-Item $FilePath

    Write-Host "Size : $([math]::Round($FileInfo.Length / 1MB,2)) MB"
    Write-Host "Path : $($FileInfo.FullName)"
}
catch {
    Write-Host ""
    Write-Host "Download FAILED" -ForegroundColor Red
    Write-Host $_.Exception.Message
}