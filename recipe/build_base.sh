#!/bin/bash

set -euxo pipefail

echo rustc --version
export OPENSSL_DIR=$PREFIX

# Use native-tls on conda-forge
export MATURIN_SETUP_ARGS="--no-default-features --features=native-tls"

# Run the maturin build via pip which works for direct and
# cross-compiled builds.
$PYTHON -m pip install . -vv

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
