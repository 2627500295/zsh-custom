# Homebrew environment setup

# Function to install homebrew using git clone
install_homebrew() {
  local HOMEBREW_PREFIX="/opt/homebrew"
  
  case "$(uname -s)" in
    Darwin*|Linux*)
      echo "Installing Homebrew to ${HOMEBREW_PREFIX}..."
      ;;
    *)
      echo "Unsupported OS for Homebrew installation"
      return 1
      ;;
  esac
  
  # Create directory and clone homebrew
  sudo mkdir -p "${HOMEBREW_PREFIX}"
  sudo chown -R "$(whoami)" "${HOMEBREW_PREFIX}"
  git clone https://github.com/Homebrew/brew "${HOMEBREW_PREFIX}"
  
  echo "Homebrew installation completed"
}

# Function to setup homebrew environment
setup_brew_env() {
  local HOMEBREW_PREFIX

  # Check common brew installation paths and setup environment
  # Prioritize /opt/homebrew as the unified installation path
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    HOMEBREW_PREFIX="/opt/homebrew"
  elif [[ -x "/usr/local/Homebrew/bin/brew" ]]; then
    HOMEBREW_PREFIX="/usr/local/Homebrew"
  elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
    HOMEBREW_PREFIX="$HOME/.linuxbrew"
  fi

  if [[ -n "$HOMEBREW_PREFIX" ]]; then 
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    return 0
  fi
  
  return 1
}

# Main logic: setup environment or install if needed
if ! setup_brew_env; then
  if command -v git >/dev/null 2>&1; then
    install_homebrew
    setup_brew_env
  else
    echo "git is required to install Homebrew"
  fi
fi