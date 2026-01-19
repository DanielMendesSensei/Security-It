---
layout: default
title: Custom Rules - Cloudflare
lang: pt
permalink: /pt/cloudflare/custom-rules/
---

{% include nav.html lang="pt" back_url="/pt/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/pt/cloudflare/" current="Custom Rules" pt_url="/pt/cloudflare/custom-rules/" en_url="/en/cloudflare/custom-rules/" %}

{% include cloudflare-menu.html lang="pt" active="custom-rules" %}

# Custom Rules

Custom Rules permitem controlar o trafego de entrada filtrando requisicoes com base em condicoes especificas.

---

## Proteger Rotas Administrativas

### Bloquear acesso ao /admin exceto IPs permitidos

**Expression:**
```
(http.request.uri.path contains "/admin") and not (ip.src in {192.168.1.1 10.0.0.1})
```

**Ação:** Block

**Explicação:**
- `http.request.uri.path contains "/admin"` - Captura qualquer URL com /admin
- `ip.src in {...}` - Lista de IPs permitidos
- `not` - Inverte a condição, bloqueando quem NÃO está na lista

---

### Proteger wp-admin (WordPress)

**Expression:**
```
(http.request.uri.path contains "/wp-admin" or http.request.uri.path contains "/wp-login.php") and not (ip.src in {SEU_IP})
```

**Ação:** Block

---

### Proteger API routes (Next.js/Node)

**Expression:**
```
(http.request.uri.path starts_with "/api/admin") and not (ip.src in {SEU_IP})
```

**Ação:** Block

---

## Bloquear por Pais

### Bloquear paises com alto indice de ataques

**Expression:**
```
(ip.geoip.country in {"CN" "RU" "KP" "IR"})
```

**Ação:** Block ou Managed Challenge

**Nota:** Ajuste a lista conforme seu público-alvo. Se você tem usuários legítimos desses países, use Managed Challenge em vez de Block.

---

### Permitir apenas paises especificos

**Expression:**
```
not (ip.geoip.country in {"BR" "US" "PT"})
```

**Ação:** Block

---

## Desafiar Bots Suspeitos

### User-Agent vazio ou suspeito

**Expression:**
```
(http.user_agent eq "") or (http.user_agent contains "curl") or (http.user_agent contains "wget")
```

**Ação:** Managed Challenge

---

### Bloquear bots conhecidos (exceto bons)

**Expression:**
```
(cf.client.bot) and not (cf.bot_management.verified_bot)
```

**Ação:** Block

**Explicação:**
- `cf.client.bot` - Detectado como bot pelo Cloudflare
- `cf.bot_management.verified_bot` - Bots verificados (Googlebot, Bingbot, etc.)

---

## Proteger contra Scrapers

### Bloquear requisicoes sem headers comuns

**Expression:**
```
(not http.request.headers["accept-language"][0] contains "pt" and not http.request.headers["accept-language"][0] contains "en") or (len(http.request.headers["accept-language"][0]) eq 0)
```

**Ação:** Managed Challenge

---

### Bloquear hotlinking de imagens

**Expression:**
```
(http.request.uri.path.extension in {"jpg" "jpeg" "png" "gif" "webp"}) and not (http.referer contains "seudominio.com") and (http.referer ne "")
```

**Ação:** Block

---

## Minha Expressao Favorita (Protecao de Arquivos Sensiveis)

Esta e uma expressao que utilizo bastante nos meus projetos. Ela bloqueia acesso a arquivos de configuracao sensiveis, variaveis de ambiente e caminhos comuns de ataque:

**Expression:**
```
(http.request.uri.path wildcard r"/admin/.htaccess") or (http.request.uri.path wildcard r"/admin/.htpasswd") or (http.request.uri.path wildcard r"/config.json") or (http.request.uri.path wildcard r"/env*") or (http.request.uri.path wildcard r"/.htaccess") or (http.request.uri.path wildcard r"/.htpasswd") or (http.request.uri.path wildcard r"/php.ini") or (http.request.uri.path wildcard r"/admin/.env.*") or (http.request.uri.path wildcard r"/application/.env.*") or (http.request.uri.path wildcard r"/application/.htaccess") or (http.request.uri.path wildcard r"/application/.htpasswd") or (http.request.uri.path wildcard r"/app-settings*") or (http.request.uri.path wildcard r"/.aws/*") or (http.request.uri.path wildcard r"/aws*") or (http.request.uri.path wildcard r"/backend/.env*") or (http.request.uri.path wildcard r"/backend/.htaccess") or (http.request.uri.path wildcard r"/backend/.htpasswd") or (http.request.uri.path wildcard r"/*/config") or (http.request.uri.path wildcard r"/config/*") or (http.request.uri.path wildcard r"/dev/.env*") or (http.request.uri.path wildcard r"/*/.env*") or (http.request.uri.path wildcard r"/.env*") or (http.request.uri.path wildcard r"/firebase*") or (http.request.uri.path wildcard r"/.git/*") or (http.request.uri.path wildcard r"/js/config*") or (http.request.uri.path wildcard r"/js/.env*") or (http.request.uri.path wildcard r"/js/env*") or (http.request.uri.path wildcard r"/js/settings*") or (http.request.uri.path wildcard r"/*.php?") or (http.request.uri.path wildcard r"/_profiler/*") or (http.request.uri.path wildcard r"/*/wlwmanifest.xml") or (http.request.uri.path wildcard r"/wp-admin/*") or (http.request.uri.path wildcard r"/wp-content/*") or (http.request.uri.path wildcard r"/wp-includes/*") or (http.request.uri.path wildcard r"/.s3cfg")
```

**Acao:** Block

**O que ela protege:**
- Arquivos `.env` (variaveis de ambiente com segredos)
- `.htaccess` e `.htpasswd` (configuracao Apache)
- Diretorio `.git` (exposicao de codigo fonte)
- `config.json`, `php.ini`, `firebase*` (arquivos de configuracao)
- `.aws` e `.s3cfg` (credenciais AWS)
- Caminhos WordPress (`wp-admin`, `wp-content`, `wp-includes`)
- Profiler do Symfony (`_profiler`)
- Diversos caminhos de config de diferentes frameworks

---

## Ordem de Prioridade

As Custom Rules sao avaliadas em ordem. Coloque regras mais especificas primeiro:

1. Regras de Allow (whitelist)
2. Regras de Skip (bypass de segurança para serviços confiáveis)
3. Regras de Block/Challenge

---

## Dicas

- Sempre teste regras em modo **Log** antes de aplicar Block
- Use **Security Events** para monitorar o que está sendo bloqueado
- Combine multiplas condicoes com `and` / `or` para maior precisao
- Atualize regularmente sua lista de IPs permitidos
