---
layout: default
title: IP Access Rules - Cloudflare
lang: pt
permalink: /pt/cloudflare/ip-access/
---

{% include nav.html lang="pt" back_url="/pt/cloudflare/" back_text="Cloudflare" section="Cloudflare" section_url="/pt/cloudflare/" current="IP Access" pt_url="/pt/cloudflare/ip-access/" en_url="/en/cloudflare/ip-access/" %}

{% include cloudflare-menu.html lang="pt" active="ip-access" %}

# IP Access Rules

IP Access Rules permitem controlar o acesso baseado em IP, ASN (Autonomous System Number) ou pais.

---

## Whitelist

### Permitir serviços confiáveis

Adicione IPs de serviços que precisam acessar seu site sem restrições:

| Serviço | Ação |
|---------|------|
| Seu IP de escritorio | Allow |
| Servidor de CI/CD | Allow |
| Payment Gateway (Stripe, etc) | Allow |
| Monitoring (UptimeRobot, etc) | Allow |

**Como adicionar:**
1. Acesse Security > WAF > Tools
2. Clique em "IP Access Rules"
3. Adicione o IP/Range com ação "Allow"

---

### IPs do Stripe (exemplo)

```
# Stripe Webhooks - whitelist estes IPs
3.18.12.63
3.130.192.231
13.235.14.237
13.235.122.149
18.211.135.69
35.154.171.200
52.15.183.38
54.88.130.119
54.88.130.237
54.187.174.169
54.187.205.235
54.187.216.72
```

---

## Blacklist

### Bloquear IPs maliciosos

Quando identificar um IP atacante nos logs:

1. Acesse Security > Events
2. Identifique o IP
3. Adicione em IP Access Rules com ação "Block"

**Dica:** Use "Challenge" em vez de "Block" se não tiver certeza.

---

### Bloquear ranges conhecidos por ataques

Alguns ranges de IP sao frequentemente usados por atacantes:

```
# Exemplo - verifique antes de bloquear
# Data centers frequentemente usados por bots
```

**Cuidado:** Bloquear ranges grandes pode afetar usuarios legitimos.

---

## Geoblocking

### Bloquear paises inteiros

**Opcao 1: Via IP Access Rules**
1. Security > WAF > Tools
2. IP Access Rules
3. Selecione "Country" e escolha o pais
4. Ação: Block

**Opcao 2: Via Custom Rules (recomendado)**
```
(ip.geoip.country in {"CN" "RU" "KP"})
```

Custom Rules sao mais flexiveis pois permitem excecoes.

---

### Bloquear por ASN

ASN e útil para bloquear data centers inteiros usados por bots:

```
# Exemplo de ASNs frequentemente associados a bots
# Pesquise antes de bloquear
```

**Como encontrar ASN:**
1. Acesse Security > Events
2. Clique em um evento
3. O ASN aparece nos detalhes

---

## IP Lists

Para gerenciar muitos IPs, use IP Lists:

### Criar uma lista

1. Manage Account > Configurations > Lists
2. Crie uma nova lista
3. Adicione IPs

### Usar a lista em regras

```
(ip.src in $lista_ips_bloqueados)
```

**Vantagens:**
- Centraliza gerenciamento
- Fácil de atualizar
- Pode ser usada em multiplas regras

---

## Prioridade de Regras

A ordem de avaliação no Cloudflare:

1. IP Access Rules (Allow)
2. Custom Rules
3. Rate Limiting Rules
4. Managed Rules (WAF)
5. IP Access Rules (Block/Challenge)

**Importante:** IPs com "Allow" em IP Access Rules passam por cima de bloqueios de país, mas NÃO passam por Custom Rules com Block.

---

## Casos de Uso Comuns

### E-commerce Brasil

```
# Permitir apenas Brasil + Portugal + USA
not (ip.geoip.country in {"BR" "PT" "US"})
```
Ação: Block

---

### API com whitelist de parceiros

```
# Bloquear tudo exceto parceiros
not (ip.src in $lista_parceiros)
```
Ação: Block

---

### Proteger staging/dev

```
# Staging so acessivel do escritorio
(http.host eq "staging.seusite.com") and not (ip.src in {IP_ESCRITORIO})
```
Ação: Block

---

## Boas Práticas

1. **Documente seus IPs** - Mantenha uma lista de quais IPs estao permitidos e por que
2. **Revise periodicamente** - IPs mudam, serviços mudam
3. **Use Lists** - Mais fácil de gerenciar que regras individuais
4. **Prefira Challenge a Block** - Menos chance de bloquear usuarios legitimos
5. **Monitore Security Events** - Veja o que está sendo bloqueado

---

## Troubleshooting

### Usuario legitimo bloqueado

1. Peca o IP do usuario
2. Verifique em Security > Events
3. Identifique qual regra bloqueou
4. Adicione excecao ou ajuste a regra

### Como verificar seu IP

Peca para o usuario acessar: [whatismyip.com](https://whatismyip.com)

---

[Voltar para Cloudflare](/cloudflare/) | [Ver Snippets](/snippets/cloudflare/)
