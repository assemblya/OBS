Clear-Host
$Host.UI.RawUI.WindowTitle = "OBS-Scanner"

function Show-MainMenu {
    Clear-Host
    Write-Host ""
    Write-Host " ██████╗ ██████╗ ███████╗     ███████╗ ██████╗ █████╗ ███╗   ██╗███╗   ██╗███████╗██████╗ " -ForegroundColor Cyan
    Write-Host "██╔═══██╗██╔══██╗██╔════╝     ██╔════╝██╔════╝██╔══██╗████╗  ██║████╗  ██║██╔════╝██╔══██╗" -ForegroundColor Cyan
    Write-Host "██║   ██║██████╔╝███████╗     ███████╗██║     ███████║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝" -ForegroundColor Cyan
    Write-Host "██║   ██║██╔══██╗╚════██║     ╚════██║██║     ██╔══██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗" -ForegroundColor Cyan
    Write-Host "╚██████╔╝██████╔╝███████║     ███████║╚██████╗██║  ██║██║ ╚████║██║ ╚████║███████╗██║  ██║" -ForegroundColor Cyan
    Write-Host " ╚═════╝ ╚═════╝ ╚══════╝     ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "============================================" -ForegroundColor DarkGray
    Write-Host " [1] Red Lotus Tools" -ForegroundColor Yellow
    Write-Host " [2] Custom Tools" -ForegroundColor Green
    Write-Host " [Q] Quit" -ForegroundColor Red
    Write-Host "============================================" -ForegroundColor DarkGray
}

function Run-BAMParser {
    Clear-Host
    Write-Host "Running BAM Parser..." -ForegroundColor Cyan
    $job = Start-Job -ScriptBlock {
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
        Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/spokwn/powershells/refs/heads/main/bamparser.ps1")
    }
    $spinner = @("|","/","-","\")
    $i = 0
    while ($job.State -eq "Running") {
        Write-Host -NoNewline "`rScanning $($spinner[$i % $spinner.Count])"
        Start-Sleep -Milliseconds 150
        $i++
    }
    Receive-Job $job | Out-Host
    Remove-Job $job
    Write-Host ""
    Write-Host "Press any key to return..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Run-RedLotusBam {
    Clear-Host
    Write-Host "Running Red Lotus BAM..." -ForegroundColor Magenta
    $job = Start-Job -ScriptBlock {
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
        Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/PureIntent/ScreenShare/main/RedLotusBam.ps1")
    }
    $spinner = @("|","/","-","\")
    $i = 0
    while ($job.State -eq "Running") {
        Write-Host -NoNewline "`rScanning $($spinner[$i % $spinner.Count])"
        Start-Sleep -Milliseconds 150
        $i++
    }
    Receive-Job $job | Out-Host
    Remove-Job $job
    Write-Host ""
    Write-Host "Press any key to return..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Run-FullSigCheck {
    Clear-Host
    Write-Host "Running Full sig check..." -ForegroundColor Cyan
    $job = Start-Job -ScriptBlock {
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
        Invoke-Expression (Invoke-RestMethod "https://github.com/assemblya/OBS/raw/refs/heads/main/Projector.ps1")
    }
    $spinner = @("|","/","-","\")
    $i = 0
    while ($job.State -eq "Running") {
        Write-Host -NoNewline "`rScanning $($spinner[$i % $spinner.Count])"
        Start-Sleep -Milliseconds 150
        $i++
    }
    Receive-Job $job | Out-Host
    Remove-Job $job
    Write-Host ""
    Write-Host "Press any key to return..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-RedLotusPage {
    while ($true) {
        Clear-Host
        Write-Host "===== Red Lotus Tools =====" -ForegroundColor Magenta
        Write-Host ""
        Write-Host " [1] Run BAM Parser" -ForegroundColor Cyan
        Write-Host " [2] Run Red Lotus BAM" -ForegroundColor Cyan
        Write-Host " [B] Back to Main Menu" -ForegroundColor Yellow
        Write-Host " [Q] Quit" -ForegroundColor Red
        Write-Host ""
        $choice = Read-Host "Select an option"
        switch ($choice.ToUpper()) {
            "1" { Run-BAMParser }
            "2" { Run-RedLotusBam }
            "B" { return }
            "Q" { exit }
        }
    }
}

function Show-CustomToolsPage {
    while ($true) {
        Clear-Host
        Write-Host "===== Custom Tools =====" -ForegroundColor Green
        Write-Host ""
        Write-Host " [1] Full sig check" -ForegroundColor Cyan
        Write-Host " [B] Back to Main Menu" -ForegroundColor Yellow
        Write-Host " [Q] Quit" -ForegroundColor Red
        Write-Host ""
        $choice = Read-Host "Select an option"
        switch ($choice.ToUpper()) {
            "1" { Run-FullSigCheck }
            "B" { return }
            "Q" { exit }
        }
    }
}

while ($true) {
    Show-MainMenu
    $choice = Read-Host "Select an option"
    switch ($choice.ToUpper()) {
        "1" { Show-RedLotusPage }
        "2" { Show-CustomToolsPage }
        "Q" { exit }
    }
}

$whitelist = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/assemblya/OBS/main/whitelisted.txt" -UseBasicParsing).Content -split "`r?`n" | Where-Object { $_.Trim() -ne '' }

$results = foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
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
Write-Host "Saved to: $downloads\UnsignedEXEs_Filtered.txt" -ForegroundColor Green
