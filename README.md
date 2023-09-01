# automated-usersetup
This repository contains a shell script used to automate the setup of a new user's Windows 10 development machine

* [Description](https://github.com/BrickFrisbee/automated-usersetup#description)
* [Prior to Execution](https://github.com/BrickFrisbee/automated-usersetup#prior-to-execution)
* [Creating New Users](https://github.com/BrickFrisbee/automated-usersetup#creating-new-users)
* [Software Installation](https://github.com/BrickFrisbee/automated-usersetup#software-installation)
* [Cleanup](https://github.com/BrickFrisbee/automated-usersetup#cleanup)
* [Quality of Life](https://github.com/BrickFrisbee/automated-usersetup#quality-of-life)


## Description
newuser-setup.ps1 is a script can be used to automatically create new windows users, download software using installers and configuration files, disable unnecessary windows features, add quality of life improvements. To start, the script uses `$username` and `$password` to create a new user. Next, the script uses a foreach loop to iterate over hashtables containing installers with necessary arguments. Following software installation, the script will begin three stages of cleanup: first, the script will disable telemetry, diagnostic data, app-launch tracking, and targeted ads; second, the script will disable bing search and cortana; third, the script will disable tips, tricks, start menu suggestions and sync provider ads. Finally, the script will execute quality of life improvements: hidden files, folders, and drives will be made visible. Additions can be implemented to each section to meet the needs of the user. 

*This script was tested on a Dell Latitude 7480*

## Prior to Execution...
Be sure the names of your installers, .config files (for jetbrains products), and .config file (for office) match the names of those referenced in the `Software Installation` section. I will include an image of my directory including my newuser-setup.ps1, .exe, .config, and .xml files. Rename either the files in your directory, or the references in the script. 


![alt text](https://github.com/BrickFrisbee/automated-usersetup/blob/main/images/directory.PNG "directory")

**FOR OFFICE 365:** Be sure to use the Office Deployment Tool to install `setup.exe` and the `Configuration.xml` file required for Office 365 installation. 

## Creating New Users
To create your own user, you can assign a string of your choice to `$username`. To create your own password, you can assign a string of your choice to `$password`. Below is an example, where a new user with the username "Brick" and the password "SecretCode!2" is created:
```
$username = "Brick"								
$password = ConvertTo-SecureString "SecretCode!2" -AsPlainText -Force 
```
Alternatively, you can create multiple users by iterating through an array `$users` of hash tables, similar to the structure of the software installation section. An example of the creation of two users, Brick and Frisbee, is shown below:
```
$users = @(
    @{
        Username = 'Brick'
        Password = 'SecretCode!2'
    },
    @{
        Username = 'Frisbee'
        Password = 'SecretCode!3'
    },
    #...add more users as needed
)

#Iterate through each user and create the account
foreach ($user in $users) {
    $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force
    New-LocalUser -Name $user.Username -Password $securePassword -Description "Generated User"
}
```
If successful, the following output should appear in powershell:
```
User(s) Created...
```

## Software Installation
Software Installation installs Chrome, Discord, Git, IntelliJ, PyCharm, Adobe, Adobe Reader, Telegram, VirtualBox, VSCode, and Microsoft Office. Similarly to creating multiple users, if the user requires additional software, more hashtables can be added to the `$installations` array. Depending on the isntaller, `silent` arguments can be included to avoid popups and user input. Be sure to include .config files and additional arguments if needed.

If successful, the following output should appear in powershell:
```
Commencing Software Installation...
Installing Chrome...
Installing Discord...
Installing Git...
Installing IntelliJ...
Installing PyCharm...
Installing Adobe Reader...
Installing Telegram...
Installing VirtualBox...
Installing VSCode...
Installing Office tools...
Chrome, Discord, Git, IntelliJ, PyCharm, Adobe Reader, Telegram, VirtualBox, VSCode, and Microsoft Office tools have been downloaded...
```

## Cleanup
Cleanup is executed in three stages. If successful, the following output should appear in powershell:
```
Commencing Cleanup Stage 1...
Telemetry, Diagnostic Data, App-launch tracking, and Targeted Ads disabled...
Commencing Cleanup Stage 2...
Bing Search, Bing AI, and Cortana have been disabled in Windows Search...
Commencing Cleanup Stage 3...
Tips, tricks, suggestions, and sync provider notifications have been disabled...
```

## Quality of Life
Quality of Life includes a single stage, however additional operations can be added depending on the requirements of the user. If successful, the following output should appear in powershell:
```
Commencing Quality of Life Stage 1...
Hidden files, folders, and drives are now visible...
```
The script is complete after Quality of Life has executed. Restart your machine after the following appears in powershell:
```
Script execution has completed...a restart is recommended...
```




