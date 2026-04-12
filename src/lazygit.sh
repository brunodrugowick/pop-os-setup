#!/bin/bash

DESTDIR=$HOME/.local/bin
DESTFILE=$DESTDIR/lazygit
ARCH=$(uname -m)

case "$ARCH" in
  x86_64)
    LAZYGIT_ARCH="x86_64"
    ;;
  aarch64|arm64)
    LAZYGIT_ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture for lazygit: $ARCH"
    exit 1
    ;;
esac

LATEST_VERSION=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name":\s*"v\K[^"]+')

if [ -z "$LATEST_VERSION" ]; then
  echo "Could not determine latest lazygit version"
  exit 1
fi

INSTALLED_VERSION=""
if command -v lazygit >/dev/null 2>&1; then
  INSTALLED_VERSION=$(lazygit --version 2>/dev/null | sed -n 's/.*version=\([^,]*\).*/\1/p' | head -n1)
fi

if [ "$INSTALLED_VERSION" = "$LATEST_VERSION" ] && [ -x "$DESTFILE" ]; then
  echo "lazygit $LATEST_VERSION already installed"
  exit 0
fi

TDIR=$(mktemp -d)
TFILE=$TDIR/lazygit.tar.gz

mkdir -p $DESTDIR
curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_VERSION}/lazygit_${LATEST_VERSION}_linux_${LAZYGIT_ARCH}.tar.gz" -o $TFILE
tar -xzf $TFILE -C $TDIR lazygit
install -Dm755 $TDIR/lazygit $DESTFILE
