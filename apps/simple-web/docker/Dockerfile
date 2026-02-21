# Multi-stage build for hardened, minimal SvelteKit container
# Stage 1: Build the SvelteKit application
FROM node:20-bookworm-slim AS builder

WORKDIR /build

# Copy package files
COPY package.json ./

# Install dependencies with legacy peer deps to handle version conflicts
RUN npm install --legacy-peer-deps

# Copy source code
COPY . ./

# Build the SvelteKit app for production
RUN npm run build

# Prune dev dependencies
RUN npm prune --production --legacy-peer-deps

# Stage 2: Distroless runtime (hardened, minimal attack surface)
FROM gcr.io/distroless/nodejs20-debian12:nonroot

WORKDIR /app

# Copy built application and production dependencies
COPY --from=builder --chown=nonroot:nonroot /build/build ./build
COPY --from=builder --chown=nonroot:nonroot /build/node_modules ./node_modules
COPY --from=builder --chown=nonroot:nonroot /build/package.json ./package.json

# Environment setup
ENV NODE_ENV=production
ENV PORT=3000
ENV ORIGIN=http://web.local

EXPOSE 3000

# Run as non-root user (already configured in distroless nonroot image)
CMD ["build/index.js"]
