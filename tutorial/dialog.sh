#!/bin/tgui-bash

set -u


# Let the Activity start as a dialog
declare -A aparams=([$tgc_activity_dialog]="true")
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"

declare -A params=()

layout="$(tg_create_linear "$aid" params)"

# EditText
et="$(tg_create_edit "$aid" params "$layout")"

params[$tgc_create_text]="Click me!"
echo "${params[@]}"
# Button
bt="$(tg_create_button "$aid" params "$layout")"

#unset "params[$tgc_create_text]"
declare -a list=("Option 1" "Option 2" "Option 3" "Option 4")

# Spinner
sp="$(tg_create_spinner "$aid" params "$layout")"
# Set the options
tg_view_list  "$aid" "$sp" list

# Toggle
tg="$(tg_create_toggle "$aid" params "$layout")"

params[$tgc_create_text]="Switch"

# Switch
sw="$(tg_create_switch "$aid" params "$layout")"


params[$tgc_create_text]="Checkbox"
# CheckBox
cb="$(tg_create_checkbox "$aid" params "$layout")"

# Group for RadioButtons
rg="$(tg_create_radio_group "$aid" params "$layout")"

# Create some RadioButtons
# RadioButtons have to be in a RadioGroup to work
params[$tgc_create_text]="RadioButton 1"
rb1="$(tg_create_radio "$aid" params "$rg")"

params[$tgc_create_text]="RadioButton 2"
rb2="$(tg_create_radio "$aid" params "$rg")"

params[$tgc_create_text]="RadioButton 3"
rb3="$(tg_create_radio "$aid" params "$rg")"


while true; do
  ev="$(tg_msg_recv_event_blocking)"
  # Exit when the user leaves
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_stop" ]; then
    exit 0
  fi
  # Print out the EditText text when the Button gets clicked
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_click" ] && [ "$(tg_event_aid "$ev")" = "$aid" ] && [ "$(tg_event_id "$ev")" = "$bt" ]; then
    echo "EditText text: '$(tg_view_get_text "$aid" "$et")'"
  fi
  # Print the RadioButton id that is selected
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_selected" ] && [ "$(tg_event_aid "$ev")" = "$aid" ] && [ "$(tg_event_id "$ev")" = "$rg" ]; then
    echo "RadioButton pressed: $(echo "$ev" | jq -r '.value.selected')"
  fi
  # Print the checked state of other button on click
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_click" ] && [ "$(tg_event_aid "$ev")" = "$aid" ] && [ "$(tg_event_id "$ev")" = "$cb" ]; then
    echo "CheckBox pressed: $(echo "$ev" | jq -r '.value.set')"
  fi
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_click" ] && [ "$(tg_event_aid "$ev")" = "$aid" ] && [ "$(tg_event_id "$ev")" = "$sw" ]; then
    echo "Switch pressed: $(echo "$ev" | jq -r '.value.set')"
  fi
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_click" ] && [ "$(tg_event_aid "$ev")" = "$aid" ] && [ "$(tg_event_id "$ev")" = "$tg" ]; then
    echo "ToggleButton pressed: $(echo "$ev" | jq -r '.value.set')"
  fi
  # Print the selected Spinner option
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_item_selected" ] && [ "$(tg_event_aid "$ev")" = "$aid" ] && [ "$(tg_event_id "$ev")" = "$sp" ]; then
    echo "Spinner option: '$(echo "$ev" | jq -r '.value.selected')'"
  fi
done
