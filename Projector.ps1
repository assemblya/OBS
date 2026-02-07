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
        $path = $_.FullName
        if ($whitelist -contains $path) { return $false }
        try {
            $sig = Get-AuthenticodeSignature $path -ErrorAction Stop
            -not $sig.SignerCertificate
        } catch {
            $false
        }
    } |
    Select-Object -ExpandProperty FullName
}

$downloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$results | Out-File "$downloads\UnsignedEXEs_Filtered.txt" -Encoding UTF8 -Force
