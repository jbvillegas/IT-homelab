| Device                   | IP Address            | Purpose              |
| ------------------------ | --------------------- | -------------------- |
| pfSense WAN              | DHCP from Home Router | Internet Gateway     |
| pfSense LAN              | 192.168.10.1/24       | Gateway / NAT        |
| Windows Server DC        | 192.168.10.10         | AD DS, DNS, DHCP     |
| SQL Server               | 192.168.10.20         | Database Server      |
| Ubuntu Server            | 192.168.10.30         | Wiki / Git Server    |
| Future Monitoring Server | 192.168.10.40         | Grafana, Wazuh, etc. |
| Test VM Pool             | 192.168.10.50-99      | Future VMs           |
| DHCP Scope               | 192.168.10.100-200    | Client Devices       |
| Reserved Expansion       | 192.168.10.201-254    | Growth               |


| Posible Changes|  
|---------------|
| 192.168.10.1   ->  pfSense |
| 192.168.10.10  ->  DC01 |
| 192.168.10.20  ->  SQL01 |
| 192.168.10.30  ->  UBUNTU01 |
| 192.168.10.40  ->  Reserved (Monitoring) | 
| 192.168.10.50-99 -> Reserved Static Servers |
| 192.168.10.100-200 -> DHCP Pool |
| 192.168.10.201-254 -> Future Expansion |

| Physical Network Separation |
|-----------------------------|
| Home Network -> 192.168.1.0/24 |
| pfSense WAN -> 192.168.1.x |
| Internal Lab -> 192.168.10.0/24 |