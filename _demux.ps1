Set-Location $PSScriptRoot

Get-ChildItem *.m2ts -Name | ForEach-Object {C:\Encoding\eac3to\eac3to.exe $_ -demux}

Get-ChildItem *.dtsma -Name | ForEach-Object {C:\Encoding\eac3to\eac3to.exe $_ "$_.flac"} # encode FLAC

# $eps = "01"
$eps = (1..12)
$eps = $eps | % {$_.ToString("00")}

function Audio-Batch ($ep) {
 C:\Encoding\eac3to\eac3to.exe "$ep.m2ts" 2: "$ep.flac" -log=nul # encode FLAC
 
 cmd /c "C:\Encoding\eac3to\eac3to.exe $ep.m2ts 3: stdout.wav -log=nul | C:\Encoding\qaac\qaac64.exe -v 192 --ignorelength --adts --no-delay -o $ep-2.aac -" # encode AAC (vcb-s)
 
 $ss = "00:00:00.000"
 $to = "00:23:42.004"
 C:\Encoding\ffmpeg.exe -i "$ep.aac" -ss $ss -to $to -c:a copy "$ep.aac" # trim audio
 
 cmd /c "C:\Encoding\ffmpeg.exe -i $ep.mkv -map a:0 -f wav pipe: | C:\Encoding\qaac\qaac64.exe -V 100 --ignorelength --adts --no-delay -o $ep.aac -" # encode AAC (lh)
}

ForEach ($ep in $eps) {Audio-Batch $ep}

Read-Host
