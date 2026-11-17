# Build RiftboundShowdown.apk with the portable tools on drive E.
# 1) wraps web\showdown-calc.html (artifact-style body, no <html>/<head>) into a full page in app assets
# 2) gradle assembleDebug  3) copies the APK to the project root
$ErrorActionPreference = 'Stop'
$tools = 'E:\android-build-tools'
$env:JAVA_HOME = "$tools\jdk"
$env:ANDROID_HOME = "$tools\sdk"
$env:GRADLE_USER_HOME = 'E:\gradle-cache'
Set-Location $PSScriptRoot

$src  = Join-Path $PSScriptRoot 'web\showdown-calc.html'
$dest = Join-Path $PSScriptRoot 'app\src\main\assets\index.html'
$body = [System.IO.File]::ReadAllText($src, [Text.Encoding]::UTF8)
# same minimal skeleton the artifact viewer provides: charset, viewport, safe-area padding, small reset
$head = @'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;font:14px system-ui,sans-serif}img{max-width:100%}[hidden]{display:none!important}</style>
</head>
<body>
'@
$utf8 = New-Object Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($dest, $head + $body + "`n</body>`n</html>`n", $utf8)

# GitHub Pages copy (docs/): same page + web-app manifest, icons and offline service worker
$pwaHead = $head.Replace('</head>', @'
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" type="image/png" href="icon-192.png">
<link rel="apple-touch-icon" href="apple-touch-icon.png">
<meta name="theme-color" content="#05080f">
<meta name="description" content="Showdown calculator for Riftbound: Might, effects and damage assignment for two players on one phone.">
</head>
'@)
$pwaFoot = "`n<script>if('serviceWorker' in navigator)addEventListener('load',()=>navigator.serviceWorker.register('sw.js').catch(()=>{}));</script>`n</body>`n</html>`n"
[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'docs\index.html'), $pwaHead + $body + $pwaFoot, $utf8)
if (-not (Test-Path (Join-Path $PSScriptRoot 'docs\icon-512.png'))) { & (Join-Path $PSScriptRoot 'tools\make-icons.ps1') }

& "$tools\gradle-8.7\bin\gradle.bat" assembleDebug --no-daemon --console=plain
if ($LASTEXITCODE -ne 0) { throw "Build failed ($LASTEXITCODE)" }
Copy-Item app\build\outputs\apk\debug\app-debug.apk RiftboundShowdown.apk -Force
Write-Host "OK -> $PSScriptRoot\RiftboundShowdown.apk"
