#!@TERMUX_PREFIX@/bin/bash

# Only use as interpreter
if [ $# -ne 1 ]; then
  echo 'Usage: tgui-bash path' >&2
  exit 1
fi

# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "jq not installed. please install jq with 'pkg i jq'" >&2
  exit 1
fi



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
  echo '"'"${1//\"/\\\"}"'"'
}

# Sends a message to the plugin.
# The first parameter is the message type.
# The second parameter is an associative array name that contains the parameters.
# String parameters have to be quoted with tg_str_quote.
function tg_json_send() {
  local tosend='{"method": "'"$1"'", "params": {'
  if [ "$2" != "" ]; then
    for key in "${${2}[@]}"; do
      tosend=${tosend}'"'"$key"'":'"${${2}[$key]},"
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
  tg_msg_recv | jq -e '. == true'
}

function tg_global_version() {
  :
}

### ACTIVITY METHODS


function tg_activity_new() {
  :
}

function tg_activity_finish() {
  :
}

function tg_activity_to_back() {
  :
}

function tg_activity_theme() {
  :
}

function tg_activity_description() {
  :
}

function tg_activity_pip_params() {
  :
}

function tg_activity_input() {
  :
}

function tg_activity_pip_auto() {
  :
}

function tg_activity_keep_screen_on() {
  :
}

function tg_activity_orientation() {
  :
}

function tg_activity_position() {
  :
}

function tg_activity_configuration() {
  :
}

function tg_activity_request_unlock() {
  :
}

function tg_activity_hide_soft_keyboard() {
  :
}

function tg_activity_intercept_back_button() {
  :
}


### TASK METHODS

function tg_task_finish() {
  :
}

function tg_task_to_front() {
  :
}

### VIEW CREATION














### VIEW MANIPULATION


















### REMOTE LAYOUTS, WIDGETS & NOTIFICATIONS













### EVENT CONTROL








### WEBVIEW






# find helper binary
prefix="$(dirname "${BASH_SOURCE[0]}")/.."
helper="${prefix}/libexec/termux-gui-bash-helper"
unset prefix

# generate random socket names
sock_main="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 60)"
sock_event="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 60)"

# shellcheck disable=SC2154
trap 'kill -9 $tg__main_PID; kill -9 $tg__event_PID' EXIT

# start listening on teh sockets
coproc tg__main { $helper --main "$sock_main" ; }
coproc tg__event { $helper "$sock_event" ; }

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


# Run user script

# shellcheck disable=SC1090
. "$1"

