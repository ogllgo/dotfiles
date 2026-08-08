#!/bin/bash

set -euo pipefail

for d in packages/*; do
    stow "$(basename "$d")"
done
