#!/bin/bash
#
# run-speedtest.sh - runs automated unitymedia speedtest
# author, (c): Philippe Kueck <projects at unixadm dot org>

set -e

export DISPLAY=:99

trap "cleanup" 0 1 2 15

declare -a pids

cleanup() {
  kill ${pids[@]}
}

Xvfb ${DISPLAY} -screen 0 1600x1080x24 &
pids+=($!)
sleep 3

mwm&
pids+=($!)

log="speedtest_$(date +%Y%m%d-%H%M%S).log"

google-chrome \
  --allow-file-access-from-files \
  --disable-translate \
  --no-first-run \
  --no-default-browser-check \
  --user-data-dir \
  --disable-dev-shm-usage \
  --disable-features=InfiniteSessionRestore,TranslateUI \
  --window-position=0,0 \
  --window-size=1440,900 \
  --force-device-scale-factor=1 \
  --new-windows "file://${PWD}/speedtest_um.html?direct=1&closeBrowser=1&savelog=${log}" >& /dev/null
