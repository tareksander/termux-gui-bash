#!/bin/tgui-bash

set -u


# Let the Activity start as a dialog
declare -A aparams=()
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"

declare -A params=()

layout="$(tg_create_linear "$aid" params)"


# Create a Horizontal LinearLayout
params[$tgc_create_vertical]=false

bar="$(tg_create_linear "$aid" params "$layout")"

unset "params[$tgc_create_vertical]"

# Set the height no the minimum needed
tg_view_height "$aid" "$bar" "$tgc_view_wrap_content"
# Don't let it expand to unused space
tg_view_linear "$aid" "$bar" 0

# Create 2 Buttons in the bar
params[$tgc_create_text]="Bar button 1"
bt1="$(tg_create_button "$aid" params "$bar")"

params[$tgc_create_text]="Bar button 2"
bt2="$(tg_create_button "$aid" params "$bar")"

unset "params[$tgc_create_text]"


# Create a NestedScrollView and a LinearLayout in it
sc="$(tg_create_nested_scroll "$aid" params "$layout")"
scl="$(tg_create_linear "$aid" params "$sc")"

# Create Buttons in the NestedScrollView
for i in {1..30}; do
  params[$tgc_create_text]="Button $i"
  tg_create_button "$aid" params "$scl" >/dev/null
done


while true; do
  ev="$(tg_msg_recv_event_blocking)"
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_destroy" ]; then
    exit 0
  fi
done
