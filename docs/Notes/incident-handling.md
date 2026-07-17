# Incident Handling — My Notes

![incident-scenario](/screenshots/theory/incident-scenario.png)

## What Incident Handling Means to Me

Incident handling (IH) is a core part of how an organization defends itself against cybercrime. No matter how many protective controls we put in place, there's always a chance something gets through — so having a structured way to manage and respond to security incidents is essential for any org that can't afford to lose the confidentiality, integrity, or availability of its data. Some orgs build this capability in-house; others lean on third parties, either continuously or on demand.

Before going further, I want to be clear on the terminology:

- **Event** — an action that occurs in a system or network (a user sending an email, a mouse click, a firewall allowing a connection).
- **Incident** — an event with a negative consequence, like a system crash or unauthorized access to sensitive data. Incidents can also come from natural disasters, power failures, etc.
- **IT security incident** — my working definition: an event with a clear intent to cause harm, carried out against a computer system (e.g., data theft, funds theft, unauthorized access, malware/RAT installation).

One thing worth keeping in mind: incident handling isn't only about intrusions. Malicious insiders, availability problems, and loss of intellectual property all fall under its scope. A solid IH plan should cover these different incident types and provide measures to **identify, contain, eradicate, and recover** so normal business operations are restored as quickly and efficiently as possible.

Also, it's not always obvious right away that an event is actually an incident — sometimes that only becomes clear after an initial investigation. Still, certain suspicious events should be treated as incidents unless proven otherwise.

## Why It Matters and General Notes

Security incidents often involve compromised personal or business data, so speed and effectiveness in the response are crucial. The impact varies wildly — sometimes it's a handful of devices, sometimes most of the environment. Having a trained incident handling team (often called an incident response team) means actions are taken systematically, with the goal of minimizing information theft and service disruption through investigation and remediation. Decisions made before, during, and after the incident all shape its impact.

Because different incidents hit differently, **prioritization** is key. High-severity incidents need immediate attention and resources, while lower-rated ones may still need an initial investigation just to confirm whether they're actually security incidents.

The team is led by an **incident manager** — often a SOC manager, CISO/CIO, or a trusted third-party vendor — who can direct other business units. This person needs the mandate to require any employee to perform an activity in a timely manner if needed, and acts as the single point of communication, tracking all investigation activities and their completion status.

A widely used reference is [NIST's Computer Security Incident Handling Guide](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-61r3.pdf), which gives practical guidelines for responding to incidents effectively and efficiently.

## Real-World Incidents (By Type)

### Leaked Credentials
- **Colonial Pipeline ransomware attack** — originated from a breached employee's personal password (likely on the dark web), used on an inactive VPN account that had no MFA. Not a direct attack on the network. ([details](https://en.wikipedia.org/wiki/Colonial_Pipeline_ransomware_attack))

### Default / Weak Credentials
- **Mirai botnet (2016)** — scanned for IoT devices using factory/default credentials (e.g., admin/admin), conscripting them into a massive DDoS botnet that hit Dyn and OVH. Root cause: unchanged default credentials and poor remote-access security.
- **LogicMonitor (2023)** — customers compromised because the vendor issued weak default passwords, leading to follow-on ransomware and unauthorized access.

### Outdated Software / Unpatched Systems
- **Equifax (2017)** — attackers exploited a known Apache Struts flaw (CVE-2017-5638); ~143–147 million people's data exposed. The patch was available but not applied in time.
- **WannaCry (2017)** — ransomware worm using the SMB EternalBlue exploit; hit 200,000+ systems across 150+ countries, including hospitals. The MS17-010 patch existed before the outbreak.

### Rogue Employee / Insider Threat
- **Cash App / Block Inc.** — a former employee accessed personal info of millions of users (~8.2 million impacted), triggering regulatory scrutiny and settlements. Root cause: abuse of legitimate access with weak internal controls and monitoring.

### Phishing / Social Engineering
- Phishing is a pervasive vector — it's used to steal credentials, deliver malware, or trick users into enabling remote access, and it accounts for a significant share of breaches over multiple years.
- **U.S. Interior Department** — attackers used an "evil twin" fake Wi-Fi network to steal credentials. Revealed weak wireless security, weak authentication, and inadequate testing.
- **2020 Twitter hijack** — high-profile accounts compromised to push a bitcoin scam. Attackers socially engineered Twitter employees to access admin tools.

### Supply-Chain Attack
- **SolarWinds Orion (2020)** — nation-state actors compromised the build/release environment and injected a backdoor into Orion updates distributed to thousands of customers, causing widespread espionage and long remediation efforts.

## Incident Reports

The idea is to document a real incident in a sequential, stage-by-stage format aligned with frameworks like the Cyber Kill Chain and MITRE ATT&CK — moving from initial access through to impact — just like the professional reports from [Mandiant](https://www.mandiant.com/), [Palo Alto Unit 42](https://unit42.paloaltonetworks.com/), and [Proofpoint](https://www.proofpoint.com/).

A good example from DFIR Labs: [Confluence Exploit Leads to LockBit Ransomware](https://thedfirreport.com/2025/02/24/confluence-exploit-leads-to-lockbit-ransomware/), which walks through each phase of the adversary's operation (initial access, execution, exfiltration, impact). More reports live at [The DFIR Report](https://thedfirreport.com/).

Another example from Cybereason: [CHAES: Novel Malware Targeting Latin American E-Commerce](https://www.cybereason.com/hubfs/dam/collateral/reports/11-2020-Chaes-e-commerce-malware-research.pdf).

There are two flavors of reports:
- **Incident-specific reports** — focus on one event/outbreak, giving a detailed forensic narrative and actionable findings for that incident.
- **Global incident-response reports** — aggregate data from hundreds of incidents across industries, geographies, and threat actors to identify trends, patterns, emerging threats, and give high-level recommendations.

For example, the 2025 Unit 42 report notes that in 2024, 86% of incidents they responded to involved business disruption (operational downtime, reputational damage, or both), and that software supply chain and cloud attacks are growing in frequency and sophistication — in one campaign, attackers scanned more than 230 million unique targets for sensitive information.

Global report reference: [Palo Alto Unit 42 Global Incident Response Report](https://www.paloaltonetworks.com/engage/unit42-2025-global-incident-response-report).

## Incident Scenario — Insight Nexus

Throughout this module, the scenario involves **Insight Nexus**, a global market research firm handling sensitive competitive data for high-profile IT-sector clients. They become a target of two distinct threat groups operating simultaneously in their environment.

The first threat actor got in because sysadmins forgot to change the default admin/admin password on an internet-facing app — ManageEngine ADManager Plus — after a product update. From there the attackers:

1. Logged in successfully and performed reconnaissance.
2. Mapped users and machines.
3. Created new privileged Active Directory accounts.
4. Used one of those accounts to pivot further, finding an externally exposed RDP service caused by misconfiguration.
5. Exploited that entry point, escalated control, and used Group Policy Objects (GPOs) to deploy spyware via an MSI package across multiple endpoints.

In the next section, I'll get into the Cyber Kill Chain and MITRE ATT&CK frameworks — their phases reflect the attacker's lifecycle and the observable actions at each stage.