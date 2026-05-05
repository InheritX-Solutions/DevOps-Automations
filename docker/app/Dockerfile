# ==============================================================================
# Multi-stage Dockerfile demonstrating production best practices
# ==============================================================================

# --- Stage 1: Build Environment ---
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Copy package files first to leverage Docker layer caching for dependencies
COPY package*.json ./

# Install ALL dependencies (including devDependencies needed for build steps if any)
RUN npm ci

# Copy the rest of the application code
COPY . .

# (Optional) If there was a build step like TypeScript compilation, it would go here
# RUN npm run build

# --- Stage 2: Production Environment ---
FROM node:20-alpine AS production

# Set Node environment to production
ENV NODE_ENV=production

# Install curl for healthchecks (alpine doesn't have it by default)
RUN apk add --no-cache curl

# Create an app directory and assign ownership to the unprivileged 'node' user
WORKDIR /usr/src/app
RUN chown node:node /usr/src/app

# Switch to the non-root user for better security
USER node

# Copy package files
COPY --chown=node:node package*.json ./

# Install ONLY production dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy the application code from the builder stage
COPY --chown=node:node --from=builder /usr/src/app/server.js ./

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "server.js"]
