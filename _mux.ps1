Set-Location $PSScriptRoot

$title = "yagate"

# $eps = "01"
$eps = (1..12)
$eps = $eps | % {$_.ToString("00")}

function Mux-Batch ($title, $ep) {
 $filename = "[Airota&Nekomoe kissaten&LoliHouse] Yagate Kimi ni Naru - $ep [WebRip 1080p HEVC-yuv420p10 AAC ASSx2]"
 
 C:\Encoding\AssFontSubset.exe $PSScriptRoot\$title-$ep-sc.ass $PSScriptRoot\$title-$ep-tc.ass | Out-Null
 
 $merge_param = "--output", "$filename.mkv", `
 "--language", "0:und", "--default-track", "0:yes", "$title-$ep.hevc", `
 "--language", "0:jpn", "--default-track", "0:yes", "$title-$ep.aac", `
 "--language", "0:chi", "--default-track", "0:yes", "--track-name", "0:SC", "$PSScriptRoot\output\$title-$ep-sc.ass", `
 "--language", "0:chi", "--default-track", "0:no", "--track-name", "0:TC", "$PSScriptRoot\output\$title-$ep-tc.ass"
 
 Get-ChildItem -Path output -Exclude *.ass -Name | ForEach-Object {$merge_param += "--attach-file", "$PSScriptRoot\output\$_"}
 
 $merge_param | ConvertTo-Json | Out-File -Encoding "UTF8" options-file.json
 
 C:\Encoding\mkvtoolnix\mkvmerge.exe @options-file.json
 
 Remove-Item options-file.json
}

ForEach ($ep in $eps) {Mux-Batch $title $ep}

Read-Host