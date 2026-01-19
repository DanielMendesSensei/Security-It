# Security-IT Makefile
# Comandos uteis para desenvolvimento e deploy

.PHONY: help install serve build clean deploy lint

# Cores para output
GREEN  := \033[0;32m
YELLOW := \033[0;33m
CYAN   := \033[0;36m
NC     := \033[0m # No Color

help: ## Mostra esta ajuda
	@echo ""
	@echo "$(CYAN)Security-IT$(NC) - Comandos disponiveis:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

install: ## Instala dependencias do projeto
	@echo "$(YELLOW)Instalando dependencias...$(NC)"
	bundle config set --local path 'vendor/bundle'
	bundle install
	@echo "$(GREEN)Dependencias instaladas!$(NC)"

serve: ## Roda servidor local (http://localhost:4000/security-it/)
	@echo "$(YELLOW)Iniciando servidor...$(NC)"
	@echo "$(CYAN)Acesse: http://localhost:4000/security-it/$(NC)"
	bundle exec jekyll serve --host 0.0.0.0 --livereload 2>&1 | grep -v "Deprecation\|@import\|sass-lang\|\.scss\|^$$\|│\|╵\|╷\|^^^^"

serve-dev: ## Roda servidor SEM baseurl (http://localhost:4000/)
	@echo "$(YELLOW)Iniciando servidor em modo dev...$(NC)"
	@echo "$(CYAN)Acesse: http://localhost:4000/$(NC)"
	bundle exec jekyll serve --host 0.0.0.0 --livereload --baseurl "" 2>&1 | grep -v "Deprecation\|@import\|sass-lang\|\.scss\|^$$\|│\|╵\|╷\|^^^^"

serve-drafts: ## Roda servidor local com rascunhos
	@echo "$(YELLOW)Iniciando servidor com drafts...$(NC)"
	bundle exec jekyll serve --host 0.0.0.0 --livereload --drafts

build: ## Gera site estatico em _site/
	@echo "$(YELLOW)Gerando site...$(NC)"
	bundle exec jekyll build
	@echo "$(GREEN)Site gerado em _site/$(NC)"

build-prod: ## Gera site para producao
	@echo "$(YELLOW)Gerando site para producao...$(NC)"
	JEKYLL_ENV=production bundle exec jekyll build
	@echo "$(GREEN)Site de producao gerado em _site/$(NC)"

clean: ## Remove arquivos gerados
	@echo "$(YELLOW)Limpando arquivos...$(NC)"
	rm -rf _site .jekyll-cache .jekyll-metadata
	@echo "$(GREEN)Limpo!$(NC)"

clean-all: clean ## Remove tudo incluindo vendor
	@echo "$(YELLOW)Removendo vendor...$(NC)"
	rm -rf vendor .bundle Gemfile.lock
	@echo "$(GREEN)Tudo limpo!$(NC)"

update: ## Atualiza dependencias
	@echo "$(YELLOW)Atualizando dependencias...$(NC)"
	bundle update
	@echo "$(GREEN)Dependencias atualizadas!$(NC)"

# Git commands
git-status: ## Mostra status do git
	git status

commit: ## Commit interativo (uso: make commit m="mensagem")
	@if [ -z "$(m)" ]; then \
		echo "$(YELLOW)Uso: make commit m=\"sua mensagem\"$(NC)"; \
	else \
		git add . && git commit -m "$(m)"; \
	fi

push: ## Push para origin main
	git push origin main

# Deploy commands
deploy-gh: build-prod ## Deploy para GitHub Pages
	@echo "$(YELLOW)Fazendo deploy para GitHub Pages...$(NC)"
	git add .
	git commit -m "deploy: update site" || true
	git push origin main
	@echo "$(GREEN)Deploy realizado! Aguarde alguns minutos para o GitHub Pages atualizar.$(NC)"

# Validation
lint: ## Verifica links quebrados
	@echo "$(YELLOW)Verificando links...$(NC)"
	bundle exec htmlproofer ./_site --disable-external || true

check-urls: ## Lista todas as URLs do site
	@echo "$(CYAN)URLs do site:$(NC)"
	@find _site -name "*.html" | sed 's/_site//' | sed 's/index.html//' | sort

# Info commands
info: ## Mostra informacoes do ambiente
	@echo "$(CYAN)Informacoes do ambiente:$(NC)"
	@echo "Ruby: $$(ruby -v)"
	@echo "Bundler: $$(bundle -v)"
	@echo "Jekyll: $$(bundle exec jekyll -v)"

tree: ## Mostra estrutura do projeto
	@echo "$(CYAN)Estrutura do projeto:$(NC)"
	@find . -type f \( -name "*.md" -o -name "*.yml" -o -name "*.json" \) | grep -v vendor | grep -v _site | sort

# Quick shortcuts
s: serve ## Alias para serve
b: build ## Alias para build
c: clean ## Alias para clean
i: install ## Alias para install
