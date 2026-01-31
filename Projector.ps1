$whitelist = (Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/assemblya/OBS/main/whitelisted.txt" `
  -UseBasicParsing).Content `
  -split "`r?`n" |
  Where-Object { $_.Trim() -ne '' }

$drives = Get-PSDrive -PSProvider FileSystem |
          Where-Object { $_.Root -and (Test-Path $_.Root) }

$results = foreach ($drive in $drives) {
    Get-ChildItem $drive.Root -Recurse -File -Filter *.exe -ErrorAction SilentlyContinue |
    Where-Object {
        -not ($whitelist -contains $_.FullName) -and
        -not (Get-AuthenticodeSignature $_.FullName).SignerCertificate
    } |
    Select-Object -ExpandProperty FullName
}

$results | Out-File "$env:USERPROFILE\Desktop\UnsignedEXEs_Filtered.txt"
