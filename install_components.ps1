##RUN scipt as administrator
Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
else {
Write-Host "Code is running as administrator..." -ForegroundColor Green
}


# Set this value back at the end of the script to leave the system policy as we found it
$executionpolicy = $Get-ExecutionPolicy
#


#
$user = $env:UserName
$groups = 'az-nam-aam'

foreach ($group in $groups) {
    $members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SamAccountName

    If ($members -contains $user) {
        Write-Host "$user is a member of $group"
    } Else {
        Write-Host "$user is not a member of $group. Make a SNOW request to be added to AD Group: $groups"
    }
}
#


#$list=@()
#$InstalledSoftwareKey="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"
#$InstalledSoftware=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$pcname)
#$RegistryKey=$InstalledSoftware.OpenSubKey($InstalledSoftwareKey)
#$SubKeys=$RegistryKey.GetSubKeyNames()
#Foreach ($key in $SubKeys){
#$thisKey=$InstalledSoftwareKey+"\\"+$key
#$thisSubKey=$InstalledSoftware.OpenSubKey($thisKey)
#$obj = New-Object PSObject
#$obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $pcname
#$obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($thisSubKey.GetValue("DisplayName"))
#$obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($thisSubKey.GetValue("DisplayVersion"))
#$list += $obj
#}
#$list | where { $_.DisplayName } | select ComputerName, DisplayName, DisplayVersion | FT



Write-Host "Checking if applications are installed..."
try {
    Write-Host "Checking if AzureCLI is installed..."
    $azcliversion = Invoke-Expression "az --version"| Select -First 1
    Write-HOST "$azcliversion  found"
}
Catch
{
    Write-Host "az cli not available."
    Write-Host "Installing AzureCLI"
    $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
}


try {
    Write-Host "Checking if chocolatey package manager is installed..."
    $chocoversion = Invoke-Expression "choco --version"| Select -First 1
    Write-Host "choco $chocoversion found"
}
Catch
{
    Write-Host "Chocolatey Package Manager not available."
    Write-Host "Installing Choco"
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

try {
    Write-Host "Checking if helm package manager is installed..."
    $helmversion = Invoke-Expression "helm --version"| Select -First 1
    Write-Host "helm $helmversion  found"
}
Catch
{
    Write-Host "Helm Package Manager not available."
    Write-Host "Installing Helm"
    Invoke-Expression "choco install kubernetes-helm"
}


#
#TODO Set the execution policy back again $executionpolicy
#