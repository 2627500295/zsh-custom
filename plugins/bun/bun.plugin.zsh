# Bun oh-my-zsh plugin

# Return if bun is not installed
if (( ! $+commands[bun] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_bun" ]]; then
  bun completion zsh | tee "$ZSH_CACHE_DIR/completions/_bun" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_bun"
else
  source "$ZSH_CACHE_DIR/completions/_bun"
  bun completion zsh | tee "$ZSH_CACHE_DIR/completions/_bun" >/dev/null &|
fi

# Basic aliases
alias b='bun'
alias bi='bun install'
alias ba='bun add'
alias bad='bun add --dev'
alias br='bun remove'
alias bu='bun update'
alias bx='bun x'
alias bd='bun dev'
alias bb='bun build'
alias bt='bun test'
alias bw='bun run --watch'
alias bcreate='bun create'
alias bpm='bun pm'

# Package management aliases
alias bpml='bun pm ls'
alias bpmla='bun pm ls --all'
alias bpmc='bun pm cache'
alias bpmcl='bun pm cache clean'

# Run aliases
alias bs='bun start'
alias brun='bun run'

# Development aliases
alias binit='bun init'
alias blink='bun link'
alias bunlink='bun unlink'

# Helper functions
function bhelp() {
    echo "Bun Plugin Commands:"
    echo ""
    echo "Basic Commands:"
    echo "  b          - bun"
    echo "  bi         - bun install"
    echo "  ba         - bun add"
    echo "  bad        - bun add --dev"
    echo "  br         - bun remove"
    echo "  bu         - bun update"
    echo "  bx         - bun x"
    echo ""
    echo "Development:"
    echo "  bd         - bun dev"
    echo "  bb         - bun build"
    echo "  bt         - bun test"
    echo "  bw         - bun run --watch"
    echo "  bs         - bun start"
    echo "  brun       - bun run"
    echo ""
    echo "Project Management:"
    echo "  binit      - bun init"
    echo "  bcreate    - bun create"
    echo "  blink      - bun link"
    echo "  bunlink    - bun unlink"
    echo ""
    echo "Package Manager:"
    echo "  bpm        - bun pm"
    echo "  bpml       - bun pm ls"
    echo "  bpmla      - bun pm ls --all"
    echo "  bpmc       - bun pm cache"
    echo "  bpmcl      - bun pm cache clean"
    echo ""
    echo "Helper Functions:"
    echo "  binfo      - Show project and bun info"
    echo "  bdev       - Start development with optional script"
    echo "  badd       - Add packages with prompts"
    echo "  btest      - Run tests with optional filters"
}

function binfo() {
    echo "=== Bun Version ==="
    bun --version
    
    echo -e "\n=== Project Info ==="
    if [[ -f "package.json" ]]; then
        local name=$(cat package.json | grep '"name"' | head -1 | cut -d'"' -f4)
        local version=$(cat package.json | grep '"version"' | head -1 | cut -d'"' -f4)
        echo "Project: $name ($version)"
    else
        echo "No package.json found"
    fi
    
    echo -e "\n=== Dependencies ==="
    if [[ -f "package.json" ]]; then
        bun pm ls 2>/dev/null || echo "No dependencies listed"
    fi
    
    echo -e "\n=== Scripts ==="
    if [[ -f "package.json" ]]; then
        local scripts=$(cat package.json | grep -A 20 '"scripts"' | grep '":' | sed 's/.*"\([^"]*\)".*/  \1/')
        if [[ -n "$scripts" ]]; then
            echo "$scripts"
        else
            echo "No scripts defined"
        fi
    fi
}

function bdev() {
    local script=${1:-dev}
    echo "Starting development server with: bun run $script"
    bun run $script
}

function badd() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: badd <package1> [package2] ... [--dev]"
        echo "Example: badd express typescript --dev"
        return 1
    fi
    
    local dev_flag=""
    local packages=()
    
    for arg in "$@"; do
        if [[ "$arg" == "--dev" ]]; then
            dev_flag="--dev"
        else
            packages+=("$arg")
        fi
    done
    
    if [[ ${#packages[@]} -eq 0 ]]; then
        echo "No packages specified"
        return 1
    fi
    
    echo "Adding packages: ${packages[@]}"
    if [[ -n "$dev_flag" ]]; then
        echo "As dev dependencies"
        bun add --dev "${packages[@]}"
    else
        bun add "${packages[@]}"
    fi
}

function btest() {
    if [[ $# -eq 0 ]]; then
        echo "Running all tests..."
        bun test
    else
        echo "Running tests with filter: $1"
        bun test --grep "$1"
    fi
}

function bwatch() {
    local script=${1:-dev}
    echo "Watching and running: bun run $script"
    bun run --watch $script
}

function bclean() {
    echo "Cleaning bun cache and node_modules..."
    
    if [[ -d "node_modules" ]]; then
        echo "Removing node_modules..."
        rm -rf node_modules
    fi
    
    echo "Cleaning bun cache..."
    bun pm cache clean
    
    echo "Reinstalling dependencies..."
    bun install
    
    echo "Clean complete!"
}

function bbench() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: bbench <script_file>"
        echo "Example: bbench benchmark.js"
        return 1
    fi
    
    echo "Running benchmark: $1"
    bun run $1
}