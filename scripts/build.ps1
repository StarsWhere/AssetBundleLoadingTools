[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$GameRoot)
$ErrorActionPreference = 'Stop'
$GameRoot = [IO.Path]::GetFullPath($GameRoot)
if ((Get-Content -LiteralPath (Join-Path $GameRoot 'BeatSaberVersion.txt') -Raw).Trim() -ne '1.45.2_28848') { throw 'Unsupported game build.' }
$root = Split-Path -Parent $PSScriptRoot
$obj = Join-Path $root '.tmp/obj/'
$out = Join-Path $root '.tmp/bin/'
& dotnet build (Join-Path $PSScriptRoot 'compat.csproj') -c Release ('-p:GameRoot=' + $GameRoot) ('-p:BaseIntermediateOutputPath=' + $obj) ('-p:OutputPath=' + $out) '-p:RestoreSources=https://api.nuget.org/v3/index.json'
if ($LASTEXITCODE -ne 0) { throw 'Compatibility build failed.' }
