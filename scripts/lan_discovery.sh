#!/usr/bin/env bash
# lan_discovery.sh - ping-sweep your OWN network (nmap -sn) and save grep-able output.
# Usage: ./scripts/lan_discovery.sh 192.168.18.0/24
# Compare two runs with:  ndiff old.xml new.xml
set -euo pipefail
NET="${1:-}"
[[ -z "$NET" ]] && { echo "Usage: $0 <cidr>   e.g. 192.168.18.0/24"; exit 1; }
command -v nmap >/dev/null || { echo "nmap is not installed"; exit 1; }
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p lan-scans
nmap -sn "$NET" -oA "lan-scans/pingsweep-${STAMP}"
echo "Saved lan-scans/pingsweep-${STAMP}.{nmap,gnmap,xml}"
