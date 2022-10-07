#!/bin/tgui-bash

set -u

declare -A aparams=()
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"

# Parameters for creating a Button, in this case the text.
declare -A bparams=([${tgc_create_text}]="Hello World!")

# Create the Button and save the id
b="$(tg_create_button "$aid" bparams)"

while true; do
  ev="$(tg_msg_recv_event_blocking)"
  
  # Print when the button is pressed
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_click" ] && [ "$(tg_event_id "$ev")" = "$b" ]; then
    echo "Button pressed!"
  fi 
  
  # Exit when the Activity is closed
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_destroy" ]; then
    exit 0
  fi
done
