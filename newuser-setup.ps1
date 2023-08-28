#Ethan's Script for Automated Setup of Windows 10 Developer Machine

#Username and Password:
$username = "PlaceholderUser"								#replace with username
$password = ConvertTo-SecureString "Placeholder123!" -AsPlainText -Force 		#replace with password
Write-Output "User(s) Created..."



#Software Installation:
Write-Output "Commencing Software Installation..."

$installerDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition


$installers = @(									#Installers defined with silent switches 
    @{
	Message = "Installing Chrome...";
        Path = Join-Path -Path $installerDirectory -ChildPath "ChromeSetup.exe";
        Args = "/silent /install"
    },
    @{
	Message = "Installing Discord...";
        Path = Join-Path -Path $installerDirectory -ChildPath "DiscordSetup.exe";
        Args = "/silent"
    },
    @{
	Message = "Installing Git...";
        Path = Join-Path -Path $installerDirectory -ChildPath "Git-2.42.0-64-bit.exe";
        Args = "/SILENT"
    },
    @{
	Message = "Installing IntelliJ...";
        Path = Join-Path -Path $installerDirectory -ChildPath "ideaIU-2023.2.1.exe";
        Args = "/S /CONFIG=intellij-silent.config"
    },
    @{
	Message = "Installing PyCharm...";
        Path = Join-Path -Path $installerDirectory -ChildPath "pycharm-professional-2023.2.1.exe";
        Args = "/S /CONFIG=pycharm-silent.config"
    },
    @{
	Message = "Installing Adobe Reader...";
        Path = Join-Path -Path $installerDirectory -ChildPath "Reader_Install_Setup.exe";
        Args = "/sAll /msi EULA_ACCEPT=YES /quiet /passive /norestart"
    },
    @{
	Message = "Installing Telegram...";
        Path = Join-Path -Path $installerDirectory -ChildPath "tsetup-x64.4.9.2.exe";
        Args = "-noninteractive -silent"
    },
    @{
	Message = "Installing VirtualBox...";
        Path = Join-Path -Path $installerDirectory -ChildPath "VirtualBox-7.0.10-158379-Win.exe";
        Args = "--silent"
    },
    @{
	Message = "Installing VSCode...";
        Path = Join-Path -Path $installerDirectory -ChildPath "VSCodeUserSetup-x64-1.81.1.exe";
        Args = "/silent /mergetasks=!runcode"
    },
    @{
	Message = "Installing Office tools...";
        Path = Join-Path -Path $installerDirectory -ChildPath "setup.exe"; # Assuming ODT (Office Deployment Tool) is also in the folder
        Args = "/configure Configuration.xml"
    }
)


foreach ($installer in $installers) {
    Write-Output $installer.Message
    Start-Process -Wait -FilePath $installer.Path -ArgumentList $installer.Args		#Execute each installer in silent mode
}

Write-Output "Chrome, Discord, Git, IntelliJ, PyCharm, Adobe Reader, Telegram, VirtualBox, VSCode, and Microsoft Office tools have been downloaded..."




#Cleanup:

#Disable Telemetry, Diagnostic Data, App-launch tracking, and Targeted Ads:
Write-Output "Commencing Cleanup Stage 1..."
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f			#disable telemetry and data collection

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f		#disable diagnostic data

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0	#disable app launch tracking

Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0		#disable advertising id


reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithThirdParty" /t REG_DWORD /d "0" /f	#disable experiences/tailored experiences
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v "LetAppsRunWithAccount" /t REG_DWORD /d "0" /f

Start-Process -FilePath "ms-settings:privacy-advertising" -Wait									#clear advertising info
Start-Sleep -Seconds 2
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("{TAB 3}")
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

Write-Output "Telemetry, Diagnostic Data, App-launch tracking, and Targeted Ads disabled..."




#Disable Bing Search and Cortana:
Write-Output "Commencing Cleanup Stage 2..."
$bingSearchKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"							#disable bing search in start menu
if (-not (Test-Path $bingSearchKey)) {
    New-Item -Path $bingSearchKey -Force
}
Set-ItemProperty -Path $bingSearchKey -Name "BingSearchEnabled" -Value 0
Set-ItemProperty -Path $bingSearchKey -Name "CortanaConsent" -Value 0

$cortanaKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"							#disable cortana
if (-not (Test-Path $cortanaKey)) {
    New-Item -Path $cortanaKey -Force
}
Set-ItemProperty -Path $cortanaKey -Name "AllowCortana" -Value 0

Write-Output "Bing Search, Bing AI, and Cortana have been disabled in Windows Search..."




#Disable Tips, Tricks, Start Menu Suggestions and Sync Provider Ads:
Write-Output "Commencing Cleanup Stage 3..."
$tipKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"						#disable tips, tricks, and suggestions
if (-not (Test-Path $tipKey)) {
    New-Item -Path $tipKey -Force
}
Set-ItemProperty -Path $tipKey -Name "SoftLandingEnabled" -Value 0
Set-ItemProperty -Path $tipKey -Name "SubscribedContent-338387Enabled" -Value 0

$explorerAdsKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"						#disable sync provider ads
Set-ItemProperty -Path $explorerAdsKey -Name "ShowSyncProviderNotifications" -Value 0

Write-Output "Tips, tricks, suggestions, and sync provider notifications have been disabled..."



#Quality of Life:

#Show Hidden Files Folders and Drives:
Write-Output "Commencing Quality of Life Stage 1..."
$hiddenFilesKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"						#show hidden files and folders
Set-ItemProperty -Path $hiddenFilesKey -Name "Hidden" -Value 1
									
Set-ItemProperty -Path $hiddenFilesKey -Name "ShowSuperHidden" -Value 1								#show protected operating system files

Write-Output "Hidden files, folders, and drives are now visible..."

Write-Output "Script execution has completed...a restart is recommended..."