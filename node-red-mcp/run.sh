#!/usr/bin/env bashio
set -e

# Read add-on options
NODERED_URL="$(bashio::config 'nodered_url')"
NODERED_USERNAME="$(bashio::config 'nodered_username')"
NODERED_PASSWORD="$(bashio::config 'nodered_password')"
MCP_PORT="$(bashio::config 'mcp_port')"
MCP_USERNAME="$(bashio::config 'mcp_username')"
MCP_PASSWORD="$(bashio::config 'mcp_password')"
LOG_LEVEL="$(bashio::config 'log_level')"

if bashio::config.true 'mcp_read_only'; then
    MCP_READ_ONLY=true
else
    MCP_READ_ONLY=false
fi

# Export environment for node-red-mcp
export NODERED_URL
export NODERED_USERNAME
export NODERED_PASSWORD
export MCP_TRANSPORT=http
export MCP_READ_ONLY
export MCP_USERNAME
export MCP_PASSWORD
export HOST=0.0.0.0
export PORT="$MCP_PORT"
export LOG_LEVEL
export NODE_ENV=production

bashio::log.info "Starting Node-RED MCP server on port ${MCP_PORT}"
bashio::log.info "Node-RED URL: ${NODERED_URL}"

cd /opt/node-red-mcp
exec node dist/index.mjs
