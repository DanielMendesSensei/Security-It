---
layout: default
title: Firewall Expressions - Cloudflare
lang: pt
permalink: /pt/cloudflare/expressions/
---

{% include nav.html lang="pt" back_url="/pt/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/pt/cloudflare/" current="Expressions" pt_url="/pt/cloudflare/expressions/" en_url="/en/cloudflare/expressions/" %}

{% include cloudflare-menu.html lang="pt" active="expressions" %}

# Firewall Expressions

Biblioteca de expressoes prontas para usar em Custom Rules, Rate Limiting e outras regras do Cloudflare.

---

## Campos Disponiveis

### Request Fields

| Campo | Descri\u00e7\u00e3o | Exemplo |
|-------|-----------|---------|
| `http.request.uri.path` | Caminho da URL | `/api/users` |
| `http.request.uri.query` | Query string | `?id=123` |
| `http.request.method` | Metodo HTTP | `POST` |
| `http.request.headers["nome"]` | Header especifico | `Authorization` |
| `http.host` | Hostname | `api.site.com` |
| `http.user_agent` | User Agent | `Mozilla/5.0...` |
| `http.referer` | Referer | `https://google.com` |

### IP Fields

| Campo | Descrição | Exemplo |
|-------|-----------|---------|
| `ip.src` | IP do visitante | `192.168.1.1` |
| `ip.geoip.country` | País (ISO code) | `BR` |
| `ip.geoip.continent` | Continente | `SA` |
| `ip.geoip.asnum` | ASN | `12345` |

### Bot Fields

| Campo | Descrição |
|-------|-----------|
| `cf.client.bot` | É um bot? |
| `cf.bot_management.score` | Score de bot (0-99) |
| `cf.bot_management.verified_bot` | Bot verificado? |

### Threat Fields

| Campo | Descrição |
|-------|-----------|
| `cf.threat_score` | Score de ameaça (0-100) |
| `cf.edge.server_port` | Porta do servidor |

---

## Operadores

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `eq` | Igual | `http.request.method eq "POST"` |
| `ne` | Diferente | `ip.geoip.country ne "BR"` |
| `contains` | Contém | `http.request.uri.path contains "/admin"` |
| `starts_with` | Começa com | `http.request.uri.path starts_with "/api/"` |
| `ends_with` | Termina com | `http.request.uri.path ends_with ".php"` |
| `in` | Está na lista | `ip.geoip.country in {"BR" "US"}` |
| `matches` | Regex | `http.request.uri.path matches "^/user/[0-9]+$"` |
| `gt`, `lt`, `ge`, `le` | Comparação numérica | `cf.threat_score gt 50` |

### Operadores Lógicos

| Operador | Descrição |
|----------|-----------|
| `and` | E lógico |
| `or` | OU lógico |
| `not` | Negação |
| `( )` | Agrupamento |

---

## Expressões Prontas

### Protecao de Rotas

```bash
# Bloquear acesso a /admin
(http.request.uri.path contains "/admin")

# Proteger multiplas rotas sensiveis
(http.request.uri.path in {"/admin" "/dashboard" "/settings" "/api/admin"})

# Proteger com excecao de IP
(http.request.uri.path contains "/admin") and not (ip.src in {SEU_IP})

# Proteger subdominios especificos
(http.host eq "admin.seusite.com") and not (ip.src in {SEU_IP})
```

---

### Deteccao de Bots

```bash
# User-Agent vazio
(http.user_agent eq "")

# Bots conhecidos por serem maliciosos
(http.user_agent contains "curl" or http.user_agent contains "wget" or http.user_agent contains "python-requests")

# Score de bot alto (requer Bot Management)
(cf.bot_management.score lt 30)

# Bots não verificados
(cf.client.bot) and not (cf.bot_management.verified_bot)

# Threat score alto
(cf.threat_score gt 50)
```

---

### Geoblocking

```bash
# Bloquear paises especificos
(ip.geoip.country in {"CN" "RU" "KP" "IR"})

# Permitir apenas Brasil
not (ip.geoip.country eq "BR")

# Bloquear continente inteiro
(ip.geoip.continent eq "AS")

# Bloquear pais mas permitir IPs especificos
(ip.geoip.country eq "CN") and not (ip.src in {IPS_PERMITIDOS})
```

---

### Protecao de API

```bash
# Requisicoes sem Authorization header
(http.request.uri.path starts_with "/api/") and not (len(http.request.headers["authorization"][0]) gt 0)

# Bloquear métodos não permitidos
(http.request.uri.path starts_with "/api/") and not (http.request.method in {"GET" "POST" "PUT" "DELETE"})

# Content-Type invalido para POST
(http.request.method eq "POST") and not (http.request.headers["content-type"][0] contains "application/json")
```

---

### Protecao WordPress

```bash
# Proteger wp-admin e wp-login
(http.request.uri.path contains "/wp-admin" or http.request.uri.path contains "/wp-login.php") and not (ip.src in {SEU_IP})

# Bloquear xmlrpc (frequentemente atacado)
(http.request.uri.path eq "/xmlrpc.php")

# Bloquear upload de PHP em wp-content
(http.request.uri.path contains "/wp-content/uploads/" and http.request.uri.path ends_with ".php")
```

---

### Protecao Next.js

```bash
# Proteger API routes administrativas
(http.request.uri.path starts_with "/api/admin")

# Bloquear acesso direto a _next/static com parametros suspeitos
(http.request.uri.path starts_with "/_next/") and (http.request.uri.query contains "<script")

# Proteger Server Actions
(http.request.method eq "POST") and (http.request.headers["next-action"][0] ne "") and not (http.referer contains "seusite.com")
```

---

### Anti-Scraping

```bash
# Requisicoes muito rapidas do mesmo IP (combine com rate limiting)
(http.request.uri.path starts_with "/products/")

# Sem Accept-Language (comum em scrapers)
(len(http.request.headers["accept-language"][0]) eq 0)

# Bloquear hotlinking
(http.request.uri.path.extension in {"jpg" "png" "gif" "webp"}) and not (http.referer contains "seusite.com") and (len(http.referer) gt 0)
```

---

### Combinacoes Avancadas

```bash
# Login suspeito: POST sem referer valido
(http.request.uri.path eq "/login") and (http.request.method eq "POST") and not (http.referer contains "seusite.com")

# API abusiva: muitas requisicoes + user-agent suspeito
(http.request.uri.path starts_with "/api/") and (http.user_agent contains "bot" or http.user_agent eq "")

# Ataque em formulario: POST de pais inesperado
(http.request.method eq "POST") and not (ip.geoip.country in {"BR" "US" "PT"})
```

---

## Funcoes Uteis

```bash
# Tamanho de string
len(http.user_agent) eq 0

# Lowercase
lower(http.request.uri.path) contains "/admin"

# Expressao regular
http.request.uri.path matches "^/user/[0-9]+$"

# Verificar se header existe
http.request.headers["x-api-key"][0] ne ""
```

---

## Debug de Expressoes

Para testar uma expressao:

1. Crie a regra com acao **Log**
2. Aguarde trafego
3. Verifique em **Security > Events**
4. Ajuste conforme necessario
5. Mude para a ação desejada

---

[Voltar para Cloudflare](/cloudflare/) | [Ver Snippets](/snippets/cloudflare/)
