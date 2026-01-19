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

## Where to Host / Onde Hospedar

### Option 1: GitHub Pages (Free)
The simplest option, directly integrated with GitHub.

```bash
# 1. Push to GitHub
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/DanielMendesSensei/Security-It.git
git push -u origin main

# 2. Enable GitHub Pages
# Settings > Pages > Source: main branch
```

**URL:** `https://YOUR_USER.github.io/security-it`

---

### Option 2: Cloudflare Pages (Free) - Recommended
Ironic and perfect for a security project!

```bash
# 1. Push to GitHub (same as above)

# 2. Go to Cloudflare Dashboard
# Pages > Create a project > Connect to Git

# 3. Configure build
# Framework preset: Jekyll
# Build command: jekyll build
# Build output directory: _site
```

**Benefits:**
- Global CDN
- Automatic HTTPS
- Preview deployments for PRs
- Web Analytics included

---

### Option 3: Vercel (Free)

```bash
# 1. Install Vercel CLI
npm i -g vercel

# 2. Deploy
vercel

# Or connect via GitHub in vercel.com
```

---

### Option 4: Netlify (Free)

```bash
# 1. Connect repo at netlify.com
# 2. Build settings:
#    Build command: jekyll build
#    Publish directory: _site
```

## Local Development

```bash
# Clone the repository
git clone https://github.com/DanielMendesSensei/Security-It.git
cd security-it

# Install dependencies
bundle install

# Run locally
bundle exec jekyll serve

# Access http://localhost:4000/security-it
```

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
