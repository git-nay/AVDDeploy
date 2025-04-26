# install-apps-no-choco.ps1

$ErrorActionPreference = 'Stop'

function Install-AppFromWeb {
    param (
        [string]$Url,
        [string]$InstallerPath,
        [string]$Arguments
    )

    Write-Host "Downloading from $Url..."
    Invoke-WebRequest -Uri $Url -OutFile $InstallerPath

    Write-Host "Installing $InstallerPath..."
    Start-Process -FilePath $InstallerPath -ArgumentList $Arguments -Wait -NoNewWindow

    Remove-Item $InstallerPath -Force
}

# Create temp directory
$tempDir = "$env:TEMP\installs"
New-Item -Path $tempDir -ItemType Directory -Force | Out-Null

# --- Install Google Chrome ---
$chromeUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
Install-AppFromWeb -Url $chromeUrl -InstallerPath "$tempDir\chrome_installer.exe" -Arguments "/silent /install"

# --- Install Git ---
$gitUrl = "https://github.com/git-for-windows/git/releases/download/v2.45.1.windows.1/Git-2.45.1-64-bit.exe"
Install-AppFromWeb -Url $gitUrl -InstallerPath "$tempDir\git_installer.exe" -Arguments "/SILENT"

# --- Install Visual Studio Code ---
$vscodeUrl = "https://update.code.visualstudio.com/latest/win32-x64-user/stable"
Install-AppFromWeb -Url $vscodeUrl -InstallerPath "$tempDir\vscode_installer.exe" -Arguments "/VERYSILENT /NORESTART"

# --- Install 7-Zip ---
$zipUrl = "https://www.7-zip.org/a/7z2301-x64.exe"
Install-AppFromWeb -Url $zipUrl -InstallerPath "$tempDir\7zip_installer.exe" -Arguments "/S"

# --- Install Adobe Acrobat Pro with MST ---
$acrobatMsiUrl = "https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2300820415/AcroPro.msi"
$acrobatMstUrl = "https://github.com/git-nay/AVDDeploy/raw/refs/heads/main/AcroPro.mst"

$acrobatMsiPath = "$tempDir\AcroPro.msi"
$acrobatMstPath = "$tempDir\custom.mst"

Invoke-WebRequest -Uri $acrobatMsiUrl -OutFile $acrobatMsiPath
Invoke-WebRequest -Uri $acrobatMstUrl -OutFile $acrobatMstPath

Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$acrobatMsiPath`" TRANSFORMS=`"$acrobatMstPath`" /qn" -Wait -NoNewWindow

# Cleanup
Remove-Item $tempDir -Recurse -Force

Write-Host "All applications installed successfully."
