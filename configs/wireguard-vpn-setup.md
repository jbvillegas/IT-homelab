## WireGuard VPN Setup

### Package Install
WireGuard is not bundled in pfSense CE base — installed via
**System → Package Manager → Available Packages → WireGuard**.

### Tunnel Configuration
**VPN → WireGuard → Tunnels → Add Tunnel**

| Field | Value |
|---|---|
| Description | `homelab-vpn` |
| Listen Port | `51820` |
| Interface Keys | Generated via pfSense's built-in keypair generator |
| Address | `10.10.10.1/24` |

Tunnel subnet (`10.10.10.0/24`) kept deliberately separate from LAN
(`192.168.64.0/24`) so VPN client traffic is easy to isolate and rule
against independently of the internal network.

### Peer Configuration
**VPN → WireGuard → Peers → Add Peer**

[WireGuard](/screenshots/pfsense/04-wireguard-vpn-peers.png)

| Field | Value |
|---|---|
| Description | `laptop-client` |
| Tunnel | `tun_wg0 (homelab-vpn)` |
| Dynamic Endpoint | Enabled (client IP varies when off-network) |
| Public Key | Laptop's WireGuard public key (generated client-side via `wg genkey \| wg pubkey`) |
| Pre-shared Key | Generated via pfSense's "New Pre-shared Key" — adds symmetric key on top of the asymmetric pair, defense in depth |
| Allowed IPs | `10.10.10.2/32` |

### Interface Assignment
**Interfaces → Assignments** — added `tun_wg0` as a new logical
interface (`OPT1`), enabled, alongside existing WAN (`em0`) and LAN
(`em1`).

[Interface](/screenshots/pfsense/07-interface-assignment.png)

[Interface-Terminal](/screenshots/pfsense/08-interface-assignment-terminal.png)

### Firewall Rules

**WAN tab** — allow the VPN handshake in from the internet:

[Rules](/screenshots/pfsense/09-firewall-rules.png)

| Action | Proto | Source | Destination | Port | Description |
|---|---|---|---|---|---|
| Pass | UDP | any | This Firewall (self) | 51820 | Allow WireGuard handshake |

**WireGuard tab** — allow tunnel clients to reach LAN. This rule sits
first on this tab by default since it's the only rule present, which
satisfies the "VPN pass rule above default deny" requirement — revisit
ordering if more WireGuard-tab rules are added later.

[WireGuard](/screenshots/pfsense/05-allow-wireguard-handshake.png)

| Action | Proto | Source | Destination | Description |
|---|---|---|---|---|
| Pass | IPv4 | `10.10.10.0/24` | any | Allow VPN clients to LAN |

### NAT — Port Forward
**Firewall → NAT → Port Forward**

[Firewall](/screenshots/pfsense/06-firewall-port-forwarding.png)

| Interface | Proto | Dest Port | NAT IP | NAT Port | Description |
|---|---|---|---|---|---|
| WAN | UDP | 51820 | 127.0.0.1 | 51820 | WireGuard VPN |

WireGuard listens locally on the firewall itself, so the redirect
target is loopback, not an internal host IP.

### Client Configuration (macOS, via `wg-quick`)
Config lives at `/etc/wireguard/wg0.conf` on the client machine (not
committed to this repo — see `.gitignore`). Structure:

```ini
[Interface]
PrivateKey = <laptop private key>
Address = 10.10.10.2/32

[Peer]
PublicKey = <pfSense tunnel public key>
PresharedKey = <shared preshared key>
Endpoint = <home WAN public IP>:51820
AllowedIPs = 192.168.64.0/24, 10.10.10.0/24
PersistentKeepalive = 25
```

Brought up with:
```bash
sudo mkdir -p /etc/wireguard
sudo nano /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf
sudo wg-quick up wg0
```

### Verification
`sudo wg show` on the client confirmed a live peer with successful
data transfer (`sent` bytes > 0) and pfSense's **VPN → WireGuard →
Status** tab showed a matching handshake — confirming the tunnel is
functional end-to-end.

Full off-network test (laptop on cellular hotspot → tunnel → reach
DC01 via RDP) is pending DC01 build-out (Phase 2).