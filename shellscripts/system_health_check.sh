#!/bin/bash

# ==============================================================================
# Script Name: system_health_check.sh
# Description: Monitors system health (CPU, Memory, Disk) and service status.
# Author: DevOps Team
# ==============================================================================

# Strict mode: exit on error, undefined vars, and pipe failures
set -euo pipefail

# --- Configuration ---
WARNING_THRESHOLD_CPU=80
WARNING_THRESHOLD_MEM=80
WARNING_THRESHOLD_DISK=80
SERVICES_TO_CHECK=("sshd" "docker") # Example services

# --- Colors for Output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- Functions ---

check_cpu() {
    log_info "Checking CPU Usage..."
    # A simple cross-platform way to get idle CPU and calculate usage
    if command -v mpstat &> /dev/null; then
        local idle_cpu=$(mpstat 1 1 | awk '/Average:/ {print $NF}')
        local cpu_usage=$(echo "100 - $idle_cpu" | bc -l | awk '{printf "%.0f", $1}')
    else
        # Fallback using top if mpstat is not available
        local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
        cpu_usage=$(printf "%.0f" "$cpu_usage")
    fi

    if [ "$cpu_usage" -ge "$WARNING_THRESHOLD_CPU" ]; then
        log_warn "CPU Usage is high: ${cpu_usage}%"
    else
        echo "  CPU Usage: ${cpu_usage}% (Normal)"
    fi
}

check_memory() {
    log_info "Checking Memory Usage..."
    if command -v free &> /dev/null; then
        local mem_total=$(free -m | awk '/^Mem:/{print $2}')
        local mem_used=$(free -m | awk '/^Mem:/{print $3}')
        local mem_usage=$(( 100 * mem_used / mem_total ))
        
        if [ "$mem_usage" -ge "$WARNING_THRESHOLD_MEM" ]; then
            log_warn "Memory Usage is high: ${mem_usage}%"
        else
            echo "  Memory Usage: ${mem_usage}% (Normal)"
        fi
    else
        # macOS fallback for memory check
        local page_size=$(vm_stat | grep "page size of" | awk '{print $8}')
        local free_pages=$(vm_stat | grep "Pages free:" | awk '{print $3}' | sed 's/\.//')
        local inactive_pages=$(vm_stat | grep "Pages inactive:" | awk '{print $3}' | sed 's/\.//')
        local mem_free=$(( (free_pages + inactive_pages) * page_size / 1048576 ))
        local mem_total=$(sysctl -n hw.memsize | awk '{print $0/1048576}')
        local mem_used=$(( mem_total - mem_free ))
        local mem_usage=$(( 100 * mem_used / mem_total ))

        if [ "$mem_usage" -ge "$WARNING_THRESHOLD_MEM" ]; then
            log_warn "Memory Usage is high: ${mem_usage}%"
        else
            echo "  Memory Usage: ${mem_usage}% (Normal)"
        fi
    fi
}

check_disk() {
    log_info "Checking Disk Usage (Root partition)..."
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    
    if [ "$disk_usage" -ge "$WARNING_THRESHOLD_DISK" ]; then
        log_warn "Root Disk Usage is high: ${disk_usage}%"
    else
        echo "  Root Disk Usage: ${disk_usage}% (Normal)"
    fi
}

check_services() {
    log_info "Checking Critical Services..."
    for service in "${SERVICES_TO_CHECK[@]}"; systemctl_available=$(command -v systemctl >/dev/null 2>&1; echo $?); do
        if [ "$systemctl_available" -eq 0 ]; then
            if systemctl is-active --quiet "$service"; then
                 echo "  Service '$service': Running"
            else
                 log_warn "Service '$service' is NOT running!"
            fi
        else
            # Fallback if systemctl is not available (like on macOS)
            if pgrep -x "$service" > /dev/null; then
                 echo "  Process '$service': Running"
            else
                 log_warn "Process '$service' is NOT running!"
            fi
        fi
    done
}

# --- Main Execution ---
echo "========================================"
echo " System Health Check - $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================"

check_cpu
check_memory
check_disk
check_services

echo "========================================"
log_info "Health check completed."
