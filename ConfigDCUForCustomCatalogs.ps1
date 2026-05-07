

Clear-Host


$DCU = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"


& $DCU /configure -allowXML=enable
Start-Sleep -Seconds 2
& $DCU /configure -catalogLocation="c:\temp5\P3460_MH.xml"
start-sleep -Seconds 2
& $DCU /configure -defaultSourceLocation=disable



