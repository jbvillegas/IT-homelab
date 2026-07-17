# Cyber Kill Chain, MITRE ATT&CK & Pyramid of Pain — My Notes

## Why the Attack Lifecycle Matters

Before talking about handling incidents, I need to understand the attack lifecycle — the cyber kill chain. It describes how attacks actually manifest themselves. Knowing this lifecycle gives me valuable insight during the investigation phase of an incident: how far into the network an attacker has gotten, and what they likely have access to.

## The Cyber Kill Chain (7 Stages)

![cyberkill-chain](/screenshots/theory/cyberkill-chain.png)

The kill chain has seven stages:

1. **Recon (Reconnaissance)** — the attacker chooses a target and gathers information to get familiar with it, collecting data useful for this and later stages. Some go passive — scraping LinkedIn, Instagram, the target org's web pages, job ads, and partner info, which can reveal antivirus tools, OSes, and networking tech. Others go active, "poking" and scanning external web apps and IPs.

2. **Weaponize** — the malware for initial access is developed and embedded into an exploit or deliverable payload. It's crafted to be lightweight and undetectable by AV/EDR (the attacker likely already identified the target's defensive tech). At scale, the goal of this stage is remote access to a compromised machine that can survive reboots and deploy additional tools on demand.

3. **Delivery** — the exploit or payload is delivered to the victim. Classic approaches: phishing emails with malicious attachments or links to web pages (which can either host an exploit, host the payload to bypass email scanning, or mimic a legit site to harvest credentials). Sometimes attackers call the victim with a social-engineering pretext to get them to run the payload, hosting it on a lookalike site. Rarely does a payload require more than a double-click on an executable or script (`.bat`, `.cmd`, `.vbs`, `.js`, `.hta`, etc.). Physical delivery via USB tokens left around also happens.

4. **Exploitation** — the moment the exploit or delivered payload is triggered, typically attempting to execute code on the target system to gain access or control.

5. **Installation** — the initial stager is executed and running on the compromised machine. Common techniques include:
   - **Droppers** — small code that installs and runs malware (delivered via email attachments, malicious sites, social engineering).
   - **Backdoors** — malware giving ongoing access; can be installed during exploitation or delivered by a dropper, used for further attacks or data theft.
   - **Rootkits** — malware designed to hide its presence and evade AV/security tools.

6. **Command and Control (C2)** — the attacker establishes remote access to the compromised machine. A modular stager may load additional scripts on the fly. Advanced groups use separate tools to keep multiple malware variants in a network, so if one is discovered and contained, they still have a way back in.

7. **Action / Objective** — the final stage; the goal varies. Some adversaries exfiltrate confidential data; others aim for the highest possible access to deploy ransomware (which renders endpoint/server data unusable unless a ransom is paid within a timeframe — paying is not recommended).

Important: adversaries don't operate linearly. Earlier stages repeat — e.g., after a successful Installation, the logical next step is to go back to Recon to find additional targets and vulnerabilities, move deeper, and eventually reach the objective. My goal is to stop an attacker from progressing further up the kill chain, ideally in one of the earliest stages.

## MITRE ATT&CK Framework

Another framework for understanding adversary behavior is [MITRE ATT&CK](https://attack.mitre.org/) — a more granular, matrix-based knowledge base of adversary tactics and techniques used to achieve specific goals. Cybersecurity pros use both frameworks to understand and defend against attacks.

The **Enterprise Matrix** documents adversary behavior observed in the wild against enterprise IT environments (Windows, Linux, macOS, cloud, network, mobile, etc.). It's presented as a matrix where columns are adversary goals (tactics) and cells are techniques attackers use to achieve them. It helps defenders understand, model, detect, and respond to attacker behavior in a structured way. ([matrix view](https://attack.mitre.org/matrices/enterprise/))

- **Tactic** — a high-level adversary objective during an intrusion (the goal at that stage), e.g., Initial Access, Persistence, Privilege Escalation.
- **Technique** — a specific method used to achieve a tactic; describes concrete attacker behavior (tools, commands, APIs, protocols). IDs like [T1105 (Ingress Tool Transfer)](https://attack.mitre.org/techniques/T1105/) (tools like `wget`, `curl` to download a tool) or [T1021 (Remote Services)](https://attack.mitre.org/techniques/T1021/) (using SSH, RDP, SMB for lateral movement).
- **Sub-technique** — children of techniques that capture a particular implementation or target; IDs extend the parent, e.g., [T1003.001 (Credential Dumping → LSASS Memory)](https://attack.mitre.org/techniques/T1003/001/) (dumping credentials from LSASS process memory) or [T1021.002 (Remote Services → SMB/Windows Admin Shares)](https://attack.mitre.org/techniques/T1021/002/) (interacting with shares using valid credentials). This enables precise detection, attribution, and reporting — I can say "we detected T1003.001 — LSASS memory dumping" instead of just T1003.

## Pyramid of Pain

The Pyramid of Pain illustrates how much effort it takes an adversary to change their tactics when defenders detect and block different indicator types. At the base are simple indicators — hash values, IP addresses, domain names — easily changed by attackers (low pain).

For example, blocking a malicious IP in a C2 scenario ([T1071](https://attack.mitre.org/techniques/T1071/)) only slightly slows the adversary, since they can quickly switch C2 servers. Moving up, network and host artifacts (registry keys, mutex names, filenames) correspond to specific techniques (e.g., [T1547.001 — Registry Run Keys/Startup Folder](https://attack.mitre.org/techniques/T1547/001/)) and take more effort to change, making them more resilient indicators.

At the top are Tools, Tactics, Techniques, and Procedures (TTPs) — aligned directly with the core of MITRE ATT&CK. Detecting and disrupting these (e.g., PowerShell abuse under [T1059](https://attack.mitre.org/techniques/T1059/) or process injection under [T1055](https://attack.mitre.org/techniques/T1055/)) forces the adversary to fundamentally change how they operate — maximum pain.

**In summary:**
- Hash/IP detections = easy to evade.
- Behavioral TTP detections (MITRE-based) = hard to evade, higher attacker cost, stronger defense maturity.

Analysts map observed events and indicators to ATT&CK tactics/techniques to quickly understand adversary intent and likely next steps, prioritize alerts based on techniques targeting high-value assets, and refer to the mitigation and containment/eradication actions that disrupt the attacker's kill chain.

## MITRE ATT&CK in TheHive

TheHive is a case management platform for cybersecurity teams to handle incidents efficiently by processing alerts. I can create cases and link multiple relevant alerts within them — a centralized hub collecting all security alerts from various devices on a single page. It also lets me import all MITRE ATT&CK TTPs into its alert management system, enriching incident analysis by associating discovered attack patterns with the alerts.

Access: `http://TARGET_IP:9000` with username `htb-analyst` and password `P3n#31337@LOG`. The dashboard loads on login, and the alerts page lets me view and manage alerts.

## Example ATT&CK Mapping

Some techniques observed during the incident:

| Tactic | Technique | ID | Description |
|---|---|---|---|
| Initial Access | Exploit Public-Facing Application | T1190 | Confluence CVE exploited |
| Execution | Command and Scripting Interpreter: PowerShell | T1059.001 | PowerShell used for payload download |
| Persistence | Windows Service | T1543.003 | Windows Service for persistence |
| Credential Access | LSASS Memory Dumping | T1003.001 | Extracted credentials |
| Lateral Movement | Remote Desktop Protocol | T1021.001 | RDP lateral movement |
| Impact | Data Encrypted for Impact | T1486 | LockBit ransomware |
