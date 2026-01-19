---
layout: default
title: Home
lang: en
permalink: /en/
---

{% include nav.html lang="en" back_url="/" back_text="Language" current="English" pt_url="/pt/" en_url="/en/" %}

# Security-IT

Welcome to **Security-IT** - an open-source repository with practical security tips for developers.

---

## What you'll find here

### Cloudflare Security

Ready-to-use rules for your project:

- **[Custom Rules](/en/cloudflare/custom-rules)** - Block unwanted access with custom rules
- **[Rate Limiting](/en/cloudflare/rate-limiting)** - Protect your APIs and login routes
- **[IP Access Rules](/en/cloudflare/ip-access)** - Manage IP whitelist and blacklist
- **[WAF Expressions](/en/cloudflare/expressions)** - Library of ready-to-use expressions

### Coming Soon

- REST API Security
- HTTP Security Headers
- CORS and CSRF Protection
- Authentication and Authorization

---

## Why this project?

Many developers configure Cloudflare but don't explore the full potential of the available security tools. This repository offers:

| Benefit | Description |
|---------|-------------|
| **Copy-paste ready** | Rules ready to use |
| **Explained** | Each rule commented |
| **By use case** | Find what you need quickly |
| **Open source** | Contribute your rules |

---

## Quick Start

### Protect admin route (Cloudflare Custom Rule)

```
(http.request.uri.path contains "/admin") and not (ip.src in {YOUR_IP})
```

**Action:** Block

### Rate limit on login

```
(http.request.uri.path eq "/api/auth/login") and (http.request.method eq "POST")
```

**Action:** Rate Limit - 5 requests/minute

---

## Contribute

Found a useful rule? Open a PR!

1. Fork the repository
2. Add your rule in `snippets/`
3. Document the use case
4. Submit the Pull Request

[View on GitHub](https://github.com/DanielMendesSensei/Security-It){: .btn}
