#!/bin/tgui-bash

set -u

declare -A aparams=()
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"


declare -A lparams=()

# Create the LinearLayout and save the id
layout="$(tg_create_linear "$aid" lparams)"

# Create Buttons in the Layout
declare -A bparams=()
for i in {1..5}; do
  bparams[$tgc_create_text]=$i
  tg_create_button "$aid" bparams "$layout" >/dev/null
done

while true; do
  ev="$(tg_msg_recv_event_blocking)"
  # Exit when the Activity is closed
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_destroy" ]; then
    exit 0
  fi
done
