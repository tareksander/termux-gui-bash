#!/bin/tgui-bash

if [ "$#" != 1 ]; then
  exit 1
fi

# shellcheck disable=SC2034
declare -A aparams=()
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"

wv="$(tg_create_web "$aid" aparams)"

tg_web_load_uri "$aid" "$wv" "data:text/html;base64,$(gunzip -c "$1" | base64 -w 0)"

while true; do
  ev="$(tg_msg_recv_event_blocking)"
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_destroy" ]; then
    exit 0
  fi
done


