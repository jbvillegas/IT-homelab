# Script to automate the creating of OUs and users in Active Directory
# Run as Domain Admin

$DomainName = "homelab.local"
$OUs = @("IT", "HR", "Finance")

foreach ($OU in $OUs) { ## loop through each OU in the list and create it in AD
    New-ADOrganizationalUnit -Name $OU -Path "DC=$($DomainName.Split('.')[0]), DC=$($DomainName.Split("."[1]))"
    Write-Host "Created OU: $OU"
} 

# Creat test users

@Users = @(
    @{Name= "Nicolas Otamendi"; Sam="notamendi"; Password="P@ssw0rd1"},
    @{Name= "Julian Alvarez"; Sam="jalvarez"; Password="P@ssw0rd2"},
    @{Name= "Enzo Fernandez"; Sam="efernandez"; Password="P@ssw0rd3"}
)

foreach ($User in $Users){
    New-ADUser -name $User.Name
    -SamAccountName $User.Sam
    -UserPrincipalName "$($User.Sam)@$Doamin"
    -GivenName $User.Name.Split(' ')[0]
    -Surname $User.Name.Split(' ')[1]
    -Enabled $true
    -AccountPassword (ConvertTo-SecureString $User.Password -AsPlainText -Force)
    -Path "OU=IT,DC=$($DomainName.Split(".")[0]),DC=$($DomainName.Split(".")[1])"
    Write-Host "Created user: $($User.Name)"
}
