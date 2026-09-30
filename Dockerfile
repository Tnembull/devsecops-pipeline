# ==============================================================================
# Multi-Stage Hardened Production Dockerfile
# Follows CIS benchmarks and OWASP container security standards
# ==============================================================================

# Stage 1: Build & Dependencies
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

COPY app/package*.json ./
RUN npm ci --only=production

# Stage 2: Minimal Distroless / Hardened Alpine Runtime
FROM node:20-alpine AS runner

WORKDIR /usr/src/app

ENV NODE_ENV=production
ENV PORT=8080

# Security: Never run containers as root
USER node

# Copy dependencies and application source from builder
COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node app/ ./

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:8080/healthz || exit 1

CMD ["node", "server.js"]
