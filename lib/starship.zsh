# Platform and architecture detection utility

# Detect OS for binary selection
STARSHIP_OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "${STARSHIP_OS}" in
  msys*|cygwin*|mingw*) STARSHIP_OS="pc-windows-msvc" ;;
  linux) STARSHIP_OS="unknown-linux-gnu" ;;
  darwin) STARSHIP_OS="apple-darwin" ;;
  freebsd) STARSHIP_OS="unknown-freebsd" ;;
esac

# Detect architecture for binary selection
STARSHIP_ARCH="$(uname -m | tr '[:upper:]' '[:lower:]')"
case "${STARSHIP_ARCH}" in
  amd64) STARSHIP_ARCH="x86_64" ;;
  armv*) STARSHIP_ARCH="arm" ;;
  arm64) STARSHIP_ARCH="aarch64" ;;
  x86_64) [ "$(getconf LONG_BIT)" -eq 32 ] && STARSHIP_ARCH=i686 ;;
  aarch64) [ "$(getconf LONG_BIT)" -eq 32 ] && STARSHIP_ARCH=arm ;;
esac

STARSHIP_NAME="${STARSHIP_ARCH}-${STARSHIP_OS}"