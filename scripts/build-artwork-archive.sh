#!/usr/bin/env bash
# Build a reproducible artwork release tarball.
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VERSION=""
OUTPUT=""

usage() {
    cat <<EOF
usage: $0 [--version VERSION] [--output FILE]

Packs wallpapers, README and LICENSE into
deblite-artwork-<version>.tar.gz. The default version comes from VERSION and
the default output is out/deblite-artwork-<version>.tar.gz.
EOF
}

while [ $# -gt 0 ]; do
    case "$1" in
        --version)
            VERSION=$2
            shift 2
            ;;
        --output)
            OUTPUT=$2
            shift 2
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            echo "unknown argument: $1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

if [ -z "$VERSION" ]; then
    VERSION=$(tr -d '[:space:]' <"$ROOT/VERSION")
fi
if [ -z "$VERSION" ]; then
    echo "error: empty version" >&2
    exit 2
fi
if [ ! -d "$ROOT/wallpapers" ]; then
    echo "error: wallpapers directory is missing" >&2
    exit 1
fi

shopt -s nullglob
images=("$ROOT"/wallpapers/*.{jpg,jpeg,png,webp,svg,JPG,JPEG,PNG,WEBP,SVG})
if [ "${#images[@]}" -eq 0 ]; then
    echo "error: no supported images in $ROOT/wallpapers" >&2
    exit 1
fi

NAME="deblite-artwork-$VERSION"
if [ -z "$OUTPUT" ]; then
    OUTPUT="$ROOT/out/$NAME.tar.gz"
fi
mkdir -p "$(dirname "$OUTPUT")"

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/$NAME"
cp -a "$ROOT/wallpapers" "$TMP/$NAME/"
install -m 0644 "$ROOT/README.md" "$ROOT/LICENSE" "$TMP/$NAME/"

tar -C "$TMP" \
    --sort=name \
    --mtime='@0' \
    --owner=0 \
    --group=0 \
    --numeric-owner \
    --format=gnu \
    -czf "$OUTPUT" "$NAME"

echo "artwork: $OUTPUT"
sha256sum "$OUTPUT"
