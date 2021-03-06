param($task = "default",[switch]$setup)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptPath

get-module psake | remove-module

.nuget\NuGet.exe restore .nuget\packages.config -OutputDirectory packages
import-module (Get-ChildItem "$scriptDir\packages\psake.*\tools\psake.psm1" | Select-Object -First 1)

if ($setup) {
    exec { invoke-psake "$scriptDir\default.ps1" chocolatey_install }
}

exec { invoke-psake "$scriptDir\default.ps1" $task }