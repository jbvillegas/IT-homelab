# Homelab - Proxmox UTM Virtualization & Network Infraestructure

## Overview
This project is a complete virtualized IT infraestructure built from scratch to simulate an enterprise environment. Designed to demonstrate hands-on skills in virtualization, Windows Server administration, networking, security, and database management. 

   ![Windows Server](https://img.shields.io/badge/Windows-Server_2022-0078D6)
   ![pfSense](https://img.shields.io/badge/pfSense-2.7.0-000000)

## Architecture
![Network Diagram](screenshots/diagrams/NetworkDiagram-Readme.png) 

## Components
| Component | Details |
|-----------|---------|
| **Hypervisor** | Proxmox VE|
| **Firewall / VPN** | pfSense CE with NAT, Port Forwarding, OpenVPN/WireGuard |
| **Domain Controller** | Windows Server 2022 with Active Directory, DNS, DHCP |
| **Database Server** | Microsoft SQL Server 2022 Express |
| **Linux Server** | Ubuntu 22.04 LTS |
| **Documentation** | Private Wiki (BookStack) |

## Key Features
- Virtualized environment with 6+ VMs
- Active Directory domain ('homelab.local')
- DNS forwarders and DHCP scope
- pfSense firewall rules with port forwarding
- OpenVPN for secure remote access
- SQL Server with backup routines
- Full network documentation (diagrams, IP plan, troubleshooting guides)

## Guides
- Here I will place the installation guides.

## Scripts
- Here I will place all the scripts.

## Screenshots
- Here I will place all the screenshots.

## Skills Demonstrated
- Virtualization (VMware ESXi)
- Windows Server Administration (AD, DNS, DHCP)
- Networking (TCP/IP, Routing, Firewall, VPN)
- Security (NAT, firewall rules, VPN encryption)
- Database Administration (MS SQL Server)
- Automation (PowerShell, Bash)
- Documentation (Technical writing, diagrams)

## Date
July 2026

---

Built by [Joaquin Baltasar Villegas](https://github.com/jbvillegas) 
