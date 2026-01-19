---
layout: default
title: Rate Limiting - Cloudflare
lang: en
permalink: /en/cloudflare/rate-limiting/
---

{% include nav.html lang="en" back_url="/en/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/en/cloudflare/" current="Rate Limiting" pt_url="/pt/cloudflare/rate-limiting/" en_url="/en/cloudflare/rate-limiting/" %}

{% include cloudflare-menu.html lang="en" active="rate-limiting" %}

# Rate Limiting

Rate Limiting controls the number of requests allowed within a time period, protecting against brute force attacks and API abuse.

---

## Protect Login

### Limit login attempts

**Expression:**
```
(http.request.uri.path eq "/api/auth/login" or http.request.uri.path eq "/login") and (http.request.method eq "POST")
```

**Configuration:**
- **Requests:** 5
- **Period:** 1 minute
- **Action:** Block for 10 minutes

**Why it works:**
- A legitimate user rarely misses the password 5 times in 1 minute
- Brute force attacks make hundreds of attempts per minute

---

### Progressive rate limit

Create multiple rules with increasing penalties:

**Rule 1 - Warning (Log)**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```
- 10 requests/minute
- Action: Log

**Rule 2 - Challenge**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```
- 5 requests/minute
- Action: Managed Challenge

**Rule 3 - Block**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```
- 3 requests/minute
- Action: Block for 1 hour

---

## Protect APIs

### General API limit

**Expression:**
```
(http.request.uri.path starts_with "/api/")
```

**Configuration:**
- **Requests:** 100
- **Period:** 1 minute
- **Counting:** Per IP

---

### Limit per specific endpoint

**Expression:**
```
(http.request.uri.path eq "/api/expensive-operation")
```

**Configuration:**
- **Requests:** 10
- **Period:** 1 minute
- **Action:** Block

---

### Limit for authenticated vs anonymous users

**Rule 1 - Anonymous (more restrictive)**
```
(http.request.uri.path starts_with "/api/") and not (http.request.headers["authorization"][0] ne "")
```
- 20 requests/minute

**Rule 2 - Authenticated (more permissive)**
```
(http.request.uri.path starts_with "/api/") and (http.request.headers["authorization"][0] ne "")
```
- 100 requests/minute

---

## Protect Against Credential Stuffing

### Detect attack pattern

**Expression:**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```

**Configuration:**
- **Requests:** 3
- **Period:** 10 seconds
- **Counting:** Per IP
- **Action:** Block for 1 hour

**Logic:** No human types credentials 3 times in 10 seconds.

---

## Protect Forms

### Limit form submissions

**Expression:**
```
(http.request.uri.path eq "/contact" or http.request.uri.path eq "/newsletter") and (http.request.method eq "POST")
```

**Configuration:**
- **Requests:** 3
- **Period:** 1 hour
- **Action:** Block

---

## Counting Characteristics

Cloudflare allows counting requests by different criteria:

| Characteristic | Use |
|----------------|-----|
| **IP** | Default, blocks by IP address |
| **IP + URI Path** | Different limit per endpoint |
| **Headers** | Useful for APIs with API keys |
| **Cookie** | Tracking by session |
| **Query String** | Limit per parameter |

---

## Custom Response

You can configure a custom response when rate limit is reached:

```json
{
  "error": "rate_limit_exceeded",
  "message": "Too many requests. Please try again in a few minutes.",
  "retry_after": 60
}
```

**Response Code:** 429 (Too Many Requests)

---

## Monitoring

After configuring rate limiting:

1. Go to **Security > Events** in the dashboard
2. Filter by "Rate Limiting"
3. Analyze blocked traffic patterns
4. Adjust thresholds as needed

---

## Tips

- Start with high limits and reduce gradually
- Use **Log** to understand patterns before blocking
- Consider different limits for different endpoints
- Public APIs need more generous limits
- Internal APIs can have more restrictive limits

---

[Back to Cloudflare](/en/cloudflare/) | [View Snippets](/snippets/cloudflare/)
