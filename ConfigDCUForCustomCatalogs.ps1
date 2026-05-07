


clear-host

<#
        .Author
        Matt Harrington
        mqharrington@gmail.com

        .SYNOPSIS
        Configure Dell Command Update for custom downloads
         

        .DESCRIPTION
        This short script will configure Dell Command Update to run a custom catalog from the location you specify
           

        .PREREQUISITES
        n/a 
      

        .NOTES
        Important !!   -catalogLocation must exist.  In this example the file, P3460.xml must exist in that path for the setting to be set in DCU.
        DCU will actually check to see if the file exists

    #>


$DCU = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"


& $DCU /configure -allowXML=enable
Start-Sleep -Seconds 1
& $DCU /configure -catalogLocation="c:\temp\P3460.xml"
start-sleep -Seconds 1
& $DCU /configure -defaultSourceLocation=disable



