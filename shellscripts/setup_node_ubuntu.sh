#!/bin/bash

# ==============================================================================
# Script Name: setup_node_ubuntu.sh
# Description: Installs NVM (Node Version Manager) and a specified Node.js version on Ubuntu.
# Usage: ./setup_node_ubuntu.sh [node_version]
# Example: ./setup_node_ubuntu.sh 20
# ==============================================================================

set -euo pipefail

# --- Configuration ---
DEFAULT_NODE_VERSION="20"
NODE_VERSION="${1:-$DEFAULT_NODE_VERSION}"
NVM_VERSION="v0.39.7" # Recommended to check for latest version periodically

# --- Output Styling ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# --- OS Check ---
if ! grep -qi "ubuntu" /etc/os-release; then
    log_warn "This script is optimized for Ubuntu. It may not work perfectly on your OS."
fi

# --- Prerequisites ---
log_info "Updating package lists and installing curl..."
sudo apt-get update -y -qq
sudo apt-get install -y curl -qq

# --- NVM Installation ---
log_info "Installing NVM (Node Version Manager) version $NVM_VERSION..."

if [ -d "$HOME/.nvm" ]; then
    log_warn "NVM is already installed in $HOME/.nvm. Skipping installation."
else
    # Run the installation script
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
    log_success "NVM installed."
fi

# --- Load NVM into current shell session ---
log_info "Loading NVM into current session..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if ! command -v nvm &> /dev/null; then
    log_error "Failed to load NVM. Please try restarting your terminal or sourcing your ~/.bashrc."
    exit 1
fi

# --- Node.js Installation ---
log_info "Installing Node.js version $NODE_VERSION..."
nvm install "$NODE_VERSION"
nvm use "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

# --- Verification ---
log_info "Verifying installations..."
NODE_BIN_VERSION=$(node -v)
NPM_BIN_VERSION=$(npm -v)

log_success "Node.js installation complete!"
echo "----------------------------------------"
echo -e "Node Version: ${GREEN}${NODE_BIN_VERSION}${NC}"
echo -e "NPM Version:  ${GREEN}${NPM_BIN_VERSION}${NC}"
echo "----------------------------------------"
echo "Note: If 'node' or 'npm' commands are not found in future sessions,"
echo "ensure these lines are in your ~/.bashrc or ~/.zshrc:"
echo "  export NVM_DIR=\"\$HOME/.nvm\""
echo "  [ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\""
