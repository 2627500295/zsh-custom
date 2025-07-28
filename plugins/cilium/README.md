# Cilium oh-my-zsh Plugin

A comprehensive oh-my-zsh plugin for Cilium, providing aliases, functions, and auto-completion for the Cilium CLI.

## Features

- **Auto-completion**: Uses official `cilium completion zsh` for accurate command completion
- **Aliases**: Short aliases for common cilium operations
- **Helper functions**: Advanced functions for monitoring, debugging, and policy management
- **Hubble integration**: Optional Hubble commands and aliases (when Hubble is available)
- **Kubectl integration**: Shortcuts for managing Cilium via kubectl
- **Smart loading**: Only loads if Cilium CLI is installed

## Installation

1. Clone this plugin to your oh-my-zsh custom plugins directory:
```bash
git clone https://github.com/your-repo/cilium-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/cilium
```

2. Add `cilium` to your plugins list in `~/.zshrc`:
```bash
plugins=(... cilium)
```

3. Reload your shell:
```bash
source ~/.zshrc
```

## Basic Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `c` | `cilium` | Main cilium command |
| `cst` | `cilium status` | Show agent status |
| `csta` | `cilium status --all-*` | Show complete status |
| `cep` | `cilium endpoint` | Endpoint management |
| `cepl` | `cilium endpoint list` | List all endpoints |
| `cepg` | `cilium endpoint get` | Get endpoint details |
| `cpol` | `cilium policy` | Policy management |
| `cpolg` | `cilium policy get` | Get policy tree |
| `cpolt` | `cilium policy trace` | Trace policy decision |
| `csvc` | `cilium service` | Service management |
| `csvl` | `cilium service list` | List services |
| `cid` | `cilium identity` | Identity management |
| `cidl` | `cilium identity list` | List identities |
| `cnode` | `cilium node` | Node management |
| `cnodel` | `cilium node list` | List nodes |
| `cmon` | `cilium monitor` | Start monitoring |
| `cconf` | `cilium config` | Configuration management |
| `cver` | `cilium version` | Show version |
| `cdebug` | `cilium debuginfo` | Generate debug info |

## BPF Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `cbpf` | `cilium bpf` | BPF management |
| `cbpfm` | `cilium bpf map` | BPF map management |
| `cbpfml` | `cilium bpf map list` | List BPF maps |
| `cbpfe` | `cilium bpf endpoint` | BPF endpoint maps |
| `cbpflb` | `cilium bpf lb` | BPF load balancer |
| `cbpfpol` | `cilium bpf policy` | BPF policy maps |

## Monitoring Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `cmonall` | `cilium monitor --type <all>` | Monitor all event types |
| `cmondrop` | `cilium monitor --type drop` | Monitor dropped packets |
| `cmontrace` | `cilium monitor --type trace` | Monitor trace events |
| `cmonl7` | `cilium monitor --type l7` | Monitor L7 events |

## Helper Functions

### Policy Tracing
```bash
# Trace policy between identities
cpoltrace <src_identity> <dst_identity> [port] [protocol]
cpoltrace 12345 54321 80 tcp
```

### Endpoint Information
```bash
# Get detailed endpoint info in JSON format
cepinfo <endpoint_id>
cepinfo 1234

# List all endpoints in table format
ceplist
```

### Service Information
```bash
# List all services or get specific service info
csvinfo [service_id]
csvinfo           # List all services
csvinfo 123       # Get service 123 details
```

### Identity Information
```bash
# List all identities or get specific identity info
cidinfo [identity_id]
cidinfo           # List all identities
cidinfo 456       # Get identity 456 details
```

### Comprehensive Status
```bash
# Show comprehensive Cilium status including endpoints, identities, and services
cstatus
```

### Logging
```bash
# Show Cilium agent logs (last 100 lines, follow)
clogs [lines]
clogs 200         # Show last 200 lines

# Show logs from specific node
clogsagent [node_name]
clogsagent worker-1
```

### Network Policy Overview
```bash
# Show all network policies (K8s and Cilium)
cnetpol
```

### Connectivity Testing
```bash
# Run Cilium connectivity test
cconntest
```

## Hubble Integration

When Hubble is available, additional aliases and functions are provided:

| Alias | Command | Description |
|-------|---------|-------------|
| `h` | `hubble` | Main hubble command |
| `hst` | `hubble status` | Hubble status |
| `hobs` | `hubble observe` | Observe flows |
| `hobsf` | `hubble observe --follow` | Follow flows |
| `hlist` | `hubble list` | List available data |

### Hubble Functions
```bash
# Observe flows in specific namespace
hflow [namespace]
hflow kube-system

# Monitor dropped packets
hdrop

# Monitor denied packets
hdenied
```

## Kubectl Integration

When kubectl is available, additional shortcuts are provided:

| Alias | Command | Description |
|-------|---------|-------------|
| `kcilium` | `kubectl -n kube-system` | kubectl in kube-system namespace |
| `kcdaemon` | `kubectl -n kube-system get daemonset cilium` | Get Cilium daemonset |
| `kcpods` | `kubectl -n kube-system get pods -l k8s-app=cilium` | Get Cilium pods |
| `kclogs` | `kubectl -n kube-system logs -l k8s-app=cilium --tail=100` | Get Cilium logs |

### Kubectl Functions
```bash
# Execute command in Cilium pod
kcexec <command>
kcexec cilium status
```

## Prerequisites

- [Cilium CLI](https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/#install-the-cilium-cli) must be installed
- For kubectl integration: kubectl must be installed and configured
- For Hubble integration: Hubble CLI must be installed
- For JSON parsing in some functions: jq must be installed

## Auto-completion

The plugin uses the official `cilium completion zsh` command to provide accurate and up-to-date auto-completion for:
- All cilium commands and subcommands
- Command flags and options
- Output formats and parameters
- The completion is automatically generated and cached for better performance

## Examples

```bash
# Quick status check
cst

# List all endpoints
cepl

# Monitor dropped packets
cmondrop

# Trace policy between two identities
cpoltrace 12345 54321 443 tcp

# Get comprehensive status
cstatus

# Watch Cilium logs
clogs

# Get endpoint details
cepinfo 1234
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This plugin is released under the MIT License.