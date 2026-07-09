# Reminder: Check that we have the ActiveDirectory module loaded. 
# If not: Install-WindowsFeature RSAT-AD-PowerShell

#Get-ADUser -Identity
# To see attributes of a user use: -Properties *
# connect multiple accounts: -filter "samaccountname -like 'user*'" | select name, enabled format-table

# PowerShell scripot to create a DHCP scope on a Windows Server.
# Run as Administrator on Windows Server.

Import-Module DHCPServer

Add-DhcpServerv4Scope -Name "Homelab Scope"
- StartRange 192.168.10.50
- EndRange 192.168.10.200
- SubnetMask 255.255.255.0

Set-DhcpServerv40OptionValue -ScopeId 192.168.10.0
- Router 192.168.10.1
- DnsServer 192.168.10.10

Write-Host "DHCP Scope 'Homelab Scope' created successfully!
