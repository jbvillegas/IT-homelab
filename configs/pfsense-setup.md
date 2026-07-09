# pfSense Firewall & VPN Gateway Setup

## Overview

This guide documents the installation and initial configuration of **pfSense CE** as the primary firewall, routing platform, and future VPN gateway for my homelab environment. pfSense provides network security, firewalling, NAT, routing, and will later provide secure remote access to the virtual infrastructure.

---

## Architecture Context

pfSense serves as the edge firewall for the homelab.

- **WAN Interface:** Connected to the physical home network (`192.168.178.0/24`)
- **LAN Interface:** Internal interface for the lab environment
- **VPN:** OpenVPN/WireGuard planned for secure remote access

---

## Installation Environment

| Component | Details |
|-----------|---------|
| Hypervisor | Proxmox VE 9.2.2 |
| pfSense Version | 2.8.1-RELEASE |
| VM Resources | 2 GB RAM, 16 GB Storage, 1 vCPU |
| Network Interfaces | WAN + LAN virtual NICs |

---

# Installation Steps

## 1. Virtual Machine Creation

A new pfSense virtual machine was created in Proxmox using the following specifications.

| Setting | Value |
|---------|-------|
| Operating System | Other |
| Architecture | x86_64 |
| CPU Type | qemu64 |
| vCPUs | 1 |
| Memory | 2048 MB |
| Storage | 16 GB |
| Boot Mode | Legacy BIOS |

The **qemu64** CPU type was selected to maximize compatibility with FreeBSD and avoid kernel panic issues during installation.

---

## 2. Network Interface Configuration

![VM Network Overview](/screenshots/pfsense/01-vm-network-overview.png)

Two virtual network interfaces were assigned to the pfSense virtual machine.

| Interface | Purpose |
|-----------|---------|
| **WAN (em0)** | Connected to the home network |
| **LAN (em1)** | Internal lab network |

This configuration separates external network access from the internal laboratory environment.

---

## 3. Interface Status

![pfSense Interface Status](/screenshots/pfsense/02-interface-status.png)

After installation, pfSense successfully detected both network interfaces.

Current interface status:

| Interface | Status | IP Address |
|-----------|--------|------------|
| **WAN (em0)** | Active | 192.168.178.61 |
| **LAN (em1)** | Active | 192.168.178.25 |

The WAN interface automatically obtained its address via DHCP while the LAN interface was available for internal routing and future network segmentation.

---

## 4. Firewall Rule Configuration

![Firewall Rule for WebGUI Access](/screenshots/pfsense/03-webgui-firewall-rule.png)

To allow administration from the home network, a firewall rule was created permitting HTTPS access to the pfSense WebGUI.

### Rule Details

| Setting | Value |
|---------|-------|
| Action | Pass |
| Protocol | TCP |
| Source | Home Network (192.168.178.0/24) |
| Destination | This Firewall (self) |
| Destination Port | HTTPS (443) |
| Description | Allow GUI access from home network |

After applying the rule, the firewall reloaded successfully and remote management was enabled.

---

## 5. Web Interface Access

The pfSense WebGUI was successfully accessed through the WAN interface.

```text
https://192.168.178.61
```

### Default Credentials

| Field | Value |
|------|-------|
| Username | admin |
| Password | pfsense *(changed after initial login)* |

---

## Current Network Configuration

| Interface | IP Address | Purpose |
|-----------|-----------|---------|
| WAN (em0) | 192.168.178.61 | Internet connectivity and management |
| LAN (em1) | 192.168.178.25 | Internal laboratory interface |

---

## Key Features Implemented

| Feature | Status |
|---------|--------|
| WAN Connectivity | **Complete** |
| LAN Interface | **Complete** |
| WebGUI Access | **Complete** |
| Firewall Rule Configuration | **Complete** |
| NAT | Default Configuration |
| DHCP Server | Planned |
| OpenVPN | Planned |
| WireGuard | Planned |
| Port Forwarding | Planned |

---

## Planned IP Addressing

The lab will eventually migrate to a dedicated internal subnet.

| Device | Planned IP |
|--------|------------|
| pfSense LAN | 10.0.2.1 |
| Windows Server | 10.0.2.10 |
| SQL Server | 10.0.2.20 |
| Linux Server | 10.0.2.30 |

---

## Troubleshooting

### Storage Compatibility

**Issue**

The installer initially failed to detect a valid storage device.

**Cause**

The default virtual disk controller was incompatible with FreeBSD.

**Resolution**

The virtual disk interface was changed to a supported controller, allowing pfSense to detect the installation disk successfully.

---

### Network Segmentation

At the time these screenshots were taken, both interfaces were configured within the home network while initial connectivity and management access were being validated.

The LAN interface will later be migrated to a dedicated subnet (`10.0.2.0/24`) to provide proper routing, firewall isolation, and support for additional virtual machines.

---

## Next Steps

- Configure a dedicated LAN subnet (`10.0.2.0/24`)
- Enable the DHCP server for the internal network
- Configure DNS Resolver
- Configure OpenVPN
- Configure WireGuard
- Create firewall rules for internal services
- Configure port forwarding
- Integrate with Active Directory
- Configure Syslog logging
- Enable automatic configuration backups

---

## References

- https://docs.netgate.com/pfsense/en/latest/
- https://pve.proxmox.com/wiki/Main_Page
- https://docs.freebsd.org/en/books/handbook/

---

## Skills Demonstrated

- Firewall Administration
- Network Routing
- Virtualization (Proxmox VE)
- TCP/IP Networking
- NAT Configuration
- Firewall Rule Management
- Infrastructure Deployment
- Network Troubleshooting
- Technical Documentation