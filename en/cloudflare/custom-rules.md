---
layout: default
title: Custom Rules - Cloudflare
lang: en
permalink: /en/cloudflare/custom-rules/
---

{% include nav.html lang="en" back_url="/en/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/en/cloudflare/" current="Custom Rules" pt_url="/pt/cloudflare/custom-rules/" en_url="/en/cloudflare/custom-rules/" %}

{% include cloudflare-menu.html lang="en" active="custom-rules" %}

# Custom Rules

Custom Rules allow you to control incoming traffic by filtering requests based on specific conditions.

---

## Protect Administrative Routes

### Block access to /admin except allowed IPs

**Expression:**
```
(http.request.uri.path contains "/admin") and not (ip.src in {192.168.1.1 10.0.0.1})
```

**Action:** Block

**Explanation:**
- `http.request.uri.path contains "/admin"` - Captures any URL with /admin
- `ip.src in {...}` - List of allowed IPs
- `not` - Inverts the condition, blocking those NOT in the list

---

### Protect wp-admin (WordPress)

**Expression:**
```
(http.request.uri.path contains "/wp-admin" or http.request.uri.path contains "/wp-login.php") and not (ip.src in {YOUR_IP})
```

**Action:** Block

---

### Protect API routes (Next.js/Node)

**Expression:**
```
(http.request.uri.path starts_with "/api/admin") and not (ip.src in {YOUR_IP})
```

**Action:** Block

---

## Block by Country

### Block countries with high attack rates

**Expression:**
```
(ip.geoip.country in {"CN" "RU" "KP" "IR"})
```

**Action:** Block or Managed Challenge

**Note:** Adjust the list according to your target audience. If you have legitimate users from these countries, use Managed Challenge instead of Block.

---

### Allow only specific countries

**Expression:**
```
not (ip.geoip.country in {"BR" "US" "PT"})
```

**Action:** Block

---

## Challenge Suspicious Bots

### Empty or suspicious User-Agent

**Expression:**
```
(http.user_agent eq "") or (http.user_agent contains "curl") or (http.user_agent contains "wget")
```

**Action:** Managed Challenge

---

### Block known bots (except good ones)

**Expression:**
```
(cf.client.bot) and not (cf.bot_management.verified_bot)
```

**Action:** Block

**Explanation:**
- `cf.client.bot` - Detected as bot by Cloudflare
- `cf.bot_management.verified_bot` - Verified bots (Googlebot, Bingbot, etc.)

---

## Protect Against Scrapers

### Block requests without common headers

**Expression:**
```
(not http.request.headers["accept-language"][0] contains "pt" and not http.request.headers["accept-language"][0] contains "en") or (len(http.request.headers["accept-language"][0]) eq 0)
```

**Action:** Managed Challenge

---

### Block image hotlinking

**Expression:**
```
(http.request.uri.path.extension in {"jpg" "jpeg" "png" "gif" "webp"}) and not (http.referer contains "yourdomain.com") and (http.referer ne "")
```

**Action:** Block

---

## My Go-To Expression (Sensitive Files Protection)

This is an expression I use frequently in my projects. It blocks access to sensitive configuration files, environment variables, and common attack paths:

**Expression:**
```
(http.request.uri.path wildcard r"/admin/.htaccess") or (http.request.uri.path wildcard r"/admin/.htpasswd") or (http.request.uri.path wildcard r"/config.json") or (http.request.uri.path wildcard r"/env*") or (http.request.uri.path wildcard r"/.htaccess") or (http.request.uri.path wildcard r"/.htpasswd") or (http.request.uri.path wildcard r"/php.ini") or (http.request.uri.path wildcard r"/admin/.env.*") or (http.request.uri.path wildcard r"/application/.env.*") or (http.request.uri.path wildcard r"/application/.htaccess") or (http.request.uri.path wildcard r"/application/.htpasswd") or (http.request.uri.path wildcard r"/app-settings*") or (http.request.uri.path wildcard r"/.aws/*") or (http.request.uri.path wildcard r"/aws*") or (http.request.uri.path wildcard r"/backend/.env*") or (http.request.uri.path wildcard r"/backend/.htaccess") or (http.request.uri.path wildcard r"/backend/.htpasswd") or (http.request.uri.path wildcard r"/*/config") or (http.request.uri.path wildcard r"/config/*") or (http.request.uri.path wildcard r"/dev/.env*") or (http.request.uri.path wildcard r"/*/.env*") or (http.request.uri.path wildcard r"/.env*") or (http.request.uri.path wildcard r"/firebase*") or (http.request.uri.path wildcard r"/.git/*") or (http.request.uri.path wildcard r"/js/config*") or (http.request.uri.path wildcard r"/js/.env*") or (http.request.uri.path wildcard r"/js/env*") or (http.request.uri.path wildcard r"/js/settings*") or (http.request.uri.path wildcard r"/*.php?") or (http.request.uri.path wildcard r"/_profiler/*") or (http.request.uri.path wildcard r"/*/wlwmanifest.xml") or (http.request.uri.path wildcard r"/wp-admin/*") or (http.request.uri.path wildcard r"/wp-content/*") or (http.request.uri.path wildcard r"/wp-includes/*") or (http.request.uri.path wildcard r"/.s3cfg")
```

**Action:** Block

**What it protects:**
- `.env` files (environment variables with secrets)
- `.htaccess` and `.htpasswd` (Apache config)
- `.git` directory (source code exposure)
- `config.json`, `php.ini`, `firebase*` (configuration files)
- `.aws` and `.s3cfg` (AWS credentials)
- WordPress paths (`wp-admin`, `wp-content`, `wp-includes`)
- Symfony profiler (`_profiler`)
- Various config paths across different frameworks

---

## Priority Order

Custom Rules are evaluated in order. Put more specific rules first:

1. Allow rules (whitelist)
2. Skip rules (security bypass for trusted services)
3. Block/Challenge rules

---

## Tips

- Always test rules in **Log** mode before applying Block
- Use **Security Events** to monitor what's being blocked
- Combine multiple conditions with `and` / `or` for greater precision
- Regularly update your allowed IP list
