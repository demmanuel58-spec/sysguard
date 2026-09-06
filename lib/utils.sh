#!/usr/bin/env bash

# Terminal color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

acquire_lock() {
    local lockfile="/tmp/sysguard.lock"
    if ! exec 8>"${lockfile}"; then
        echo "Failed to open lockfile ${lockfile}" >&2
        exit 1
    fi
    if ! flock -n 8; then
        echo "SysGuard is already running. Exiting."
        exit 0
    fi
}

log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    local formatted_entry="[${timestamp}] [${level}] ${message}"

    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "${formatted_entry}" >> "${LOG_FILE}" 2>/dev/null || true
    fi

    if [[ "${ENABLE_COLOR_OUTPUT:-true}" == "true" ]]; then
        case "${level}" in
            "CRITICAL") echo -e "${RED}${formatted_entry}${NC}" ;;
            "WARNING")  echo -e "${YELLOW}${formatted_entry}${NC}" ;;
            "SUCCESS")  echo -e "${GREEN}${formatted_entry}${NC}" ;;
            "INFO")     echo -e "${BLUE}${formatted_entry}${NC}" ;;
            *)          echo "${formatted_entry}" ;;
        esac
    else
        echo "${formatted_entry}"
    fi
}
