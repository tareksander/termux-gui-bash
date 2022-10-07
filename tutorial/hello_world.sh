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