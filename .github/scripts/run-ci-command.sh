#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "usage: $0 <title> <command> [args...]" >&2
  exit 2
fi

title="$1"
shift

safe_title="$(printf '%s' "${title}" | tr -cs '[:alnum:]._-+' '-')"
log_path="${RUNNER_TEMP:-/tmp}/${safe_title}.log"
mkdir -p "$(dirname "${log_path}")"

set +e
"$@" 2>&1 | tee "${log_path}"
status=${PIPESTATUS[0]}
set -e

if [ "${status}" -ne 0 ]; then
  if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
      echo "### ${title} failed"
      echo
      echo '```'
      tail -n 120 "${log_path}"
      echo '```'
    } >> "${GITHUB_STEP_SUMMARY}"
  fi

  tail -n 25 "${log_path}" | while IFS= read -r line; do
    escaped="${line//'%'/'%25'}"
    escaped="${escaped//$'\r'/'%0D'}"
    escaped="${escaped//$'\n'/'%0A'}"
    printf '::error title=%s failed::%s\n' "${title}" "${escaped}"
  done

  exit "${status}"
fi
