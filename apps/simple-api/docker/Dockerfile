# Multi-stage build for hardened, minimal container
# Stage 1: Build and install dependencies (using Debian to match distroless runtime)
FROM node:20-bookworm-slim AS builder

WORKDIR /build

# Install build dependencies including fontconfig
RUN apt-get update && apt-get install -y --no-install-recommends \
    fontconfig \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy fonts and configure
COPY fonts /usr/share/fonts/
RUN fc-cache -f -v

# Copy package files and install dependencies
COPY package.json ./
RUN npm install --production && npm rebuild sharp

# Copy application source
COPY . ./

# Stage 2: Distroless runtime (hardened, minimal attack surface)
FROM gcr.io/distroless/nodejs20-debian12:nonroot

WORKDIR /app

# Copy fonts and required libraries from builder
COPY --from=builder /usr/share/fonts /usr/share/fonts

# Copy node modules and application
COPY --from=builder --chown=nonroot:nonroot /build/node_modules ./node_modules
COPY --from=builder --chown=nonroot:nonroot /build ./

# Environment setup
ENV NODE_ENV=production
ENV PORT=3000
ENV NUM_WORKERS=1

EXPOSE 3000

# Run as non-root user (already configured in distroless nonroot image)
CMD ["index.js"]
