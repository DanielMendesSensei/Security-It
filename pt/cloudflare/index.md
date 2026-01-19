---
layout: default
title: Cloudflare Security
lang: pt
permalink: /pt/cloudflare/
---

{% include nav.html lang="pt" back_url="/pt/" back_text="Home" section="PT" section_url="/pt/" current="Cloudflare" pt_url="/pt/cloudflare/" en_url="/en/cloudflare/" %}

# Cloudflare Security

Guias práticos para proteger suas aplicações usando os recursos de segurança do Cloudflare.

---

## Categorias

### [Custom Rules](/pt/cloudflare/custom-rules)
Regras personalizadas para bloquear, desafiar ou permitir trafego baseado em condicoes especificas.

**Casos de uso:**
- Proteger rotas administrativas
- Bloquear paises especificos
- Desafiar bots suspeitos

---

### [Rate Limiting](/pt/cloudflare/rate-limiting)
Controle a quantidade de requisicoes por IP, usuario ou endpoint.

**Casos de uso:**
- Proteger login contra brute force
- Limitar chamadas de API
- Prevenir credential stuffing

---

### [IP Access Rules](/pt/cloudflare/ip-access)
Gerencie whitelist e blacklist de IPs, ASNs e paises.

**Casos de uso:**
- Whitelist de serviços confiáveis
- Bloquear IPs maliciosos conhecidos
- Geoblocking

---

### [Expressions Library](/pt/cloudflare/expressions)
Biblioteca de expressoes prontas para usar em suas regras.

**Inclui:**
- Expressoes para detectar bots
- Filtros por user-agent
- Padroes de URL suspeitos

---

## Nivel de Acesso

| Feature | Free | Pro | Business | Enterprise |
|---------|------|-----|----------|------------|
| Custom Rules | 5 | 20 | 100 | 1000 |
| Rate Limiting | Basico | Avancado | Avancado | Avancado |
| IP Access Rules | Ilimitado | Ilimitado | Ilimitado | Ilimitado |
| WAF Managed Rules | Basico | Completo | Completo | Completo |

---

## Links Uteis

- [Cloudflare Dashboard](https://dash.cloudflare.com)
- [Cloudflare Docs - WAF](https://developers.cloudflare.com/waf/)
- [Cloudflare Docs - Rate Limiting](https://developers.cloudflare.com/waf/rate-limiting-rules/)
