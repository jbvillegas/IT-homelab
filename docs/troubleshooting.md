# Troubleshooting Guide

## VM won't start in ESXi
- Check available RAM/CPU resources
- Verify the disk has enough free space
- Check VM logs under **Monitor** → **Logs**

## Cannot ping external IPs from internal network
- Check pfSense firewall rules (allow LAN → WAN)
- Verify NAT is enabled on pfSense
- Check Windows Server DNS forwarders

## Domain join fails
- Verify DNS points to DC (`192.168.10.10`)
- Check AD replication status
- Ensure the computer is in the correct subnet

## SQL Server connection failed
- Verify SQL Server service is running
- Check if TCP/IP is enabled in SQL Configuration Manager
- Ensure firewall allows port 1433