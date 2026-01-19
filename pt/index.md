---
layout: default
title: Home
lang: pt
permalink: /pt/
---

{% include nav.html lang="pt" back_url="/" back_text="Idioma" current="Português" pt_url="/pt/" en_url="/en/" %}

# Security-IT

Bem-vindo ao **Security-IT** - um repositório open-source com dicas práticas de segurança para desenvolvedores.

---

## O que você vai encontrar aqui

### Cloudflare Security

Regras prontas para copiar e usar no seu projeto:

- **[Custom Rules](/pt/cloudflare/custom-rules)** - Bloqueie acessos indesejados com regras personalizadas
- **[Rate Limiting](/pt/cloudflare/rate-limiting)** - Proteja suas APIs e rotas de login
- **[IP Access Rules](/pt/cloudflare/ip-access)** - Gerencie whitelist e blacklist de IPs
- **[WAF Expressions](/pt/cloudflare/expressions)** - Biblioteca de expressões prontas

### Em breve

- Segurança em APIs REST
- Headers de Segurança HTTP
- CORS e CSRF Protection
- Autenticação e Autorização

---

## Por que este projeto?

Muitos desenvolvedores configuram o Cloudflare mas não exploram todo o potencial das ferramentas de segurança disponíveis. Este repositório oferece:

| Benefício | Descrição |
|-----------|-----------|
| **Copy-paste ready** | Regras prontas para usar |
| **Explicado** | Cada regra comentada |
| **Por caso de uso** | Encontre rapido o que precisa |
| **Open source** | Contribua com suas regras |

---

## Quick Start

### Proteger rota de admin (Cloudflare Custom Rule)

```
(http.request.uri.path contains "/admin") and not (ip.src in {SEU_IP})
```

**Ação:** Block

### Rate limit em login

```
(http.request.uri.path eq "/api/auth/login") and (http.request.method eq "POST")
```

**Ação:** Rate Limit - 5 requests/minuto

---

## Contribua

Encontrou uma regra util? Abra um PR!

1. Fork o repositório
2. Adicione sua regra em `snippets/`
3. Documente o caso de uso
4. Envie o Pull Request

[Ver no GitHub](https://github.com/DanielMendesSensei/Security-It){: .btn}
