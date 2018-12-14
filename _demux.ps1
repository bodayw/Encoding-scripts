Set-Location $PSScriptRoot

$title = "uma"

# $eps = "01"
$eps = (1..12)
$eps = $eps | % {$_.ToString("00")}

function Demux-Batch ($title, $ep) {
 C:\Encoding\mkvtoolnix\mkvmerge.exe --output "$title-$ep.mkv" -A -S -B -T -M -d 0 "$title-$ep.m2ts"
 
 C:\Encoding\mkvtoolnix\mkvmerge.exe --output "$title-$ep.mks" -A -D -B -T -M -s 3 "$title-$ep.m2ts"
}

ForEach ($ep in $eps) {Demux-Batch $title $ep}

# $eps = "01"
$eps = (1..12)
$eps = $eps | % {$_.ToString("00")}

function Audio-Batch ($title, $ep) {
 C:\Encoding\eac3to\eac3to.exe "$title-$ep.m2ts" 2: "$title-$ep.flac" -log=nul # encode FLAC
 
 cmd /c "C:\Encoding\eac3to\eac3to.exe $title-$ep.m2ts 3: stdout.wav -log=nul | C:\Encoding\qaac\qaac64.exe -v 192 --ignorelength --adts --no-delay -o $title-$ep-2.aac -" # encode AAC (VCB-Studio)
 
 $ss = "00:00:00.000"
 $to = "00:23:42.004"
 C:\Encoding\ffmpeg.exe -i "$title-$ep.aac" -ss $ss -to $to -c:a copy "$title-$ep.aac" # trim audio
 
 cmd /c "C:\Encoding\ffmpeg.exe -i $title-$ep.mkv -map a:0 -f wav pipe: | C:\Encoding\qaac\qaac64.exe -V 100 --ignorelength --adts --no-delay -o $title-$ep.aac -" # encode AAC (LoliHouse)
}

ForEach ($ep in $eps) {Audio-Batch $title $ep}

Read-Host