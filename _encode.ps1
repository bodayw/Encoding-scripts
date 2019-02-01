Set-Location $PSScriptRoot

# $eps = "01"
$eps = (1..12)
$eps = $eps | % {$_.ToString("00")}

function Encode-Batch ($ep) {
 $filename = "[VCB-Studio] Uma Musume Pretty Derby [$ep][Ma10p_1080p][x265_flac]"
 
 cmd /c "C:\Encoding\vapoursynth\VSPipe.exe --y4m $ep.vpy - | C:\Encoding\x265-10b.exe --y4m -D 10 --preset slower --crf 16 --crf-max 32 --crf-min 0 --ctu 32 --qg-size 16 --ipratio 1.4 --pbratio 1.2 --cbqpoffs -3 --crqpoffs -3 --me 3 --subme 4 --merange 44 --ref 4 --rc-lookahead 70 --keyint 360 --min-keyint 1 --bframes 8 --aq-mode 3 --aq-strength 0.8 --rd 4 --psy-rd 1.3 --psy-rdoq 1.0 --rdoq-level 2 --scenecut 40 --qcomp 0.65 --deblock -2:-2 --b-intra --weightb --rect --no-sao --no-amp --no-strong-intra-smoothing --no-open-gop --limit-tu 0 --vbv-bufsize 36000 --vbv-maxrate 30000 --colormatrix bt709 --output $ep.hevc -"
 
 C:\Encoding\mkvtoolnix\mkvmerge.exe --output "$filename.mkv" `
 --language 0:und --default-track 0:yes "$ep.hevc" `
 --language 0:jpn --default-track 0:yes --track-name 0:"2.0ch" "$ep.flac" `
 --language 0:jpn --default-track 0:yes "$ep.sup" `
 --chapter-language eng --chapters "$ep.txt"
 
 $hash = C:\Encoding\crc32.exe "$filename.mkv"
 Rename-Item -LiteralPath "$PSScriptRoot\$filename.mkv" "$filename[$hash].mkv"
 
 C:\Encoding\mkvtoolnix\mkvmerge.exe --output "$filename.mka" `
 --language 0:jpn --default-track 0:yes --track-name 0:"5.1ch" "$ep-2.flac"
 
 $hash = C:\Encoding\crc32.exe "$filename.mka"
 Rename-Item -LiteralPath "$PSScriptRoot\$filename.mka" "$filename[$hash].mka"
}

ForEach ($ep in $eps) {Encode-Batch $ep}

Read-Host
