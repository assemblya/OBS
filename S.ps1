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
    Write-Host "This may take a moment." -ForegroundColor DarkGray
    Write-Host ""

    $job = Start-Job -ScriptBlock {
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
        Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/spokwn/powershells/refs/heads/main/bamparser.ps1")
    }

    $spinner = @("|", "/", "-", "\")
    $i = 0

    while ($job.State -eq "Running") {
        Write-Host -NoNewline "`rScanning $($spinner[$i % $spinner.Count])"
        Start-Sleep -Milliseconds 150
        $i++
    }

    Receive-Job $job | Out-Host
    Remove-Job $job

    Write-Host ""
    Write-Host "✔ BAM Parser completed." -ForegroundColor Green
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
        Write-Host " [B] Back to Main Menu" -ForegroundColor Yellow
        Write-Host " [Q] Quit" -ForegroundColor Red
        Write-Host ""

        $choice = Read-Host "Select an option"

        switch ($choice.ToUpper()) {
            "1" { Run-BAMParser }
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
        Write-Host "Your custom tools will appear here." -ForegroundColor White
        Write-Host ""
        Write-Host " [B] Back to Main Menu" -ForegroundColor Yellow
        Write-Host " [Q] Quit" -ForegroundColor Red
        Write-Host ""

        $choice = Read-Host "Select an option"

        switch ($choice.ToUpper()) {
            "B" { return }
            "Q" { exit }
        }
    }
}

# Main loop
while ($true) {
    Show-MainMenu
    $choice = Read-Host "Select an option"

    switch ($choice.ToUpper()) {
        "1" { Show-RedLotusPage }
        "2" { Show-CustomToolsPage }
        "Q" { exit }
    }
}
