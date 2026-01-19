---
layout: default
title: Rate Limiting - Cloudflare
lang: pt
permalink: /pt/cloudflare/rate-limiting/
---

{% include nav.html lang="pt" back_url="/pt/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/pt/cloudflare/" current="Rate Limiting" pt_url="/pt/cloudflare/rate-limiting/" en_url="/en/cloudflare/rate-limiting/" %}

{% include cloudflare-menu.html lang="pt" active="rate-limiting" %}

# Rate Limiting

Rate Limiting controla a quantidade de requisicoes permitidas em um periodo de tempo, protegendo contra ataques de forca bruta e abuso de API.

---

## Proteger Login

### Limitar tentativas de login

**Expression:**
```
(http.request.uri.path eq "/api/auth/login" or http.request.uri.path eq "/login") and (http.request.method eq "POST")
```

**Configuração:**
- **Requests:** 5
- **Period:** 1 minuto
- **Ação:** Block por 10 minutos

**Por que funciona:**
- Um usuario legitimo raramente erra a senha 5 vezes em 1 minuto
- Ataques de brute force fazem centenas de tentativas por minuto

---

### Rate limit progressivo

Crie multiplas regras com penalidades crescentes:

**Regra 1 - Warning (Log)**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```
- 10 requests/minuto
- Ação: Log

**Regra 2 - Challenge**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```
- 5 requests/minuto
- Ação: Managed Challenge

**Regra 3 - Block**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```
- 3 requests/minuto
- Ação: Block por 1 hora

---

## Proteger APIs

### Limite geral para API

**Expression:**
```
(http.request.uri.path starts_with "/api/")
```

**Configuração:**
- **Requests:** 100
- **Period:** 1 minuto
- **Counting:** Por IP

---

### Limite por endpoint especifico

**Expression:**
```
(http.request.uri.path eq "/api/expensive-operation")
```

**Configuração:**
- **Requests:** 10
- **Period:** 1 minuto
- **Ação:** Block

---

### Limite para usuarios autenticados vs anonimos

**Regra 1 - Anonimos (mais restritivo)**
```
(http.request.uri.path starts_with "/api/") and not (http.request.headers["authorization"][0] ne "")
```
- 20 requests/minuto

**Regra 2 - Autenticados (mais permissivo)**
```
(http.request.uri.path starts_with "/api/") and (http.request.headers["authorization"][0] ne "")
```
- 100 requests/minuto

---

## Proteger contra Credential Stuffing

### Detectar padrao de ataque

**Expression:**
```
(http.request.uri.path eq "/login") and (http.request.method eq "POST")
```

**Configuração:**
- **Requests:** 3
- **Period:** 10 segundos
- **Counting:** Por IP
- **Ação:** Block por 1 hora

**Logica:** Nenhum humano digita credenciais 3 vezes em 10 segundos.

---

## Proteger Forms

### Limitar submissao de formularios

**Expression:**
```
(http.request.uri.path eq "/contact" or http.request.uri.path eq "/newsletter") and (http.request.method eq "POST")
```

**Configuração:**
- **Requests:** 3
- **Period:** 1 hora
- **Ação:** Block

---

## Counting Characteristics

O Cloudflare permite contar requisicoes por diferentes criterios:

| Caracteristica | Uso |
|----------------|-----|
| **IP** | Padrao, bloqueia por endereco IP |
| **IP + URI Path** | Diferente limite por endpoint |
| **Headers** | Útil para APIs com API keys |
| **Cookie** | Tracking por sessao |
| **Query String** | Limite por parametro |

---

## Resposta Personalizada

Você pode configurar uma resposta customizada quando o rate limit e atingido:

```json
{
  "error": "rate_limit_exceeded",
  "message": "Muitas requisicoes. Tente novamente em alguns minutos.",
  "retry_after": 60
}
```

**Response Code:** 429 (Too Many Requests)

---

## Monitoramento

Apos configurar rate limiting:

1. Acesse **Security > Events** no dashboard
2. Filtre por "Rate Limiting"
3. Analise padroes de trafego bloqueado
4. Ajuste thresholds conforme necessario

---

## Dicas

- Comece com limites altos e reduza gradualmente
- Use **Log** para entender padroes antes de bloquear
- Considere diferentes limites para diferentes endpoints
- APIs publicas precisam de limites mais generosos
- APIs internas podem ter limites mais restritivos

---

[Voltar para Cloudflare](/cloudflare/) | [Ver Snippets](/snippets/cloudflare/)
