# Node-RED MCP Server (Home Assistant add-on)

Runs [ziv-daniel/node-red-mcp](https://github.com/ziv-daniel/node-red-mcp) as a
Home Assistant add-on, exposing your Node-RED flows to AI agents (DSH, Claude,
Codex, …) over the Model Context Protocol.

## What it gives you

20 MCP tools for full Node-RED control:

- **Flows** — `get_flows`, `get_flow`, `create_flow`, `update_flow`,
  `enable_flow`, `disable_flow`, `delete_flow`, `validate_flow`,
  `search_flows`, `semantic_search_flows`
- **Context** — `get_context`, `set_context`, `delete_context`
- **Modules** — `search_modules`, `install_module`, `get_installed_modules`
- **Diagnostics** — `get_node_errors`, `get_flow_state`, `get_settings`,
  `get_runtime_info`

## Configuration

| Option | Default | Description |
| --- | --- | --- |
| `nodered_url` | `http://127.0.0.1:46836` | Node-RED admin API URL (see below) |
| `nodered_username` | `""` | Node-RED admin username — only for the front-door fallback |
| `nodered_password` | `""` | Node-RED admin password — only for the front-door fallback |
| `mcp_port` | `3000` | Port the MCP endpoint listens on |
| `mcp_read_only` | `false` | `true` hides all write tools |
| `mcp_username` | `""` | Optional Basic auth username for the MCP endpoint |
| `mcp_password` | `""` | Optional Basic auth password for the MCP endpoint |
| `log_level` | `info` | `trace` / `debug` / `info` / `warn` / `error` |

## Authentication to Node-RED

**Default (no credentials needed):** the hassio-addons Node-RED add-on runs its
real admin API on `127.0.0.1:46836` with `adminAuth = null` — it deliberately
disables Node-RED's own auth and puts the "Home Assistant Authentication" proxy
only on the external front door (port 1880). Because this add-on is
`host_network` on the same box, it reaches `127.0.0.1:46836` directly and skips
that proxy entirely. Leave `nodered_username` / `nodered_password` empty.

**Fallback (front door):** if you point `nodered_url` at `http://localhost:1880`
(or a remote Node-RED), that proxy requires **HA username + password** (not
long-lived tokens). Set `nodered_username` / `nodered_password`, or set
`leave_front_door_open: true` in the Node-RED add-on (not recommended).

> ⚠️ The `46836` port is the Node-RED add-on's internal port. If a future
> add-on version changes it, fall back to `http://localhost:1880` + credentials.

## Security note

Since the MCP endpoint (port `3000`) is exposed on the HA host, it is now the
effective front door for controlling Node-RED. Set `mcp_username` /
`mcp_password` to protect it, and pass the matching `Authorization: Basic …`
header from your agent.

## Connecting an agent

The MCP endpoint is Streamable HTTP at:

```
http://<ha-host>:3000/mcp
```

DSH config (`cordis.patch.yml`):

```yaml
- id: mcp-nodered
  name: '@deepseek-ai/dsh-mcp-client'
  set:
    serverName: nodered
    transport: streamable-http
    url: http://192.168.100.156:3000/mcp
```

## Notes

- `semantic_search_flows` downloads the `Xenova/all-MiniLM-L6-v2` embedding
  model (~90 MB) on first use; it needs outbound internet access.
- The add-on runs on the host network so `localhost:1880` reaches Node-RED
  directly and port `3000` is exposed on the HA host.
