# KubeBlocks CLI (kbcli) oh-my-zsh Plugin

A comprehensive oh-my-zsh plugin for KubeBlocks CLI (kbcli), providing aliases, functions, and auto-completion for database cluster management.

## Features

- **Auto-completion**: Uses official `kbcli completion zsh` for accurate command completion
- **Aliases**: Short aliases for common kbcli operations
- **Helper functions**: Advanced functions for cluster, backup, and addon management
- **Database shortcuts**: Quick cluster creation for popular databases
- **Kubectl integration**: Shortcuts for managing KubeBlocks resources via kubectl
- **Smart loading**: Only loads if kbcli is installed

## Installation

1. Place this plugin in your oh-my-zsh custom plugins directory:
```bash
# If using the zsh-custom structure
plugins=(... kbcli)
```

2. Reload your shell:
```bash
source ~/.zshrc
```

## Basic Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `kb` | `kbcli` | Main kbcli command |
| `kbi` | `kbcli install` | Install KubeBlocks |
| `kbu` | `kbcli uninstall` | Uninstall KubeBlocks |
| `kbver` | `kbcli version` | Show version |

## Cluster Management Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `kbc` | `kbcli cluster` | Cluster management |
| `kbcl` | `kbcli cluster list` | List all clusters |
| `kbcc` | `kbcli cluster create` | Create cluster |
| `kbcd` | `kbcli cluster delete` | Delete cluster |
| `kbcs` | `kbcli cluster status` | Show cluster status |
| `kbcsc` | `kbcli cluster scale` | Scale cluster |
| `kbcst` | `kbcli cluster start` | Start cluster |
| `kbcsp` | `kbcli cluster stop` | Stop cluster |
| `kbcr` | `kbcli cluster restart` | Restart cluster |
| `kbcu` | `kbcli cluster update` | Update cluster |
| `kbccon` | `kbcli cluster connect` | Connect to cluster |
| `kbcdesc` | `kbcli cluster describe` | Describe cluster |

## Addon Management Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `kba` | `kbcli addon` | Addon management |
| `kbal` | `kbcli addon list` | List addons |
| `kbai` | `kbcli addon install` | Install addon |
| `kbau` | `kbcli addon uninstall` | Uninstall addon |
| `kbae` | `kbcli addon enable` | Enable addon |
| `kbadis` | `kbcli addon disable` | Disable addon |
| `kbas` | `kbcli addon status` | Addon status |

## Backup & Restore Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `kbb` | `kbcli backup` | Backup management |
| `kbbl` | `kbcli backup list` | List backups |
| `kbbc` | `kbcli backup create` | Create backup |
| `kbbd` | `kbcli backup delete` | Delete backup |
| `kbbr` | `kbcli backup restore` | Restore backup |
| `kbbs` | `kbcli backup status` | Backup status |

## Other Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `kbcd` | `kbcli clusterdefinition` | ClusterDefinition management |
| `kbcdl` | `kbcli clusterdefinition list` | List ClusterDefinitions |
| `kbcv` | `kbcli clusterversion` | ClusterVersion management |
| `kbcvl` | `kbcli clusterversion list` | List ClusterVersions |
| `kbp` | `kbcli playground` | Playground management |
| `kbps` | `kbcli playground start` | Start playground |
| `kbpst` | `kbcli playground stop` | Stop playground |
| `kbpd` | `kbcli playground destroy` | Destroy playground |
| `kbdash` | `kbcli dashboard` | Open dashboard |

## Helper Functions

### Cluster Operations
```bash
# List all clusters
kbcluster

# Get detailed cluster information
kbcluster info <cluster_name>

# View cluster logs
kbcluster logs <cluster_name> [component]

# Connect to cluster
kbcluster connect <cluster_name>
```

### Backup Operations
```bash
# List all backups
kbbackup

# Create backup
kbbackup create <cluster_name> [backup_name]

# Restore from backup
kbbackup restore <backup_name> <new_cluster_name>

# Show backup status
kbbackup status <backup_name>
```

### Addon Operations
```bash
# List all addons
kbaddon

# Show addon information
kbaddon info <addon_name>

# Enable/disable addon
kbaddon enable <addon_name>
kbaddon disable <addon_name>
```

### Quick Database Creation
```bash
# Quick cluster creation for common databases
kbquick <database_type> <cluster_name> [options...]

# Examples:
kbquick mysql my-mysql
kbquick postgresql my-postgres
kbquick redis my-redis
kbquick mongodb my-mongo
kbquick kafka my-kafka
```

### Comprehensive Status
```bash
# Show comprehensive KubeBlocks status
kbstatus
```

### Enhanced Logs Viewing
```bash
# View logs with optional component and follow
kblogs <cluster_name> [component] [--follow]

# Examples:
kblogs my-cluster
kblogs my-cluster mysql
kblogs my-cluster mysql --follow
```

## Kubectl Integration

When kubectl is available, additional shortcuts are provided:

| Alias | Command | Description |
|-------|---------|-------------|
| `kbkget` | `kubectl get clusters,clusterdefinitions,clusterversions` | Get KubeBlocks resources |
| `kbkdesc` | `kubectl describe` | Describe resources |

### Kubectl Functions
```bash
# Get cluster information via kubectl
kbkcluster [cluster_name]
kbkcluster              # List all clusters
kbkcluster my-cluster   # Get cluster YAML
```

## Prerequisites

- [KubeBlocks CLI (kbcli)](https://kubeblocks.io/docs/preview/user_docs/installation/install-with-kbcli/install-kbcli) must be installed
- For kubectl integration: kubectl must be installed and configured
- For JSON parsing in some functions: jq is recommended

## Auto-completion

The plugin uses the official `kbcli completion zsh` command to provide accurate and up-to-date auto-completion for:
- All kbcli commands and subcommands
- Command flags and options
- Resource names and parameters
- The completion is automatically generated and cached for better performance

## Examples

```bash
# Install KubeBlocks
kbi

# Create a MySQL cluster
kbquick mysql my-mysql-cluster

# List all clusters
kbcl

# Get cluster status
kbstatus

# Create backup
kbbackup create my-mysql-cluster

# View cluster logs
kblogs my-mysql-cluster mysql --follow

# Connect to cluster
kbcluster connect my-mysql-cluster

# Enable monitoring addon
kbaddon enable prometheus

# Scale cluster
kbcsc my-mysql-cluster --replicas 3
```

## Database Types Supported

The `kbquick` function supports quick creation of these database types:
- **MySQL** (`mysql`)
- **PostgreSQL** (`postgresql`, `postgres`)
- **Redis** (`redis`)
- **MongoDB** (`mongodb`, `mongo`)
- **Apache Kafka** (`kafka`)

## Advanced Usage

### Playground Management
```bash
# Start local playground
kbps

# Stop playground
kbpst

# Completely destroy playground
kbpd
```

### Dashboard Access
```bash
# Open KubeBlocks dashboard
kbdash
```

### Resource Management
```bash
# List cluster definitions
kbcdl

# List cluster versions
kbcvl
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This plugin is released under the MIT License.