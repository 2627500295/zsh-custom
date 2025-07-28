# KubeBlocks CLI (kbcli) oh-my-zsh plugin

# Return if kbcli is not installed
if (( ! $+commands[kbcli] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kbcli" ]]; then
  kbcli completion zsh | tee "$ZSH_CACHE_DIR/completions/_kbcli" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_kbcli"
else
  source "$ZSH_CACHE_DIR/completions/_kbcli"
  kbcli completion zsh | tee "$ZSH_CACHE_DIR/completions/_kbcli" >/dev/null &|
fi

# Basic aliases
alias kb='kbcli'
alias kbi='kbcli install'
alias kbu='kbcli uninstall'
alias kbver='kbcli version'

# Cluster management aliases
alias kbc='kbcli cluster'
alias kbcl='kbcli cluster list'
alias kbcc='kbcli cluster create'
alias kbcd='kbcli cluster delete'
alias kbcs='kbcli cluster status'
alias kbcsc='kbcli cluster scale'
alias kbcst='kbcli cluster start'
alias kbcsp='kbcli cluster stop'
alias kbcr='kbcli cluster restart'
alias kbcu='kbcli cluster update'
alias kbccon='kbcli cluster connect'
alias kbcdesc='kbcli cluster describe'

# Addon management aliases
alias kba='kbcli addon'
alias kbal='kbcli addon list'
alias kbai='kbcli addon install'
alias kbau='kbcli addon uninstall'
alias kbae='kbcli addon enable'
alias kbadis='kbcli addon disable'
alias kbas='kbcli addon status'

# Backup and restore aliases
alias kbb='kbcli backup'
alias kbbl='kbcli backup list'
alias kbbc='kbcli backup create'
alias kbbd='kbcli backup delete'
alias kbbr='kbcli backup restore'
alias kbbs='kbcli backup status'

# ClusterDefinition aliases
alias kbcd='kbcli clusterdefinition'
alias kbcdl='kbcli clusterdefinition list'

# ClusterVersion aliases
alias kbcv='kbcli clusterversion'
alias kbcvl='kbcli clusterversion list'

# Options aliases
alias kbo='kbcli options'

# Playground aliases
alias kbp='kbcli playground'
alias kbps='kbcli playground start'
alias kbpst='kbcli playground stop'
alias kbpd='kbcli playground destroy'

# Alert aliases
alias kbalt='kbcli alert'
alias kbaltl='kbcli alert list'

# Dashboard aliases
alias kbdash='kbcli dashboard'

# DataProtection aliases
alias kbdp='kbcli dataprotection'

# Fault injection aliases
alias kbf='kbcli fault'

# Helper functions

# Cluster operations
function kbcluster() {
    if [[ $# -eq 0 ]]; then
        echo "=== KubeBlocks Clusters ==="
        kbcli cluster list
        return
    fi
    
    case $1 in
        "info"|"describe")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbcluster info <cluster_name>"
                return 1
            fi
            kbcli cluster describe $2
            ;;
        "logs")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbcluster logs <cluster_name> [component]"
                return 1
            fi
            local component=${3:-""}
            if [[ -n $component ]]; then
                kbcli cluster logs $2 --component $component
            else
                kbcli cluster logs $2
            fi
            ;;
        "connect")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbcluster connect <cluster_name>"
                return 1
            fi
            kbcli cluster connect $2
            ;;
        *)
            echo "Usage: kbcluster [info|logs|connect] <cluster_name> [args...]"
            echo "  info     - Show cluster information"
            echo "  logs     - Show cluster logs"
            echo "  connect  - Connect to cluster"
            echo "  (no args) - List all clusters"
            ;;
    esac
}

# Backup operations
function kbbackup() {
    if [[ $# -eq 0 ]]; then
        echo "=== KubeBlocks Backups ==="
        kbcli backup list
        return
    fi
    
    case $1 in
        "create")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbbackup create <cluster_name> [backup_name]"
                return 1
            fi
            local backup_name=${3:-"backup-$(date +%Y%m%d-%H%M%S)"}
            kbcli backup create $backup_name --cluster $2
            ;;
        "restore")
            if [[ $# -lt 3 ]]; then
                echo "Usage: kbbackup restore <backup_name> <new_cluster_name>"
                return 1
            fi
            kbcli backup restore $3 --backup $2
            ;;
        "status")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbbackup status <backup_name>"
                return 1
            fi
            kbcli backup describe $2
            ;;
        *)
            echo "Usage: kbbackup [create|restore|status] [args...]"
            echo "  create   - Create backup"
            echo "  restore  - Restore from backup"
            echo "  status   - Show backup status"
            echo "  (no args) - List all backups"
            ;;
    esac
}

# Addon operations
function kbaddon() {
    if [[ $# -eq 0 ]]; then
        echo "=== KubeBlocks Addons ==="
        kbcli addon list
        return
    fi
    
    case $1 in
        "info")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbaddon info <addon_name>"
                return 1
            fi
            kbcli addon describe $2
            ;;
        "enable")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbaddon enable <addon_name>"
                return 1
            fi
            kbcli addon enable $2
            ;;
        "disable")
            if [[ $# -lt 2 ]]; then
                echo "Usage: kbaddon disable <addon_name>"
                return 1
            fi
            kbcli addon disable $2
            ;;
        *)
            echo "Usage: kbaddon [info|enable|disable] <addon_name>"
            echo "  info     - Show addon information"
            echo "  enable   - Enable addon"
            echo "  disable  - Disable addon"
            echo "  (no args) - List all addons"
            ;;
    esac
}

# Status overview
function kbstatus() {
    echo "=== KubeBlocks Overview ==="
    
    echo -e "\n--- KubeBlocks Version ---"
    kbcli version
    
    echo -e "\n--- Clusters ---"
    kbcli cluster list
    
    echo -e "\n--- Addons ---"
    kbcli addon list
    
    echo -e "\n--- Recent Backups ---"
    kbcli backup list 2>/dev/null | head -10 || echo "No backups found"
}

# Quick cluster creation with common databases
function kbquick() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: kbquick <database_type> <cluster_name> [options...]"
        echo "Supported types: mysql, postgresql, redis, mongodb, kafka"
        echo "Example: kbquick mysql my-mysql-cluster"
        return 1
    fi
    
    local db_type=$1
    local cluster_name=$2
    shift 2
    
    case $db_type in
        "mysql")
            kbcli cluster create mysql $cluster_name "$@"
            ;;
        "postgresql"|"postgres")
            kbcli cluster create postgresql $cluster_name "$@"
            ;;
        "redis")
            kbcli cluster create redis $cluster_name "$@"
            ;;
        "mongodb"|"mongo")
            kbcli cluster create mongodb $cluster_name "$@"
            ;;
        "kafka")
            kbcli cluster create kafka $cluster_name "$@"
            ;;
        *)
            echo "Unsupported database type: $db_type"
            echo "Supported types: mysql, postgresql, redis, mongodb, kafka"
            return 1
            ;;
    esac
}

# Logs helper
function kblogs() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: kblogs <cluster_name> [component] [--follow]"
        echo "Example: kblogs my-cluster mysql --follow"
        return 1
    fi
    
    local cluster_name=$1
    local component=""
    local follow_flag=""
    
    shift
    while [[ $# -gt 0 ]]; do
        case $1 in
            --follow|-f)
                follow_flag="--follow"
                ;;
            *)
                if [[ -z $component ]]; then
                    component="--component $1"
                fi
                ;;
        esac
        shift
    done
    
    kbcli cluster logs $cluster_name $component $follow_flag
}

# Kubectl integration for KubeBlocks resources
if command -v kubectl &> /dev/null; then
    alias kbkget='kubectl get clusters,clusterdefinitions,clusterversions'
    alias kbkdesc='kubectl describe'
    
    function kbkcluster() {
        if [[ $# -eq 0 ]]; then
            kubectl get clusters -o wide
        else
            kubectl get cluster $1 -o yaml
        fi
    }
fi