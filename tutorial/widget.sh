#!/bin/tgui-bash

set -u


# Let the Activity start as a dialog
declare -A aparams=()
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"

declare -A params=()

layout="$(tg_create_linear "$aid" params)"


widfield="$(tg_create_edit "$aid" params "$layout")"

textfield="$(tg_create_edit "$aid" params "$layout")"


params[$tgc_create_text]="Set widget text"

b="$(tg_create_button "$aid" params "$layout")"


while true; do
  ev="$(tg_msg_recv_event_blocking)"
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_destroy" ]; then
    exit 0
  fi
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_click" ] && [ "$(tg_event_id "$ev")" = "$b" ]; then
    # Get the widget id
    wid="$(tg_view_get_text "$aid" "$widfield")"
    text="$(tg_view_get_text "$aid" "$textfield")"
    # Create a remote layout and TextView
    rl="$(tg_remote_create_layout)"
    rt="$(tg_remote_create_text "$rl")"
    # Set the text
    tg_remote_text "$rl" "$rt" "$text"
    # Set the widget layout and destroy the remote layout again
    tg_widget_layout "$rl" "$wid"
    tc_remote_delete_layout "$rl"
  fi
done
