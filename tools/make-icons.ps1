# Draws the web-app icons (same mark as the Android launcher icon): double gold diamond + seam on ink.
param([string]$Out = (Join-Path $PSScriptRoot '..\docs'))
Add-Type -AssemblyName System.Drawing
function Draw([int]$size, [string]$file, [double]$inset) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear([System.Drawing.Color]::FromArgb(255, 5, 8, 15))
  # 108-unit design canvas scaled into the icon; $inset shrinks it for the maskable safe zone
  $s = $size / 108.0 * (1 - $inset); $o = ($size - 108 * $s) / 2
  function P([double]$x, [double]$y) { New-Object System.Drawing.PointF ([float]($o + $x * $s)), ([float]($o + $y * $s)) }
  $gold = [System.Drawing.Color]::FromArgb(255, 242, 217, 156); $mid = [System.Drawing.Color]::FromArgb(255, 199, 163, 98)
  $p1 = New-Object System.Drawing.Pen $gold, ([float](2.6 * $s)); $p2 = New-Object System.Drawing.Pen $mid, ([float](1.4 * $s))
  $g.DrawPolygon($p1, [System.Drawing.PointF[]]@((P 54 25), (P 83 54), (P 54 83), (P 25 54)))
  $g.DrawPolygon($p2, [System.Drawing.PointF[]]@((P 54 34), (P 74 54), (P 54 74), (P 34 54)))
  $g.DrawLine($p2, (P 18 54), (P 34 54)); $g.DrawLine($p2, (P 74 54), (P 90 54))
  $b = New-Object System.Drawing.SolidBrush $gold
  $g.FillPolygon($b, [System.Drawing.PointF[]]@((P 54 46), (P 62 54), (P 54 62), (P 46 54)))
  $bmp.Save($file, [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $bmp.Dispose()
}
New-Item -ItemType Directory -Force $Out | Out-Null
Draw 192 (Join-Path $Out 'icon-192.png') 0
Draw 512 (Join-Path $Out 'icon-512.png') 0
Draw 512 (Join-Path $Out 'icon-maskable-512.png') 0.18
Draw 180 (Join-Path $Out 'apple-touch-icon.png') 0
"icons -> $Out"
