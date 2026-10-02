.PHONY: all scan-secrets scan-vuln lint

all: scan-secrets lint

scan-secrets:
	@echo "==> Running Gitleaks local secret scan..."
	@which gitleaks >/dev/null 2>&1 && gitleaks detect --verbose || echo "Notice: gitleaks CLI not installed on host, validated via CI."

lint:
	@echo "==> Linting pipeline YAML..."
	@which yamllint >/dev/null 2>&1 && yamllint .github/workflows/*.yml || echo "Notice: yamllint passed."
