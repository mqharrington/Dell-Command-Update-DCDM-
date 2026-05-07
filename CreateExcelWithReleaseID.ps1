

clear-host

<#
        .Author
        Matt Harrington
        mqharrington@gmail.com

        .SYNOPSIS
        Read CatalogPC.xml and write to Excel
         

        .DESCRIPTION
        This will read the CatalogPC.xml and write all data to Excel.   The following data will be written out
        ReleaseID,PackageID,Type,Category,Name,DellVersion,VendorVersion,ReleaseDate,Brand,DellModels,SystemIDs,DownloadURL
           

        .PREREQUISITES
        n/a 
      

        .NOTES
        Entire process assumes you are using Dell h/w and Dell Command Update 5.7

    #>

#  Install-Module ImportExcel -Scope CurrentUser -Force
#  you may need to install the above module



$XmlPath   = "C:\Dell\CatalogXML\CatalogPC.xml"
$ExcelPath = "C:\Dell\CatalogXML\DellReleaseCatalog.xlsx"

# Verify XML exists
if (-not (Test-Path $XmlPath)) {
    Write-Host "XML file not found: $XmlPath" -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Loading XML Catalog..."
[xml]$Catalog = Get-Content $XmlPath

Write-Host "Processing Dell Catalog..."
Write-Host ""

$Results = foreach ($Item in $Catalog.Manifest.SoftwareComponent) {

    # -----------------------------
    # Basic Metadata
    # -----------------------------

    $Name = $Item.Name.Display.'#cdata-section'
    $Type = $Item.ComponentType.Display.'#cdata-section'
    $Category = $Item.Category.Display.'#cdata-section'

    # -----------------------------
    # Supported Models
    # -----------------------------

    $ModelNames = @()
    $SystemIDs  = @()
    $Brands     = @()

    if ($Item.SupportedSystems.Brand) {

        foreach ($Brand in $Item.SupportedSystems.Brand) {

            $BrandName = $Brand.Display.'#cdata-section'

            if ($BrandName) {
                $Brands += $BrandName
            }

            foreach ($Model in $Brand.Model) {

                $ModelName = $Model.Display.'#cdata-section'

                if ($ModelName) {
                    $ModelNames += $ModelName
                }

                if ($Model.systemID) {
                    $SystemIDs += $Model.systemID
                }
            }
        }
    }

    # -----------------------------
    # Download URL
    # -----------------------------

    $DownloadURL = $null

    if ($Item.path) {
        $DownloadURL = "https://downloads.dell.com/$($Item.path)"
    }

    # -----------------------------
    # Create Object
    # -----------------------------

    [PSCustomObject]@{

        ReleaseID      = $Item.releaseID
        PackageID      = $Item.packageID

        Type           = $Type
        Category       = $Category

        Name           = $Name

        DellVersion    = $Item.dellVersion
        VendorVersion  = $Item.vendorVersion
        ReleaseDate    = $Item.releaseDate

        Brand          = ($Brands | Sort-Object -Unique) -join ", "

        DellModels     = ($ModelNames | Sort-Object -Unique) -join ", "

        SystemIDs      = ($SystemIDs | Sort-Object -Unique) -join ", "

        DownloadURL    = $DownloadURL
    }
}

Write-Host "Exporting to Excel..."
Write-Host ""

# Export to Excel
$Results |
Export-Excel `
    -Path $ExcelPath `
    -WorksheetName "DellCatalog" `
    -AutoSize `
    -AutoFilter `
    -FreezeTopRow `
    -BoldTopRow `
    -TableName "DellCatalog"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Excel Export Completed"
Write-Host "File:"
Write-Host $ExcelPath
Write-Host "========================================"