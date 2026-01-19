---
layout: default
title: Cloudflare Security
lang: en
permalink: /en/cloudflare/
---

{% include nav.html lang="en" back_url="/en/" back_text="Home" section="EN" section_url="/en/" current="Cloudflare" pt_url="/pt/cloudflare/" en_url="/en/cloudflare/" %}

# Cloudflare Security

Practical guides to protect your applications using Cloudflare security features.

---

## Categories

### [Custom Rules]({{ '/en/cloudflare/custom-rules/' | relative_url }})
Custom rules to block, challenge, or allow traffic based on specific conditions.

**Use cases:**
- Protect administrative routes
- Block specific countries
- Challenge suspicious bots

---

### [Rate Limiting]({{ '/en/cloudflare/rate-limiting/' | relative_url }})
Control the number of requests per IP, user, or endpoint.

**Use cases:**
- Protect login against brute force
- Limit API calls
- Prevent credential stuffing

---

### [IP Access Rules]({{ '/en/cloudflare/ip-access/' | relative_url }})
Manage IP whitelist and blacklist, ASNs, and countries.

**Use cases:**
- Whitelist trusted services
- Block known malicious IPs
- Geoblocking

---

### [Expressions Library]({{ '/en/cloudflare/expressions/' | relative_url }})
Library of ready-to-use expressions for your rules.

**Includes:**
- Bot detection expressions
- User-agent filters
- Suspicious URL patterns

---

## Access Levels

| Feature | Free | Pro | Business | Enterprise |
|---------|------|-----|----------|------------|
| Custom Rules | 5 | 20 | 100 | 1000 |
| Rate Limiting | Basic | Advanced | Advanced | Advanced |
| IP Access Rules | Unlimited | Unlimited | Unlimited | Unlimited |
| WAF Managed Rules | Basic | Full | Full | Full |

---

## Useful Links

- [Cloudflare Dashboard](https://dash.cloudflare.com)
- [Cloudflare Docs - WAF](https://developers.cloudflare.com/waf/)
- [Cloudflare Docs - Rate Limiting](https://developers.cloudflare.com/waf/rate-limiting-rules/)
