#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

log() {
    echo "$*"
}

die() {
    local msg=$1
    local code=$2
    echo "$msg" >&2
    exit "$code"
}

if [ $# -ne 1 ]; then
    die "usage:$0 <log_dir>" 2
fi

log_dir=$1

if [ ! -d "$log_dir" ]||[ ! -r "$log_dir" ]; then
    die "error:'$log_dir' is not a readable directory" 3
fi

scanned=0
flagged=0

for f in "$log_dir"/*.log; do
    scanned=$((scanned+1))
    count=$(grep -c "ERROR" "$f" || true)
    log "$(basename "$f"): $count errors"

    if [ "$count" -gt 10 ]; then
    mkdir -p "$log_dir/review"
    cp "$f" "$log_dir/review"
    flagged=$((flagged+1))
fi
done

log "scanned=$scanned, flagged=$flagged"

if [ "$flagged" -gt 0 ]; then
    exit 1
fi







