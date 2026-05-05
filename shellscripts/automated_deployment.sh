#!/bin/bash

# ==============================================================================
# Script Name: automated_deployment.sh
# Description: Mocks a CI/CD deployment pipeline (pull, build, test, deploy).
# Usage: ./automated_deployment.sh <environment>
# ==============================================================================

set -euo pipefail

# --- Configuration ---
ENVIRONMENTS=("dev" "staging" "production")
APP_NAME="DemoApp"

# --- Output Styling ---
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "\n${BLUE}${BOLD}>>> Step: $1${NC}"
    sleep 1 # Simulate work
}

# --- Validation ---
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <environment>"
    echo "Available environments: ${ENVIRONMENTS[*]}"
    exit 1
fi

TARGET_ENV="$1"

# Check if environment is valid
if [[ ! " ${ENVIRONMENTS[*]} " =~ " ${TARGET_ENV} " ]]; then
    echo "Error: Invalid environment '$TARGET_ENV'."
    echo "Available environments: ${ENVIRONMENTS[*]}"
    exit 1
fi

# --- Mock Deployment Pipeline ---

echo -e "${GREEN}${BOLD}Starting Deployment of $APP_NAME to [$TARGET_ENV]${NC}"

print_step "Pulling latest code from repository..."
echo "git pull origin main"
echo "Fast-forwarding to latest commit: a1b2c3d4"

print_step "Installing dependencies..."
echo "npm install --production=false"
echo "Dependencies installed successfully."

print_step "Running unit tests..."
echo "npm test"
echo "Executed 45 tests."
echo "✅ All tests passed."

print_step "Building application artifacts..."
echo "npm run build"
echo "Creating optimized production build..."
echo "Build artifacts generated in /dist."

print_step "Deploying to $TARGET_ENV server..."
if [ "$TARGET_ENV" == "production" ]; then
    echo "⚠️  Applying production specific configurations..."
    echo "Restarting load balancers..."
fi
echo "rsync -avz ./dist/ user@$TARGET_ENV-server:/var/www/$APP_NAME/"
echo "Restarting application service: systemctl restart $APP_NAME"

print_step "Running post-deployment health checks..."
echo "Checking HTTP status on https://$TARGET_ENV.example.com/health"
echo "HTTP 200 OK"

echo -e "\n${GREEN}${BOLD}🎉 Deployment to $TARGET_ENV completed successfully!${NC}"
