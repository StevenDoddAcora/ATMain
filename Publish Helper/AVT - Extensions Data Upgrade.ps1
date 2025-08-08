Enter-NavContainer dynamicsnav110r17

#Use it if you have problem with symbols
exit
$navServicecredential       = New-Object System.Management.Automation.PSCredential -argumentList "admin", (ConvertTo-SecureString -String "P@ssword1" -AsPlainText -Force)
Compile-ObjectsInNavContainer -containerName EM-R12-NAV -filter "Type=Codeunit" -sqlCredential $navServicecredential

#Compile-NAVApplicationObject -NavServerInstance NAV -Filter 'Type=Page' -Recompile -Username dockeruser -Password (ConvertTo-SecureString 'dockeruser' -AsPlainText -Force)
#$navServicecredential       = New-Object System.Management.Automation.PSCredential -argumentList "admin", (ConvertTo-SecureString -String "P@ssword1" -AsPlainText -Force)
#-DatabaseName CronusGB -NavServerName .\SQLEXPRESS

#Get-NAVAppInfo NAV 
#Start-NAVAppDataUpgrade -Name $p1name -ServerInstance NAV
#Start-NAVAppDataUpgrade -Name $p2name -ServerInstance NAV
#Sync-NAVTenant -ServerInstance NAV


///////////////////////////////////////////////////////////
#Uninstall:=  Uninstall-NAVApp -ServerInstance DynamicsNAV110 -Name My extension -Version 1.0.0.0 
#Unpublish:= Unpublish-NAVApp -ServerInstance DynamicsNAV110 -Name My extension -Version 1.0.0.0 
#Publish:= Publish-NAVApp -ServerInstance DynamicsNAV110 –Path  path of .app –SkipVerification 
#Synchronize:= Sync-NAVApp -ServerInstance DynamicsNAV110 -Name Myextension -Version 1.1.0.0 
#Install:= Install-NAVApp -ServerInstance DynamicsNAV110 -Name Myextension

Set-ExecutionPolicy unrestricted

#Import-module 'C:\Program Files\Microsoft Dynamics NAV\110\Service\NavAdminTool.ps1'

Set-Location 'M:\Projects\AVT\Extensions\'

#Initial
$p1currVersion = '1.2.0.2018'
$p1newVersion = '1.2.0.2018'
$p1name = 'Avtrade Initial Specification';

#P2
$p2currVersion = '1.2.0.2018'
$p2newVersion = '1.2.0.2018'
$p2name = 'Avtrade Custom Reports and Ext. Integration';

$instance = 'dynamicsnav110r17'

# Licnese
#Import-NAVServerLicense -LicenseFile 'C:\Run\my\Extensions\Acora Demo_2016_250918_With_Exflow.flf' -ServerInstance $instance -Database NavDatabase
#New-NAVServerUser NAV -UserName Acoradev -Password (ConvertTo-SecureString 'Ac0radev' -AsPlainText -Force)
#New-NAVServerUserPermissionSet NAV -UserName Acoradev -PermissionSetId SUPER

# Uninstall all extensions 1by1

# 1. Unistall/Unpublish Report Design
Uninstall-NAVApp -Name $p2name -ServerInstance $instance -Version $p2currVersion

Unpublish-NAVApp -Name $p2name -ServerInstance $instance -Version $p2currVersion

# 2. Unistall/Unpublish Initial Spec
Uninstall-NAVApp -Name $p1name -ServerInstance $instance -Version $p1currVersion

Unpublish-NAVApp -Name $p1name -ServerInstance $instance -Version $p1currVersion

# 3. Publishing Initial Spec
#$ExtensionPath = 'C:\Run\my\Extensions\' + $p1newVersion + '\ACO_Avtrade Initial Specification_' + $p1newVersion + '.app'
$ExtensionPath = '.\' + $p1newVersion + '\ACO_' + $p1name + '_' + $p1newVersion + '.app'
Publish-NAVApp -Path $ExtensionPath  -ServerInstance $instance -SkipVerification

Sync-NAVTenant -ServerInstance $instance -Force

Sync-NAVApp -Name $p1name -ServerInstance $instance -Version $p1newVersion

Start-NAVAppDataUpgrade -Name $p1name -ServerInstance $instance

Install-NAVApp -Name $p1name -ServerInstance $instance


# 3. Publishing Report Design
#$ExtensionPath = 'C:\Run\my\Extensions\' + $p2newVersion + '\ACO_Avtrade Initial Specification_' + $p2newVersion + '.app'
$ExtensionPath = '.\' + $p2newVersion + '\ACO_' + $p2name + '_' + $p2newVersion + '.app'

Publish-NAVApp -Path $ExtensionPath -ServerInstance $instance -SkipVerification

Sync-NAVTenant -ServerInstance $instance -Force

Sync-NAVApp -Name $p2name -ServerInstance $instance -Version $p2newVersion

#Step not included in the template but required
Start-NAVAppDataUpgrade -Name $p2name -ServerInstance $instance

#if the above step worked this step is not needed
Install-NAVApp -Name $p2name -ServerInstance $instance

