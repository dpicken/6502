#!/bin/bash

set -euo pipefail

if [ $# -ne 0 ]; then
  >&2 echo "Usage: $(basename $0)"
  exit 1
fi

src_path="$(dirname $0)"
artifact_path="$(mktemp -d)"

function cleanup() {
  rm -rf "$artifact_path"
}
trap cleanup EXIT

fqbn="arduino:avr:mega"
device="$(arduino-cli board list | grep "$fqbn" | cut -d ' ' -f 1)"
speed="$(cat "$src_path/monitor.ino" | grep -o 'Serial.begin.*' | sed 's/Serial.begin(\([0-9]*\));/\1/')"

arduino-cli compile --fqbn "$fqbn" --output-dir "$artifact_path" "$src_path"
arduino-cli upload -p "$device" --fqbn "$fqbn" --input-dir "$artifact_path" "$src_path"

stty -F "$device" "$speed" -brkint -icrnl -imaxbel -opost -isig -icanon min 0 time 0 -iexten -echo -echoe -echok -echoctl -echoke raw
cat "$device"
