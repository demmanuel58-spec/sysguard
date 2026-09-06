#!/usr/bin/env bash

send_alert() {
    local level="$1"
    local metric="$2"
    local value="$3"
    local details="$4"

    log "${level}" "${metric} limit reached: ${value}%. Dispatching notification..."

    if [[ "${WEBHOOK_ENABLE:-false}" != "true" || -z "${WEBHOOK_URL:-}" ]]; then
        log "WARNING" "Webhook dispatches disabled or URL unset. Skipping."
        return 0
    fi

    local hostname
    hostname=$(hostname)
    local payload
    payload=$(cat <<EOF
{
  "attachments": [
    {
      "color": "$([[ "${level}" == "CRITICAL" ]] && echo "#FF0000" || echo "#FFA500")",
      "title": "SysGuard Incident Alert: ${metric}",
      "text": "*Host:* \`${hostname}\`\n*Severity:* \`${level}\`\n*Current Value:* \`${value}%\`\n\`\`\`\n${details}\n\`\`\`",
      "ts": $(date +%s)
    }
  ]
}
EOF
)

    local http_code
    http_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H 'Content-type: application/json' --data "${payload}" "${WEBHOOK_URL}")

    if [[ "${http_code}" -eq 200 ]]; then
        log "SUCCESS" "Alert payload successfully received by remote endpoint (HTTP 200)."
    else
        log "ERROR" "Webhook notification failed with HTTP response code ${http_code}."
    fi
}
