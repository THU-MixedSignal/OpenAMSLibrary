#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s {ac|tran} [spectre|aps|cx|ax|mx|lx|vx]\n' "$0"
  printf 'Default mode: cx\n'
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage >&2
  exit 2
fi

analysis="$1"
mode="${2:-cx}"

case "$analysis" in
  ac|tran) ;;
  *)
    printf 'Unsupported analysis: %s\n' "$analysis" >&2
    usage >&2
    exit 2
    ;;
esac

mode_args=()
case "$mode" in
  spectre) ;;
  aps) mode_args=(+aps) ;;
  cx|ax|mx|lx|vx) mode_args=("+preset=$mode" +mt) ;;
  *)
    printf 'Unsupported Spectre mode: %s\n' "$mode" >&2
    usage >&2
    exit 2
    ;;
esac

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
deck="$root_dir/$analysis.scs"
output_dir="$root_dir/results/${analysis}_${mode}"
raw_dir="$output_dir/$analysis.raw"
log_file="$output_dir/spectre.log"

if ! command -v spectre >/dev/null 2>&1; then
  printf 'spectre was not found in PATH. Load your Cadence environment first.\n' >&2
  exit 127
fi

if grep -q '/path/to/your/TSMC28_PDK/' "$deck"; then
  printf 'Edit the PDK paths near the top of %s before running.\n' "$deck" >&2
  exit 2
fi

mkdir -p "$output_dir"

cmd=(
  spectre -64 "$deck"
  +escchars
  +log "$log_file"
  -format psfascii
  -raw "$raw_dir"
  "${mode_args[@]}"
  +lqtimeout 900
  -maxw 20
  -maxn 20
  +logstatus
)

printf 'Running:'
printf ' %q' "${cmd[@]}"
printf '\n'

cd "$root_dir"
"${cmd[@]}"
