# Security-IT

Open-source repository with practical security tips for developers.

Repositório open-source com dicas práticas de segurança para desenvolvedores.

## About

Security-IT is a collection of rules, snippets, and security guides to protect your applications. We started with a focus on Cloudflare, but the project is expanding to cover more topics.

**Languages:** English | Português

## Content

### Cloudflare
- Custom Rules (WAF)
- Rate Limiting
- IP Access Rules
- Firewall Expressions

### Coming Soon
- HTTP Security Headers
- API Security
- Authentication Best Practices

## Structure

```
security-it/
├── _config.yml          # Jekyll configuration
├── index.md             # Landing page (language selector)
├── en/                  # English content
│   ├── index.md
│   └── cloudflare/
│       ├── index.md
│       ├── custom-rules.md
│       ├── rate-limiting.md
│       ├── ip-access.md
│       └── expressions.md
├── pt/                  # Portuguese content
│   ├── index.md
│   └── cloudflare/
│       ├── index.md
│       ├── custom-rules.md
│       ├── rate-limiting.md
│       ├── ip-access.md
│       └── expressions.md
├── snippets/            # Ready-to-use code
│   └── cloudflare/
└── assets/
    ├── css/
    └── img/
```

## Contributing

1. Fork the project
2. Create a branch (`git checkout -b feature/new-rule`)
3. Commit your changes (`git commit -m 'Add: new rule for X'`)
4. Push to branch (`git push origin feature/new-rule`)
5. Open a Pull Request

## Author

**Daniel Mendes** - Security & Full-Stack Developer

- GitHub: [@DanielMendesSensei](https://github.com/DanielMendesSensei)
- Portfolio: [senseidanielmendes.vercel.app](https://senseidanielmendes.vercel.app/)

## License

MIT License - see [LICENSE](LICENSE) for details.
