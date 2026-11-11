#!/usr/bin/env bash
# run_recon.sh - reproduce the Phase 1 footprinting commands from the report
# and save every output (with a timestamp) into ./recon-output/<target>-<time>/
#
# USE ONLY AGAINST SYSTEMS YOU OWN OR HAVE WRITTEN PERMISSION TO TEST.
# Passive tools: whois, nslookup. Active tools: whatweb, curl -I, wafw00f, dnsrecon.
#
# Usage:  ./scripts/run_recon.sh <domain> --i-have-permission
set -euo pipefail

TARGET="${1:-}"
CONSENT="${2:-}"

if [[ -z "$TARGET" || "$CONSENT" != "--i-have-permission" ]]; then
  echo "Usage: $0 <domain> --i-have-permission"
  echo "Only run this against domains you own or are explicitly authorised to test."
  exit 1
fi
if ! [[ "$TARGET" =~ ^[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Invalid domain: $TARGET"; exit 1
fi

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
OUT="recon-output/${TARGET}-${STAMP}"
mkdir -p "$OUT"
LOG="$OUT/_run.log"

run() {                      # run <name> <command...>
  local name="$1"; shift
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[skip] $1 not installed" | tee -a "$LOG"; return 0
  fi
  echo "[run ] $*  ($(date -u +%H:%M:%SZ))" | tee -a "$LOG"
  { echo "# $*"; echo "# started: $(date -u +%Y-%m-%dT%H:%M:%SZ)"; "$@" 2>&1 || true; } > "$OUT/${name}.txt"
}

echo "Target: $TARGET | Output: $OUT" | tee "$LOG"
run 01-whois     whois "$TARGET"
run 02-whatweb   whatweb "$TARGET"
run 03-nslookup  nslookup "$TARGET"
run 04-curl-head curl -sS -I "https://$TARGET"
run 05-wafw00f   wafw00f "$TARGET"
run 06-dnsrecon  dnsrecon -d "$TARGET"

echo "Done. Review the files in $OUT and attach screenshots to your report."
