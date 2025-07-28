# Cilium oh-my-zsh plugin

# Return if cilium is not installed
if (( ! $+commands[cilium] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_cilium" ]]; then
  cilium completion zsh | tee "$ZSH_CACHE_DIR/completions/_cilium" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_cilium"
else
  source "$ZSH_CACHE_DIR/completions/_cilium"
  cilium completion zsh | tee "$ZSH_CACHE_DIR/completions/_cilium" >/dev/null &|
fi

# Basic aliases
alias c='cilium'
alias cst='cilium status'
alias csta='cilium status --all-addresses --all-controllers --all-health --all-nodes'
alias cep='cilium endpoint'
alias cepl='cilium endpoint list'
alias cepg='cilium endpoint get'
alias cpol='cilium policy'
alias cpolg='cilium policy get'
alias cpolt='cilium policy trace'
alias csvc='cilium service'
alias csvl='cilium service list'
alias cid='cilium identity'
alias cidl='cilium identity list'
alias cnode='cilium node'
alias cnodel='cilium node list'
alias cmon='cilium monitor'
alias cconf='cilium config'
alias cver='cilium version'
alias cdebug='cilium debuginfo'

# BPF related aliases
alias cbpf='cilium bpf'
alias cbpfm='cilium bpf map'
alias cbpfml='cilium bpf map list'
alias cbpfe='cilium bpf endpoint'
alias cbpflb='cilium bpf lb'
alias cbpfpol='cilium bpf policy'

# Monitoring aliases
alias cmonall='cilium monitor --type drop --type capture --type trace --type l7'
alias cmondrop='cilium monitor --type drop'
alias cmontrace='cilium monitor --type trace'
alias cmonl7='cilium monitor --type l7'

# Policy tracing helpers
function cpoltrace() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: cpoltrace <src_identity> <dst_identity> [port] [protocol]"
        echo "Example: cpoltrace 12345 54321 80 tcp"
        return 1
    fi
    
    local src_id=$1
    local dst_id=$2
    local port=${3:-80}
    local protocol=${4:-tcp}
    
    cilium policy trace --src-identity $src_id --dst-identity $dst_id --dport $port --protocol $protocol
}

# Endpoint helpers
function cepinfo() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: cepinfo <endpoint_id>"
        return 1
    fi
    cilium endpoint get $1 -o json | jq '.'
}

function ceplist() {
    cilium endpoint list -o table
}

# Service helpers
function csvinfo() {
    if [[ $# -eq 0 ]]; then
        cilium service list -o table
    else
        cilium service get $1 -o json | jq '.'
    fi
}

# Identity helpers
function cidinfo() {
    if [[ $# -eq 0 ]]; then
        cilium identity list -o table
    else
        cilium identity get $1 -o json | jq '.'
    fi
}

# Node helpers
function cnodeinfo() {
    cilium node list -o table
}

# Status helpers
function cstatus() {
    echo "=== Cilium Status ==="
    cilium status
    
    echo -e "\n=== Node Status ==="
    cilium node list
    
    echo -e "\n=== Endpoint Count ==="
    local ep_count=$(cilium endpoint list -o json | jq '. | length')
    echo "Total endpoints: $ep_count"
    
    echo -e "\n=== Identity Count ==="
    local id_count=$(cilium identity list -o json | jq '. | length')
    echo "Total identities: $id_count"
    
    echo -e "\n=== Service Count ==="
    local svc_count=$(cilium service list -o json 2>/dev/null | jq '. | length' 2>/dev/null || echo "N/A")
    echo "Total services: $svc_count"
}

# Logs and debugging
function clogs() {
    local lines=${1:-100}
    kubectl logs -n kube-system -l k8s-app=cilium --tail=$lines -f
}

function clogsagent() {
    local node=${1:-$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')}
    kubectl logs -n kube-system daemonset/cilium -c cilium-agent --tail=100 -f --field-selector spec.nodeName=$node
}

# Network policy helpers
function cnetpol() {
    echo "=== Kubernetes Network Policies ==="
    kubectl get networkpolicies --all-namespaces -o wide
    
    echo -e "\n=== Cilium Network Policies ==="
    kubectl get ciliumnetworkpolicies --all-namespaces -o wide 2>/dev/null || echo "No Cilium Network Policies found"
    
    echo -e "\n=== Cilium Clusterwide Network Policies ==="
    kubectl get ciliumclusterwidenetworkpolicies -o wide 2>/dev/null || echo "No Cilium Clusterwide Network Policies found"
}

# Connectivity testing
function cconntest() {
    echo "Starting Cilium connectivity test..."
    cilium connectivity test
}

# Hubble integration (if available)
if command -v hubble &> /dev/null; then
    alias h='hubble'
    alias hst='hubble status'
    alias hobs='hubble observe'
    alias hobsf='hubble observe --follow'
    alias hlist='hubble list'
    
    function hflow() {
        local namespace=${1:-default}
        hubble observe --namespace $namespace --follow
    }
    
    function hdrop() {
        hubble observe --verdict DROPPED --follow
    }
    
    function hdenied() {
        hubble observe --verdict DENIED --follow
    }
fi

# Kubectl Cilium shortcuts
if command -v kubectl &> /dev/null; then
    alias kcilium='kubectl -n kube-system'
    alias kcdaemon='kubectl -n kube-system get daemonset cilium'
    alias kcpods='kubectl -n kube-system get pods -l k8s-app=cilium'
    alias kclogs='kubectl -n kube-system logs -l k8s-app=cilium --tail=100'
    
    function kcexec() {
        local pod_name=$(kubectl -n kube-system get pods -l k8s-app=cilium -o jsonpath='{.items[0].metadata.name}')
        kubectl -n kube-system exec -it $pod_name -- $@
    }
fi