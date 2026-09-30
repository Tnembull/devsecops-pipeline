# Automated DevSecOps Security Pipeline

Shift-left automated security validation pipeline integrating Secret Detection (Gitleaks), Software Composition Analysis (NPM Audit), Container Image Vulnerability Scanning (Aqua Trivy), and Dockerfile Static Analysis (Hadolint).

---

## 🎯 The Shift-Left Security Concept
Security testing is often performed as an afterthought right before production release. 

This repository implements a strict **Shift-Left Security Quality Gate**, where every commit and pull request must pass four automated security checkpoints before being permitted to deploy:

```text
[ Git Commit / PR ]
         |
         +---> 1. Gitleaks (Hardcoded secrets, API tokens, Private keys)
         |
         +---> 2. NPM Audit (SCA / Third-party vulnerable dependencies)
         |
         +---> 3. Hadolint (Container image misconfigurations / Root execution)
         |
         v
 [ Docker Build ]
         |
         +---> 4. Aqua Trivy (OS packages & Application library CVE scanner)
         |
         v
[ Verified Secure Artifact Ready for Production ]
```

---

## 🚀 Key Security Implementations

### 1. Secret Leak Prevention (Gitleaks)
- Scans full commit history for high-entropy strings, private keys, cloud tokens, and passwords.
- Blocks commits from entering the main branch if secrets are detected.

### 2. Multi-Stage Container Hardening (`Dockerfile`)
- **Non-Root Execution**: Runs strictly as unprivileged user `node` (`USER node`).
- **Minimal Attack Surface**: Uses multi-stage builds on top of `alpine` to strip out development dependencies and compilers.
- **Embedded Health Probe**: Built-in HTTP health check endpoint (`/healthz`).

### 3. Container Image CVE Scanning (Aqua Security Trivy)
- Inspects container layers for known CVE vulnerabilities in base Alpine OS packages and NPM libraries.
- Filters out unfixed CVEs to eliminate false-positive operational noise.

### 4. Application Hardening
- Implements OWASP recommended HTTP security headers using `helmet`.
- Payload body size limiting to prevent Denial of Service (DoS) memory exhaustion attacks.

---

## 📁 Repository Structure

```text
├── Dockerfile                         # Hardened multi-stage non-root container definition
├── app/
│   ├── server.js                      # Hardened HTTP microservice with health probes
│   └── package.json                   # Application dependencies
└── .github/workflows/
    └── devsecops.yml                  # 4-stage automated security CI/CD pipeline
```

---

## 🛡️ Security & Zero Leak Posture
- All sensitive credentials and configuration files are excluded via `.gitignore`.
- Automated security scans are run within isolated GitHub Actions runners.

---
**Author**: Muhammad Nur Ashiddiqi  
**Portfolio**: [muhammadnurashiddiqi.my.id](https://muhammadnurashiddiqi.my.id)
