# Qiniu qshell oh-my-zsh plugin

# Return if qshell is not installed
if (( ! $+commands[qshell] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_qshell" ]]; then
  qshell completion zsh | tee "$ZSH_CACHE_DIR/completions/_qshell" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_qshell"
else
  source "$ZSH_CACHE_DIR/completions/_qshell"
  qshell completion zsh | tee "$ZSH_CACHE_DIR/completions/_qshell" >/dev/null &|
fi

# Basic aliases
alias qs='qshell'
alias qsv='qshell version'
alias qsh='qshell help'

# Account management aliases
alias qsa='qshell account'
alias qsal='qshell account list'
alias qsadd='qshell account add'
alias qsarm='qshell account remove'
alias qsas='qshell account switch'
alias qsai='qshell account info'

# Bucket management aliases
alias qsb='qshell bucket'
alias qsbl='qshell bucket list'
alias qsbi='qshell bucket info'
alias qsbc='qshell bucket create'
alias qsbd='qshell bucket delete'

# Object/File operations aliases
alias qsl='qshell listbucket'
alias qsls='qshell listbucket'
alias qsu='qshell rput'
alias qsup='qshell rput'
alias qsd='qshell get'
alias qsdl='qshell get'
alias qsrm='qshell delete'
alias qsdel='qshell delete'
alias qscp='qshell copy'
alias qsmv='qshell move'
alias qsren='qshell rename'

# Batch operations aliases
alias qsbu='qshell qupload'
alias qsbd='qshell qdownload'
alias qsbdel='qshell batchdelete'
alias qsbcp='qshell batchcopy'
alias qsbmv='qshell batchmove'
alias qsbren='qshell batchrename'

# Sync operations aliases
alias qsync='qshell qupload2'
alias qsdown='qshell qdownload2'

# CDN and domain aliases
alias qscdn='qshell cdnrefresh'
alias qspfop='qshell pfop'
alias qspfops='qshell pfopstatus'

# Utility aliases
alias qsstat='qshell stat'
alias qsdu='qshell bucketinfo'
alias qsinfo='qshell bucketinfo'

# Helper functions

# Account management
function qsaccount() {
    if [[ $# -eq 0 ]]; then
        echo "=== Qiniu Accounts ==="
        qshell account list
        return
    fi
    
    case $1 in
        "add")
            if [[ $# -lt 4 ]]; then
                echo "Usage: qsaccount add <name> <access_key> <secret_key>"
                return 1
            fi
            qshell account add $2 $3 $4
            ;;
        "switch"|"use")
            if [[ $# -lt 2 ]]; then
                echo "Usage: qsaccount switch <name>"
                return 1
            fi
            qshell account switch $2
            ;;
        "remove"|"rm")
            if [[ $# -lt 2 ]]; then
                echo "Usage: qsaccount remove <name>"
                return 1
            fi
            qshell account remove $2
            ;;
        "info"|"current")
            qshell account info
            ;;
        *)
            echo "Usage: qsaccount [add|switch|remove|info]"
            echo "  add     - Add new account"
            echo "  switch  - Switch to account"
            echo "  remove  - Remove account"
            echo "  info    - Show current account"
            echo "  (no args) - List all accounts"
            ;;
    esac
}

# Bucket operations
function qsbucket() {
    if [[ $# -eq 0 ]]; then
        echo "=== Qiniu Buckets ==="
        qshell bucket list
        return
    fi
    
    case $1 in
        "info"|"describe")
            if [[ $# -lt 2 ]]; then
                echo "Usage: qsbucket info <bucket_name>"
                return 1
            fi
            qshell bucket info $2
            ;;
        "create")
            if [[ $# -lt 3 ]]; then
                echo "Usage: qsbucket create <bucket_name> <region>"
                echo "Regions: z0(华东), z1(华北), z2(华南), na0(北美), as0(东南亚)"
                return 1
            fi
            qshell bucket create $2 $3
            ;;
        "delete"|"rm")
            if [[ $# -lt 2 ]]; then
                echo "Usage: qsbucket delete <bucket_name>"
                return 1
            fi
            echo "Are you sure you want to delete bucket '$2'? (y/N)"
            read -r response
            if [[ $response == "y" || $response == "Y" ]]; then
                qshell bucket delete $2
            else
                echo "Cancelled"
            fi
            ;;
        *)
            echo "Usage: qsbucket [info|create|delete]"
            echo "  info    - Show bucket information"
            echo "  create  - Create new bucket"
            echo "  delete  - Delete bucket"
            echo "  (no args) - List all buckets"
            ;;
    esac
}

# Quick file upload
function qsupload() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: qsupload <local_file> <bucket:key> [overwrite]"
        echo "Example: qsupload ./file.txt mybucket:path/file.txt"
        echo "         qsupload ./file.txt mybucket:path/file.txt true"
        return 1
    fi
    
    local local_file=$1
    local bucket_key=$2
    local overwrite=${3:-false}
    
    if [[ ! -f $local_file ]]; then
        echo "Error: File '$local_file' not found"
        return 1
    fi
    
    qshell rput $bucket_key $local_file --overwrite=$overwrite
}

# Quick file download
function qsdownload() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: qsdownload <bucket> <key> [local_file]"
        echo "Example: qsdownload mybucket path/file.txt ./downloaded_file.txt"
        return 1
    fi
    
    local bucket=$1
    local key=$2
    local local_file=${3:-$(basename $key)}
    
    qshell get $bucket $key $local_file
}

# List bucket contents with pagination
function qslist() {
    local bucket=${1:-""}
    local prefix=${2:-""}
    local limit=${3:-100}
    
    if [[ -z $bucket ]]; then
        echo "Usage: qslist <bucket> [prefix] [limit]"
        echo "Example: qslist mybucket images/ 50"
        return 1
    fi
    
    if [[ -n $prefix ]]; then
        qshell listbucket $bucket $prefix $limit
    else
        qshell listbucket $bucket "" $limit
    fi
}

# Batch upload with config file
function qsbatchup() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: qsbatchup <config_file>"
        echo "Config file should contain upload configuration"
        return 1
    fi
    
    local config_file=$1
    if [[ ! -f $config_file ]]; then
        echo "Error: Config file '$config_file' not found"
        return 1
    fi
    
    qshell qupload $config_file
}

# Generate upload config template
function qsconfig() {
    local bucket=${1:-"mybucket"}
    local src_dir=${2:-"./"}
    local config_file=${3:-"upload.conf"}
    
    cat > $config_file << EOF
{
    "src_dir": "$src_dir",
    "bucket": "$bucket",
    "key_prefix": "",
    "overwrite": false,
    "check_exists": true,
    "check_hash": true,
    "check_size": true,
    "ignore_dir": false,
    "up_host": "",
    "bind_up_ip": "",
    "bind_nic": "",
    "resettable_api": true,
    "thread_count": 5
}
EOF
    
    echo "Upload config template created: $config_file"
    echo "Please edit the config file as needed"
}

# File operations with confirmation
function qsdelete() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: qsdelete <bucket> <key>"
        return 1
    fi
    
    local bucket=$1
    local key=$2
    
    echo "Are you sure you want to delete '$key' from bucket '$bucket'? (y/N)"
    read -r response
    if [[ $response == "y" || $response == "Y" ]]; then
        qshell delete $bucket $key
    else
        echo "Cancelled"
    fi
}

# Copy file with confirmation
function qscopy() {
    if [[ $# -lt 4 ]]; then
        echo "Usage: qscopy <src_bucket> <src_key> <dest_bucket> <dest_key>"
        return 1
    fi
    
    local src_bucket=$1
    local src_key=$2
    local dest_bucket=$3
    local dest_key=$4
    
    echo "Copy '$src_bucket:$src_key' to '$dest_bucket:$dest_key'? (y/N)"
    read -r response
    if [[ $response == "y" || $response == "Y" ]]; then
        qshell copy $src_bucket $src_key $dest_bucket $dest_key
    else
        echo "Cancelled"
    fi
}

# Status overview
function qsstatus() {
    echo "=== Qshell Status ==="
    
    echo -e "\n--- Current Account ---"
    qshell account info
    
    echo -e "\n--- Available Buckets ---"
    qshell bucket list
}

# CDN refresh helper
function qsrefresh() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: qsrefresh <url1> [url2] [url3] ..."
        echo "Example: qsrefresh https://example.com/file1.jpg https://example.com/file2.jpg"
        return 1
    fi
    
    # Create temporary file with URLs
    local temp_file=$(mktemp)
    for url in "$@"; do
        echo $url >> $temp_file
    done
    
    echo "Refreshing ${#@} URLs..."
    qshell cdnrefresh $temp_file
    rm $temp_file
}

# File statistics
function qsfilestat() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: qsfilestat <bucket> <key>"
        return 1
    fi
    
    local bucket=$1
    local key=$2
    
    qshell stat $bucket $key
}

# Quick sync directory
function qssync() {
    if [[ $# -lt 2 ]]; then
        echo "Usage: qssync <local_dir> <bucket> [key_prefix]"
        echo "Example: qssync ./images mybucket images/"
        return 1
    fi
    
    local local_dir=$1
    local bucket=$2
    local key_prefix=${3:-""}
    
    if [[ ! -d $local_dir ]]; then
        echo "Error: Directory '$local_dir' not found"
        return 1
    fi
    
    # Create temporary config
    local temp_config=$(mktemp)
    cat > $temp_config << EOF
{
    "src_dir": "$local_dir",
    "bucket": "$bucket",
    "key_prefix": "$key_prefix",
    "overwrite": false,
    "check_exists": true,
    "check_hash": true,
    "check_size": true,
    "ignore_dir": false,
    "thread_count": 5
}
EOF
    
    echo "Syncing '$local_dir' to bucket '$bucket' with prefix '$key_prefix'..."
    qshell qupload2 $temp_config
    rm $temp_config
}