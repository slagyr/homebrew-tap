#!/usr/bin/env bash
set -euo pipefail

TAG="${1:?usage: bump-isaac-formula.sh <tag> (e.g. v0.1.2)}"
FORMULA="Formula/isaac.rb"
URL="https://github.com/slagyr/isaac-foundation/archive/refs/tags/${TAG}.tar.gz"
VERSION="${TAG#v}"

SHA256="$(curl -fsSL "${URL}" | shasum -a 256 | awk '{print $1}')"

perl -0pi -e "s|url \"https://github.com/slagyr/isaac-foundation/archive/refs/tags/v[^\"]+\\.tar\\.gz\"|url \"${URL}\"|" "${FORMULA}"
perl -0pi -e "s|version \"[^\"]+\"|version \"${VERSION}\"|" "${FORMULA}"
perl -0pi -e "s|sha256 \"[a-f0-9]+\"|sha256 \"${SHA256}\"|" "${FORMULA}"

echo "Bumped ${FORMULA} to ${TAG} (${SHA256})"