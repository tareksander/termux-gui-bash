# Bash Library Tutorial

Make sure you installed the library like explained in the README.  
This tutorial assumes you have the basic understanding of the Android GUI from
the [crash course](https://github.com/termux/termux-gui).  
The full source code can also be found in the tutorial folder.

## Loading the library

To use the library, you have 2 options:
- Use the shebang `#!/bin/tgui-bash` instead of `#!/bin/bash`. The library will initialize itself and then load your script.
- Source the library with `. tgui-bash`.

The library exits when your script exits, and all remaining Activities are cleaned up by the Plugin after that.


## Hello World

````bash
#!/bin/tgui-bash

set -u

# Parameters for the Activity, can be empty
declare -A aparams=()
# Array to store the Activity id and Task id in
declare -a activity=()

# Start the Activity
tg_activity_new aparams activity

# Get the Activity id from the array as a shortcut
aid="${activity[0]}"

# Parameters for creating a TextView, in this case the initial text.
# For the keys there are constants, to help with IDE autocompletion and
# to make it obvious when you mistyped.
declare -A tparams=([${tgc_create_text}]="Hello World!")

# Create the TextView
tg_create_text "$aid" tparams

# Wait 2 seconds before exiting
sleep 2
````

[hello_world.sh](tutorial/hello_world.sh)


## Events


In a GUI, you want to react to events caused by the user.  
In this library you have the option to poll for events (not recommended) with `tg_msg_recv_event`
and to wait for events with `tg_msg_recv_event_blocking`.  
To process events, you have some functions and `jq` available to get the information you need.  
Though for most of the events you only need to know that the `.` operator in jq accesses a value of an object.  
With that, you can parse the events you need according to the [protocol definition](https://github.com/termux/termux-gui/blob/main/Protocol.md#events).



````bash
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
````

[events.sh](tutorial/events.sh)

## Layout hierarchy

To arrange Views you need to use Layouts. The simplest one is LinearLayout.

````bash
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
````

[linearlayout.sh](tutorial/linearlayout.sh)

## Images and picture-in-picture

You can display images in PNG or JPEG format by base43-encoding them.  
The `base64` command is preinstalled in Termux.  
To generate the image string you should use `img="$(base64 -w 0 <filepath>)"`.  
  
Picture-in-picture mode allows you to show the Activity in a small overlay window.


````bash
#!/bin/tgui-bash

set -u

# Base64-encoded image of the Termux banner
banner="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"

# Let the Activity start in picture-in-picture mode
declare -A aparams=([$tgc_actvivity_pip]="true")
declare -a activity=()

tg_activity_new aparams activity

aid="${activity[0]}"

# set the aspect ratio to that of the image
tg_activity_pip_params "$aid" "320" "180"

declare -A imgparams=()

# Create an ImageView and save the id
img="$(tg_create_image "$aid" imgparams)"

# Set the image
tg_view_image "$aid" "$img" "$banner"

while true; do
  ev="$(tg_msg_recv_event_blocking)"
  # Exit when the user leaves
  if [ "$(tg_event_type "$ev")" = "$tgc_ev_stop" ]; then
    exit 0
  fi
done
````

[image.sh](tutorial/image.sh)

## Dialogs & Inputs

An Activity can also be shown as a dialog.  
This make for a great user experience with Termux, as exiting the dialog drops you right back into the terminal without animation.


````bash
#!/bin/tgui-bash

set -u


# Let the Activity start as a dialog
declare -A aparams=([$tgc_actvivity_dialog]="true")
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
````

[dialog.sh](tutorial/dialog.sh)



## Nested Layouts & Scrolling

By default, LinearLayouts arrange their children vertically.  
To create e.g. a bar at the top, you can override this with `$tgc_create_vertical`.  
To create a bar however, you should also set the height of the nested layout to `$tgc_view_wrap_content`,
and the layout weight to 0, so it only takes up the space of its children.  
Nested layouts can also be used for content in NestedScrollViews, when you can't be sure if the content will fit on the screen.


````bash
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
````

[scroll.sh](tutorial/scroll.sh)


## Widgets

Termux:GUI allows you to create widgets which programs can fill.  
The methods for widgets are slightly different, because Android doesn't support as much functionality for widgets.


````bash
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
````


