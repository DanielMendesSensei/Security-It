---
layout: default
title: Snippets
---

# Snippets

Código pronto para copiar e usar nos seus projetos.

---

## Cloudflare

### Custom Rules (JSON para API)

Estes snippets podem ser usados com a [Cloudflare API](https://developers.cloudflare.com/api/) ou importados via Terraform.

| Snippet | Descrição |
|---------|-----------|
| [block-admin.json](/snippets/cloudflare/block-admin.json) | Bloquear acesso a /admin |
| [rate-limit-login.json](/snippets/cloudflare/rate-limit-login.json) | Rate limit em rotas de login |
| [challenge-bots.json](/snippets/cloudflare/challenge-bots.json) | Desafiar bots suspeitos |
| [geoblocking.json](/snippets/cloudflare/geoblocking.json) | Bloquear paises |
| [protect-api.json](/snippets/cloudflare/protect-api.json) | Proteger endpoints de API |

---

### Como usar via API

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/rulesets/{ruleset_id}/rules" \
  -H "Authorization: Bearer {api_token}" \
  -H "Content-Type: application/json" \
  -d @block-admin.json
```

---

### Terraform

```hcl
resource "cloudflare_ruleset" "security_rules" {
  zone_id     = var.zone_id
  name        = "Security Rules"
  description = "Custom security rules"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules {
    action      = "block"
    expression  = "(http.request.uri.path contains \"/admin\") and not (ip.src in {192.168.1.1})"
    description = "Block admin access"
    enabled     = true
  }
}
```

---

## Em breve

- HTTP Security Headers
- NGINX configs
- Apache configs
- Traefik middleware

---

[Voltar para Home](/)
