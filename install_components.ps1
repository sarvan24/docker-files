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

Write-Host "Checking if applications are installed..."

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


Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "Insufficient permissions to run this script. Open the PowerShell console as an administrator and run this script again."
Break
}
else {
Write-Host "Code is running as administrator — go on executing the script..." -ForegroundColor Green
}




Function Test-CommandExists
{
 Param ($command)
 $oldPreference = $ErrorActionPreference
 $ErrorActionPreference = ‘stop’
 try {if(Get-Command $command){“$command exists”}}
 Catch {“$command does not exist”}
 Finally {$ErrorActionPreference=$oldPreference}
} #end function test-CommandExists




## Check if AZ CLI tools have already been installed
## az --version
## If above command returns an error it likely means az cli has not been installed. Run the following command.
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi
## Test again & if test fails return error and ask to add a SNOW ticket to AA team.
## Check if AZ CLI tools have already been installed
## az --version


