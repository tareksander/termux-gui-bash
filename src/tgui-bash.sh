#!@TERMUX_PREFIX@/bin/bash


if [ $# -ne 1 ] && ! (return 0 2>/dev/null); then
  echo 'Usage: tgui-bash path' >&2
  exit 1
fi

if [ $# -ne 0 ] && (return 0 2>/dev/null); then
  echo 'When sourced, tgui-bash needs no arguments' >&2
  exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "jq not installed. pPlease install jq with 'pkg i jq'" >&2
  exit 1
fi





function tg__hex_to_dec() {
  echo "$((16#${1}))"
}





### CONSTANTS

declare -r tg_actvivity_tid="tid"
declare -r tg_actvivity_dialog="dialog"
declare -r tg_actvivity_canceloutside="canceloutside"
declare -r tg_actvivity_pip="pip"
declare -r tg_actvivity_lockscreen="lockscreen"
declare -r tg_actvivity_overlay="overlay"
declare -r tg_actvivity_intercept="intercept"









### MESSAGE FUNCTIONS

# receives a message from the main
function tg_msg_recv() {
  declare -r rs=$'\x1e' # ASCII RS
  local buf
  IFS= read -r -s -d "$rs" -u "${tg__main[0]}" buf
  local ret=$?
  if [ $ret -ne 0 ]; then
    return $ret
  fi
  echo -n "$buf"
  return 0
}

# receives a message from the event socket
function tg_msg_recv_event_blocking() {
  declare -r rs=$'\x1e' # ASCII RS
  local buf
  IFS= read -r -s -d "$rs" -u "${tg__event[0]}" buf
  local ret=$?
  if [ $ret -ne 0 ]; then
    return $ret
  fi
  echo -n "$buf"
  return 0
}

# receives an event if one is available
function tg_msg_recv_event() {
  if IFS= read -t 0 -r -s -d "$rs" -u "${tg__event[0]}"; then
    tg_msg_recv_event_blocking
  fi
}

# sends a raw string to the plugin
function tg_msg_send() {
  declare -r rs=$'\x1e' # ASCII RS
  echo -n "${1}${rs}" >&"${tg__main[1]}"
  if [ ! -e "/proc/$$/${tg__main[1]}" ]; then
    return 1
  fi
  return 0
}

# Quotes a string with double quotes and escapes all double quotes in the string.
function tg_str_quote() {
  # escape backslashes
  local backslashes_escaped="${1//\\/\\\\}"
  
  # escape quotes
  local quotes_escaped="${backslashes_escaped//\"/\\\"}"
  
  # escape newlines
  local newlines_escaped="${quotes_escaped//$'\n'/\\n}"
  
  # escape tabs
  local tabs_escaped="${newlines_escaped//$'\t'/\\t}"
  
  # Quote and output
  echo -n '"'"$tabs_escaped"'"'
}

# Sends a message to the plugin.
# The first parameter is the message type.
# The second parameter is an associative array name that contains the parameters.
# String parameters have to be quoted with tg_str_quote.
function tg_json_send() {
  local tosend='{"method": "'"$1"'", "params": {'
  if [ "$2" != "" ]; then
    local -n params="$2"
    for key in "${!params[@]}"; do
      tosend=${tosend}'"'"$key"'":'"${params[$key]},"
    done
    tosend=${tosend::-1}"}}"
  else
    tosend=${tosend}"}}"
  fi
  tg_msg_send "$tosend"
}



### GLOBAL METHODS


function tg_global_turn_screen_on() {
  tg_json_send turnScreenOn
}

function tg_global_is_locked() {
  tg_json_send isLocked
  tg_msg_recv | jq -e '. == true' >/dev/null
}

function tg_global_version() {
  tg_json_send getVersion
  tg_msg_recv | jq -r '.'
}

### ACTIVITY METHODS


function tg_activity_new() {
  local -n params="$1"
  local -n ret="$2"
  tg_json_send "newActivity" "$1"
  local rec
  rec="$(tg_msg_recv)"
  if [ "${params[${tg_actvivity_tid}]}" = "" ]; then
    ret[0]="$(echo "$rec" | jq -r '.[0]')"
    ret[1]="$(echo "$rec" | jq -r '.[1]')"
  else
    ret[0]="$(echo "$rec" | jq -r '.')"
  fi
}

function tg_activity_finish() {
  declare -A params=([aid]="$1")
  tg_json_send "finishActivity" params
}

function tg_activity_to_back() {
  declare -A params=([aid]="$1")
  tg_json_send "moveTaskToBack" params
}

function tg_activity_theme() {
  declare -A params=([aid]="$1" [statusBarColor]="$2" [colorPrimary]="$3" [windowBackground]="$4" [textColor]="$5" [colorAccent]="$6")
  tg_json_send "setTheme" params
}

function tg_activity_description() {
  declare -A params=([aid]="$1" [label]="$2" [img]="$3")
  tg_json_send "setTaskDescription" params
}

function tg_activity_pip_params() {
  declare -A params=([aid]="$1" [num]="$2" [den]="$3")
  tg_json_send "setPiPParams" params
}

function tg_activity_input() {
  declare -A params=([aid]="$1" [mode]="$2")
  tg_json_send "setInputMode" params
}

function tg_activity_pip() {
  declare -A params=([aid]="$1" [pip]="$2")
  tg_json_send "setPiPMode" params
}

function tg_activity_pip_auto() {
  declare -A params=([aid]="$1" [pip]="$2")
  tg_json_send "setPiPModeAuto" params
}

function tg_activity_keep_screen_on() {
  declare -A params=([aid]="$1" [on]="$2")
  tg_json_send "keepScreenOn" params
}

function tg_activity_orientation() {
  declare -A params=([aid]="$1" [orientation]="$2")
  tg_json_send "setOrientation" params
}

function tg_activity_position() {
  declare -A params=([aid]="$1" [x]="$2" [y]="$3")
  tg_json_send "setPosition" params
}

function tg_activity_configuration() {
  declare -A params=([aid]="$1")
  tg_json_send "getConfiguration" params
  tg_msg_recv
}

function tg_activity_request_unlock() {
  declare -A params=([aid]="$1")
  tg_json_send "requestUnlock" params
}

function tg_activity_hide_soft_keyboard() {
  declare -A params=([aid]="$1")
  tg_json_send "hideSoftKeyboard" params
}

function tg_activity_intercept_back_button() {
  declare -A params=([aid]="$1" [intercept]="$2")
  tg_json_send "interceptBackButton" params
}

### CONFIGURATION METHODS

function tg_configuration_dark_mode() {
  echo "$1" | jq -r '.dark_mode'
}

function tg_configuration_country() {
  echo "$1" | jq -r '.country'
}

function tg_configuration_language() {
  echo "$1" | jq -r '.language'
}

function tg_configuration_orientation() {
  echo "$1" | jq -r '.orientation'
}

function tg_configuration_keyboardHidden() {
  echo "$1" | jq -r '.keyboardHidden'
}

function tg_configuration_screenwidth() {
  echo "$1" | jq -r '.screenwidth'
}

function tg_configuration_screenheight() {
  echo "$1" | jq -r '.screenheight'
}

function tg_configuration_fontscale() {
  echo "$1" | jq -r '.fontscale'
}

function tg_configuration_density() {
  echo "$1" | jq -r '.density'
}




### TASK METHODS

function tg_task_finish() {
  declare -A params=([tid]="$1")
  tg_json_send "finishTask" params
}

function tg_task_to_front() {
  declare -A params=([tid]="$1")
  tg_json_send "bringTaskToFront" params
}




### VIEW CREATION


function tg_create_linear() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createLinearLayout" params
  tg_msg_recv
}

function tg_create_frame() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createFrameLayout" params
  tg_msg_recv
}

function tg_create_swipe_refresh() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createSwipeRefreshLayout" params
  tg_msg_recv
}

function tg_create_text() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createTextView" params
  tg_msg_recv
}

function tg_create_edit() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createEditText" params
  tg_msg_recv
}

function tg_create_button() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createButton" params
  tg_msg_recv
}

function tg_create_image() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createImageView" params
  tg_msg_recv
}

function tg_create_space() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createSpace" params
  tg_msg_recv
}

function tg_create_nested_scroll() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createNestedScrollView" params
  tg_msg_recv
}

function tg_create_horizontal_scroll() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createHorizontalScrollView" params
  tg_msg_recv
}

function tg_create_radio() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createRadioButton" params
  tg_msg_recv
}

function tg_create_radio_group() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createRadioGroup" params
  tg_msg_recv
}

function tg_create_checkbox() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createCheckbox" params
  tg_msg_recv
}

function tg_create_toggle() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createToggleButton" params
  tg_msg_recv
}

function tg_create_switch() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createSwitch" params
  tg_msg_recv
}

function tg_create_spinner() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createSpinner" params
  tg_msg_recv
}

function tg_create_progress() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createProgressBar" params
  tg_msg_recv
}

function tg_create_tab() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createTabLayout" params
  tg_msg_recv
}

function tg_create_grid() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createGridLayout" params
  tg_msg_recv
}

function tg_create_web() {
  declare -A params=([aid]="$1")
  if [ "$2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "createWebView" params
  tg_msg_recv
}












### VIEW MANIPULATION


















### REMOTE LAYOUTS, WIDGETS & NOTIFICATIONS













### EVENT CONTROL








### WEBVIEW










# find helper binary
helper="@TERMUX_PREFIX@/libexec/termux-gui-bash-helper"

# generate random socket names
sock_main="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 60)"
sock_event="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 60)"

# shellcheck disable=SC2154
trap 'kill -9 $tg__main_PID >/dev/null 2>&1; kill -9 $tg__event_PID >/dev/null 2>&1' EXIT



# start listening on teh sockets
coproc tg__main { $helper --main "$sock_main" ; }

# redirect stderr, save it and restore it, to suppress the warning for running 2 coprocs
exec 3>&2 2>/dev/null

coproc tg__event { exec 2>&3 3>&- ; $helper "$sock_event" ; }

exec 2>&3 3>&-


# use termux-am if available
if ! command -v termux-am &>/dev/null; then
  am_command="termux-am"
else
  am_command="am"
fi


# contact plugin
$am_command broadcast -n com.termux.gui/.GUIReceiver --es mainSocket "$sock_main" --es eventSocket "$sock_event" >/dev/null 2>&1

# clear up variables
unset helper
unset am_command
unset sock_main
unset sock_event


# Run user script if not sourced
if ! (return 0 2>/dev/null); then
  # shellcheck disable=SC1090
  . "$1"
fi
