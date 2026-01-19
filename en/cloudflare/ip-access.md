---
layout: default
title: IP Access Rules - Cloudflare
lang: en
permalink: /en/cloudflare/ip-access/
---

{% include nav.html lang="en" back_url="/en/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/en/cloudflare/" current="IP Access" pt_url="/pt/cloudflare/ip-access/" en_url="/en/cloudflare/ip-access/" %}

{% include cloudflare-menu.html lang="en" active="ip-access" %}

# IP Access Rules

IP Access Rules allow you to control access based on IP, ASN (Autonomous System Number), or country.

---

## Whitelist

### Allow trusted services

Add IPs of services that need unrestricted access to your site:

| Service | Action |
|---------|--------|
| Your office IP | Allow |
| CI/CD server | Allow |
| Payment Gateway (Stripe, etc) | Allow |
| Monitoring (UptimeRobot, etc) | Allow |

**How to add:**
1. Go to Security > WAF > Tools
2. Click on "IP Access Rules"
3. Add the IP/Range with "Allow" action

---

### Stripe IPs (example)

```
# Stripe Webhooks - whitelist these IPs
3.18.12.63
3.130.192.231
13.235.14.237
13.235.122.149
18.211.135.69
35.154.171.200
52.15.183.38
54.88.130.119
54.88.130.237
54.187.174.169
54.187.205.235
54.187.216.72
```

---

## Blacklist

### Block malicious IPs

When you identify an attacking IP in logs:

1. Go to Security > Events
2. Identify the IP
3. Add to IP Access Rules with "Block" action

**Tip:** Use "Challenge" instead of "Block" if you're not sure.

---

### Block known attack ranges

Some IP ranges are frequently used by attackers:

```
# Example - verify before blocking
# Data centers frequently used by bots
```

**Caution:** Blocking large ranges can affect legitimate users.

---

## Geoblocking

### Block entire countries

**Option 1: Via IP Access Rules**
1. Security > WAF > Tools
2. IP Access Rules
3. Select "Country" and choose the country
4. Action: Block

**Option 2: Via Custom Rules (recommended)**
```
(ip.geoip.country in {"CN" "RU" "KP"})
```

Custom Rules are more flexible as they allow exceptions.

---

### Block by ASN

ASN is useful for blocking entire data centers used by bots:

```
# Example of ASNs frequently associated with bots
# Research before blocking
```

**How to find ASN:**
1. Go to Security > Events
2. Click on an event
3. ASN appears in the details

---

## IP Lists

To manage many IPs, use IP Lists:

### Create a list

1. Manage Account > Configurations > Lists
2. Create a new list
3. Add IPs

### Use the list in rules

```
(ip.src in $blocked_ips_list)
```

**Advantages:**
- Centralized management
- Easy to update
- Can be used in multiple rules

---

## Rule Priority

Cloudflare evaluation order:

1. IP Access Rules (Allow)
2. Custom Rules
3. Rate Limiting Rules
4. Managed Rules (WAF)
5. IP Access Rules (Block/Challenge)

**Important:** IPs with "Allow" in IP Access Rules override country blocks, but do NOT override Custom Rules with Block.

---

## Common Use Cases

### Brazil E-commerce

```
# Allow only Brazil + Portugal + USA
not (ip.geoip.country in {"BR" "PT" "US"})
```
Action: Block

---

### API with partner whitelist

```
# Block everything except partners
not (ip.src in $partner_list)
```
Action: Block

---

### Protect staging/dev

```
# Staging only accessible from office
(http.host eq "staging.yoursite.com") and not (ip.src in {OFFICE_IP})
```
Action: Block

---

## Best Practices

1. **Document your IPs** - Keep a list of which IPs are allowed and why
2. **Review periodically** - IPs change, services change
3. **Use Lists** - Easier to manage than individual rules
4. **Prefer Challenge over Block** - Less chance of blocking legitimate users
5. **Monitor Security Events** - See what's being blocked

---

## Troubleshooting

### Legitimate user blocked

1. Ask for the user's IP
2. Check in Security > Events
3. Identify which rule blocked
4. Add exception or adjust the rule

### How to check your IP

Ask the user to access: [whatismyip.com](https://whatismyip.com)

---

[Back to Cloudflare](/en/cloudflare/) | [View Snippets](/snippets/cloudflare/)
