---
layout: default
title: Firewall Expressions - Cloudflare
lang: en
permalink: /en/cloudflare/expressions/
---

{% include nav.html lang="en" back_url="/en/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/en/cloudflare/" current="Expressions" pt_url="/pt/cloudflare/expressions/" en_url="/en/cloudflare/expressions/" %}

{% include cloudflare-menu.html lang="en" active="expressions" %}

# Firewall Expressions

Library of ready-to-use expressions for Custom Rules, Rate Limiting, and other Cloudflare rules.

---

## Available Fields

### Request Fields

| Field | Description | Example |
|-------|-------------|---------|
| `http.request.uri.path` | URL path | `/api/users` |
| `http.request.uri.query` | Query string | `?id=123` |
| `http.request.method` | HTTP method | `POST` |
| `http.request.headers["name"]` | Specific header | `Authorization` |
| `http.host` | Hostname | `api.site.com` |
| `http.user_agent` | User Agent | `Mozilla/5.0...` |
| `http.referer` | Referer | `https://google.com` |

### IP Fields

| Field | Description | Example |
|-------|-------------|---------|
| `ip.src` | Visitor IP | `192.168.1.1` |
| `ip.geoip.country` | Country (ISO code) | `BR` |
| `ip.geoip.continent` | Continent | `SA` |
| `ip.geoip.asnum` | ASN | `12345` |

### Bot Fields

| Field | Description |
|-------|-------------|
| `cf.client.bot` | Is it a bot? |
| `cf.bot_management.score` | Bot score (0-99) |
| `cf.bot_management.verified_bot` | Verified bot? |

### Threat Fields

| Field | Description |
|-------|-------------|
| `cf.threat_score` | Threat score (0-100) |
| `cf.edge.server_port` | Server port |

---

## Operators

| Operator | Description | Example |
|----------|-------------|---------|
| `eq` | Equals | `http.request.method eq "POST"` |
| `ne` | Not equal | `ip.geoip.country ne "BR"` |
| `contains` | Contains | `http.request.uri.path contains "/admin"` |
| `starts_with` | Starts with | `http.request.uri.path starts_with "/api/"` |
| `ends_with` | Ends with | `http.request.uri.path ends_with ".php"` |
| `in` | Is in list | `ip.geoip.country in {"BR" "US"}` |
| `matches` | Regex | `http.request.uri.path matches "^/user/[0-9]+$"` |
| `gt`, `lt`, `ge`, `le` | Numeric comparison | `cf.threat_score gt 50` |

### Logical Operators

| Operator | Description |
|----------|-------------|
| `and` | Logical AND |
| `or` | Logical OR |
| `not` | Negation |
| `( )` | Grouping |

---

## Ready-to-Use Expressions

### Route Protection

```bash
# Block access to /admin
(http.request.uri.path contains "/admin")

# Protect multiple sensitive routes
(http.request.uri.path in {"/admin" "/dashboard" "/settings" "/api/admin"})

# Protect with IP exception
(http.request.uri.path contains "/admin") and not (ip.src in {YOUR_IP})

# Protect specific subdomains
(http.host eq "admin.yoursite.com") and not (ip.src in {YOUR_IP})
```

---

### Bot Detection

```bash
# Empty User-Agent
(http.user_agent eq "")

# Known malicious bots
(http.user_agent contains "curl" or http.user_agent contains "wget" or http.user_agent contains "python-requests")

# High bot score (requires Bot Management)
(cf.bot_management.score lt 30)

# Unverified bots
(cf.client.bot) and not (cf.bot_management.verified_bot)

# High threat score
(cf.threat_score gt 50)
```

---

### Geoblocking

```bash
# Block specific countries
(ip.geoip.country in {"CN" "RU" "KP" "IR"})

# Allow only Brazil
not (ip.geoip.country eq "BR")

# Block entire continent
(ip.geoip.continent eq "AS")

# Block country but allow specific IPs
(ip.geoip.country eq "CN") and not (ip.src in {ALLOWED_IPS})
```

---

### API Protection

```bash
# Requests without Authorization header
(http.request.uri.path starts_with "/api/") and not (len(http.request.headers["authorization"][0]) gt 0)

# Block disallowed methods
(http.request.uri.path starts_with "/api/") and not (http.request.method in {"GET" "POST" "PUT" "DELETE"})

# Invalid Content-Type for POST
(http.request.method eq "POST") and not (http.request.headers["content-type"][0] contains "application/json")
```

---

### WordPress Protection

```bash
# Protect wp-admin and wp-login
(http.request.uri.path contains "/wp-admin" or http.request.uri.path contains "/wp-login.php") and not (ip.src in {YOUR_IP})

# Block xmlrpc (frequently attacked)
(http.request.uri.path eq "/xmlrpc.php")

# Block PHP upload in wp-content
(http.request.uri.path contains "/wp-content/uploads/" and http.request.uri.path ends_with ".php")
```

---

### Next.js Protection

```bash
# Protect admin API routes
(http.request.uri.path starts_with "/api/admin")

# Block direct access to _next/static with suspicious parameters
(http.request.uri.path starts_with "/_next/") and (http.request.uri.query contains "<script")

# Protect Server Actions
(http.request.method eq "POST") and (http.request.headers["next-action"][0] ne "") and not (http.referer contains "yoursite.com")
```

---

### Anti-Scraping

```bash
# Very fast requests from same IP (combine with rate limiting)
(http.request.uri.path starts_with "/products/")

# Without Accept-Language (common in scrapers)
(len(http.request.headers["accept-language"][0]) eq 0)

# Block hotlinking
(http.request.uri.path.extension in {"jpg" "png" "gif" "webp"}) and not (http.referer contains "yoursite.com") and (len(http.referer) gt 0)
```

---

### Advanced Combinations

```bash
# Suspicious login: POST without valid referer
(http.request.uri.path eq "/login") and (http.request.method eq "POST") and not (http.referer contains "yoursite.com")

# Abusive API: many requests + suspicious user-agent
(http.request.uri.path starts_with "/api/") and (http.user_agent contains "bot" or http.user_agent eq "")

# Form attack: POST from unexpected country
(http.request.method eq "POST") and not (ip.geoip.country in {"BR" "US" "PT"})
```

---

## Useful Functions

```bash
# String length
len(http.user_agent) eq 0

# Lowercase
lower(http.request.uri.path) contains "/admin"

# Regular expression
http.request.uri.path matches "^/user/[0-9]+$"

# Check if header exists
http.request.headers["x-api-key"][0] ne ""
```

---

## Debug Expressions

To test an expression:

1. Create the rule with **Log** action
2. Wait for traffic
3. Check in **Security > Events**
4. Adjust as needed
5. Change to the desired action

---

[Back to Cloudflare](/en/cloudflare/) | [View Snippets](/snippets/cloudflare/)
