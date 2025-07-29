# Architecture detection utility
if [ -z "$ARCH" ]; then
  ARCH=$(uname -m)
fi

case $ARCH in
  amd64)
    ARCH=amd64
    SUFFIX=
    ;;
  x86_64)
    ARCH=amd64
    SUFFIX=
    ;;
  arm64)
    ARCH=arm64
    SUFFIX=-${ARCH}
    ;;
  s390x)
    ARCH=s390x
    SUFFIX=-${ARCH}
    ;;
  aarch64)
    ARCH=arm64
    SUFFIX=-${ARCH}
    ;;
  arm*)
    ARCH=arm
    SUFFIX=-${ARCH}hf
    ;;
  *)
    echo "Unsupported architecture $ARCH" >&2
    return 1
    ;;
esac
