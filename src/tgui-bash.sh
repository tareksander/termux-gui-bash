#!@TERMUX_PREFIX@/bin/bash

# unset variables from the extract script
unset archivestart

if [ $# -lt 1 ] && ! (return 0 2>/dev/null); then
  echo 'Usage: tgui-bash path ...' >&2
  exit 1
fi

if [ $# -ne 0 ] && (return 0 2>/dev/null); then
  echo 'When sourced, tgui-bash needs no arguments' >&2
  exit 1
fi

if [ "$1" = "-h" ]; then
  if [ "$2" = 0 ]; then
    docpath="@TERMUX_PREFIX@/share/tgui-bash/manual"
  fi
  if [ "$2" = 1 ]; then
    docpath="@TERMUX_PREFIX@/share/tgui-bash/tutorial"
  fi
  if [ -z "$docpath" ]; then
    while true; do
      echo "Showing help. Do you want:"
      echo "0: The manual"
      echo "1: The tutorial"
      read -r resp
      if [ "$resp" == 0 ]; then
        docpath="@TERMUX_PREFIX@/share/tgui-bash/manual"
        break
      fi
      if [ "$resp" == 1 ]; then
        docpath="@TERMUX_PREFIX@/share/tgui-bash/tutorial"
        break
      fi
      echo
    done
  fi
  if [ "$3" = 0 ]; then
    docpathext="-dark.html.gz"
  fi
  if [ "$3" = 1 ]; then
    docpathext="-light.html.gz"
  fi
  if [ -z "$docpathext" ]; then
    while true; do
      echo "Light or dark theme:"
      echo "0: Dark"
      echo "1: Light"
      read -r resp
      if [ "$resp" == 0 ]; then
        docpathext="-dark.html.gz"
        break
      fi
      if [ "$resp" == 1 ]; then
        docpathext="-light.html.gz"
        break
      fi
      echo
    done
  fi
  if [ "$4" = 0 ]; then
    @TERMUX_PREFIX@/share/tgui-bash/docviewer.sh "$docpath$docpathext"
    exit 0
  fi
  if [ "$4" = 1 ]; then
    browser="com.android.htmlviewer/.HTMLViewerActivity"
  fi
  if [ "$4" = 2 ]; then
    browser="com.android.chrome/com.google.android.apps.chrome.Main"
  fi
  if [ "$4" = 3 ]; then
    browser="org.mozilla.firefox/.org.mozilla.firefox.App"
  fi
  if [ -z "$browser" ]; then
    while true; do
      echo "What browser do you want:"
      echo "0: The Termux:GUI WebView"
      echo "1: Android integrated HTML Viewer"
      echo "2: Chrome"
      echo "3: Firefox"
      read -r resp
      if [ "$resp" == 0 ]; then
        @TERMUX_PREFIX@/share/tgui-bash/manual.html "$docpath$docpathext"
        exit 0
      fi
      if [ "$resp" == 1 ]; then
        browser="com.android.htmlviewer/.HTMLViewerActivity"
        break
      fi
      if [ "$resp" == 2 ]; then
        browser="com.android.chrome/com.google.android.apps.chrome.Main"
        break
      fi
      if [ "$resp" == 3 ]; then
        browser="org.mozilla.firefox/.org.mozilla.firefox.App"
        break
      fi
      echo
    done
  fi
  am start -d "data:text/html;base64,$(gunzip -c "$docpath$docpathext" | base64 -w 0)" "$browser" >/dev/null 2>&1
  exit 0
fi


# Check if jq is installed
if ! command -v jq &>/dev/null; then
  echo "jq not installed. Please install jq with 'pkg i jq'" >&2
  exit 1
fi





function tg__hex_to_dec() {
  echo "$((16#${1}))"
}





### CONSTANTS

declare -r tgc_activity_tid="tid"
# shellcheck disable=SC2034
declare -r tgc_activity_dialog="dialog"
# shellcheck disable=SC2034
declare -r tgc_activity_canceloutside="canceloutside"
# shellcheck disable=SC2034
declare -r tgc_activity_pip="pip"
# shellcheck disable=SC2034
declare -r tgc_activity_lockscreen="lockscreen"
# shellcheck disable=SC2034
declare -r tgc_activity_overlay="overlay"
# shellcheck disable=SC2034
declare -r tgc_activity_intercept="intercept"


# shellcheck disable=SC2034
declare -r tgc_create_text="text"
# shellcheck disable=SC2034
declare -r tgc_create_selectable_text="selectableText"
# shellcheck disable=SC2034
declare -r tgc_create_clickable_links="clickableLinks"
# shellcheck disable=SC2034
declare -r tgc_create_vertical="vertical"
# shellcheck disable=SC2034
declare -r tgc_create_snapping="snapping"
# shellcheck disable=SC2034
declare -r tgc_create_fill_viewport="fillviewport"
# shellcheck disable=SC2034
declare -r tgc_create_no_bar="nobar"
# shellcheck disable=SC2034
declare -r tgc_create_checked="checked"
# shellcheck disable=SC2034
declare -r tgc_create_single_line="singleline"
# shellcheck disable=SC2034
declare -r tgc_create_line="line"
# shellcheck disable=SC2034
declare -r tgc_create_type="type"
# shellcheck disable=SC2034
declare -r tgc_create_rows="rows"
# shellcheck disable=SC2034
declare -r tgc_create_cols="cols"
# shellcheck disable=SC2034
declare -r tgc_create_all_caps="allcaps"


# shellcheck disable=SC2034
declare -r tgc_vis_gone="0"
# shellcheck disable=SC2034
declare -r tgc_vis_visible="2"
# shellcheck disable=SC2034
declare -r tgc_vis_hidden="1"

# shellcheck disable=SC2034
declare -r tgc_view_wrap_content='"WRAP_CONTENT"'
# shellcheck disable=SC2034
declare -r tgc_view_match_parent='"MATCH_PARENT"'

# shellcheck disable=SC2034
declare -r tgc_grid_top="top"
# shellcheck disable=SC2034
declare -r tgc_grid_bottom="bottom"
# shellcheck disable=SC2034
declare -r tgc_grid_left="left"
# shellcheck disable=SC2034
declare -r tgc_grid_right="right"
# shellcheck disable=SC2034
declare -r tgc_grid_center="center"
# shellcheck disable=SC2034
declare -r tgc_grid_baseline="baseline"
# shellcheck disable=SC2034
declare -r tgc_grid_fill="fill"

# shellcheck disable=SC2034
declare -r tgc_dir_top="top"
# shellcheck disable=SC2034
declare -r tgc_dir_bottom="bottom"
# shellcheck disable=SC2034
declare -r tgc_dir_left="left"
# shellcheck disable=SC2034
declare -r tgc_dir_right="right"

# shellcheck disable=SC2034
declare -r tgc_grav_top_left="0"
# shellcheck disable=SC2034
declare -r tgc_grav_center="1"
# shellcheck disable=SC2034
declare -r tgc_grav_bottom_right="2"


# shellcheck disable=SC2034
declare -r tgc_not_id="id"
# shellcheck disable=SC2034
declare -r tgc_not_ongoing="ongoing"
# shellcheck disable=SC2034
declare -r tgc_not_layout="layout"
# shellcheck disable=SC2034
declare -r tgc_not_expanded_layout="expandedLayout"
# shellcheck disable=SC2034
declare -r tgc_not_hud_layout="hudLayout"
# shellcheck disable=SC2034
declare -r tgc_not_title="title"
# shellcheck disable=SC2034
declare -r tgc_not_content="content"
# shellcheck disable=SC2034
declare -r tgc_not_large_image="largeImage"
# shellcheck disable=SC2034
declare -r tgc_not_large_text="largeText"
# shellcheck disable=SC2034
declare -r tgc_not_large_image_thumbnail="largeImageAsThumbnail"
# shellcheck disable=SC2034
declare -r tgc_not_icon="icon"
# shellcheck disable=SC2034
declare -r tgc_not_alert_once="alertOnce"
# shellcheck disable=SC2034
declare -r tgc_not_show_timestamp="showTimestamp"
# shellcheck disable=SC2034
declare -r tgc_not_timestamp="timestamp"
# shellcheck disable=SC2034
declare -r tgc_not_actions="actions"


# shellcheck disable=SC2034
declare -r tgc_ev_click="click"
# shellcheck disable=SC2034
declare -r tgc_ev_long_click="longClick"
# shellcheck disable=SC2034
declare -r tgc_ev_focus_change="focusChange"
# shellcheck disable=SC2034
declare -r tgc_ev_refresh="refresh"
# shellcheck disable=SC2034
declare -r tgc_ev_selected="selected"
# shellcheck disable=SC2034
declare -r tgc_ev_item_selected="itemselected"
# shellcheck disable=SC2034
declare -r tgc_ev_text="text"
# shellcheck disable=SC2034
declare -r tgc_ev_back="back"
# shellcheck disable=SC2034
declare -r tgc_ev_webview_navigation="webviewNavigation"
# shellcheck disable=SC2034
declare -r tgc_ev_webview_http_error="webviewHTTPError"
# shellcheck disable=SC2034
declare -r tgc_ev_webview_error="webviewError"
# shellcheck disable=SC2034
declare -r tgc_ev_webview_destroyed="webviewDestroyed"
# shellcheck disable=SC2034
declare -r tgc_ev_webview_progress="webviewProgress"
# shellcheck disable=SC2034
declare -r tgc_ev_webview_console_message="webviewConsoleMessage"
# shellcheck disable=SC2034
declare -r tgc_ev_create="create"
# shellcheck disable=SC2034
declare -r tgc_ev_start="start"
# shellcheck disable=SC2034
declare -r tgc_ev_resume="resume"
# shellcheck disable=SC2034
declare -r tgc_ev_pause="pause"
# shellcheck disable=SC2034
declare -r tgc_ev_stop="stop"
# shellcheck disable=SC2034
declare -r tgc_ev_destroy="destroy"
# shellcheck disable=SC2034
declare -r tgc_ev_config="config"
# shellcheck disable=SC2034
declare -r tgc_ev_user_leave_hint="UserLeaveHint"
# shellcheck disable=SC2034
declare -r tgc_ev_pip_changed="pipchanged"
# shellcheck disable=SC2034
declare -r tgc_ev_airplane="airplane"
# shellcheck disable=SC2034
declare -r tgc_ev_locale="locale"
# shellcheck disable=SC2034
declare -r tgc_ev_screen_on="screen_on"
# shellcheck disable=SC2034
declare -r tgc_ev_screen_off="screen_off"
# shellcheck disable=SC2034
declare -r tgc_ev_timezone="timezone"
# shellcheck disable=SC2034
declare -r tgc_ev_notification="notification"
# shellcheck disable=SC2034
declare -r tgc_ev_notification_dismissed="notificationDismissed"
# shellcheck disable=SC2034
declare -r tgc_ev_notification_action="notificationaction"
# shellcheck disable=SC2034
declare -r tgc_ev_remote_click="remoteclick"


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
  local tg_json_send_tosend='{"method": "'"$1"'", "params": {'
  if [ "$2" != "" ]; then
    local -n tg_json_send_params="$2"
    if [ "${#tg_json_send_params[@]}" -ne 0 ]; then
      for key in "${!tg_json_send_params[@]}"; do
        tg_json_send_tosend="${tg_json_send_tosend}"'"'"$key"'":'"${tg_json_send_params[$key]},"
      done
      tg_json_send_tosend=${tg_json_send_tosend::-1}"}}"
    else
      tg_json_send_tosend=${tg_json_send_tosend}"}}"
    fi
  else
    tg_json_send_tosend=${tg_json_send_tosend}"}}"
  fi
  #echo "$tg_json_send_tosend"
  tg_msg_send "$tg_json_send_tosend"
}

function tg__array_copy() {
  local -n tg__array_copy_source="$1"
  local -n tg__array_copy_dest="$2"
  for key in "${!tg__array_copy_source[@]}"; do
    # shellcheck disable=SC2034
    tg__array_copy_dest["$key"]="${tg__array_copy_source["$key"]}"
  done
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
  local -n tg_activity_new_params="$1"
  local -n tg_activity_new_ret="$2"
  tg_json_send "newActivity" "$1"
  local tg_activity_rec
  tg_activity_rec="$(tg_msg_recv)"
  if [ ! -v "tg_activity_new_params[${tgc_activity_tid}]" ]; then
    tg_activity_new_ret[0]="$(echo "$tg_activity_rec" | jq -r '.[0]')"
    tg_activity_new_ret[1]="$(echo "$tg_activity_rec" | jq -r '.[1]')"
  else
    # shellcheck disable=SC2034
    tg_activity_new_ret[0]="$(echo "$tg_activity_rec" | jq -r '.')"
  fi
}

function tg_activity_finish() {
  declare -A tg__local_params=([aid]="$1")
  tg_json_send "finishActivity" tg__local_params
}

function tg_activity_to_back() {
  declare -A tg__local_params=([aid]="$1")
  tg_json_send "moveTaskToBack" tg__local_params
}

function tg_activity_theme() {
  declare -A tg__local_params=([aid]="$1" [statusBarColor]="$(tg__hex_to_dec "$2")" [colorPrimary]="$(tg__hex_to_dec "$3")" [windowBackground]="$(tg__hex_to_dec "$4")" [textColor]="$(tg__hex_to_dec "$5")" [colorAccent]="$(tg__hex_to_dec "$6")")
  tg_json_send "setTheme" tg__local_params
}

function tg_activity_description() {
  declare -A tg__local_params=([aid]="$1" [label]="$2" [img]="$3")
  tg_json_send "setTaskDescription" tg__local_params
}

function tg_activity_pip_tg__local_params() {
  declare -A tg__local_params=([aid]="$1" [num]="$2" [den]="$3")
  tg_json_send "setPiPParams" tg__local_params
}

function tg_activity_input() {
  declare -A tg__local_params=([aid]="$1" [mode]="$2")
  tg_json_send "setInputMode" tg__local_params
}

function tg_activity_pip() {
  declare -A tg__local_params=([aid]="$1" [pip]="$2")
  tg_json_send "setPiPMode" tg__local_params
}

function tg_activity_pip_auto() {
  declare -A tg__local_params=([aid]="$1" [pip]="$2")
  tg_json_send "setPiPModeAuto" tg__local_params
}

function tg_activity_keep_screen_on() {
  declare -A tg__local_params=([aid]="$1" [on]="$2")
  tg_json_send "keepScreenOn" tg__local_params
}

function tg_activity_orientation() {
  declare -A tg__local_params=([aid]="$1" [orientation]="$2")
  tg_json_send "setOrientation" tg__local_params
}

function tg_activity_position() {
  declare -A tg__local_params=([aid]="$1" [x]="$2" [y]="$3")
  tg_json_send "setPosition" tg__local_params
}

function tg_activity_configuration() {
  declare -A tg__local_params=([aid]="$1")
  tg_json_send "getConfiguration" tg__local_params
  tg_msg_recv
}

function tg_activity_request_unlock() {
  declare -A tg__local_params=([aid]="$1")
  tg_json_send "requestUnlock" tg__local_params
}

function tg_activity_hide_soft_keyboard() {
  declare -A tg__local_params=([aid]="$1")
  tg_json_send "hideSoftKeyboard" tg__local_params
}

function tg_activity_intercept_back_button() {
  declare -A tg__local_params=([aid]="$1" [intercept]="$2")
  tg_json_send "interceptBackButton" tg__local_params
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
  declare -A tg__local_params=([tid]="$1")
  tg_json_send "finishTask" tg__local_params
}

function tg_task_to_front() {
  declare -A tg__local_params=([tid]="$1")
  tg_json_send "bringTaskToFront" tg__local_params
}




### VIEW CREATION

function tg__create() {
  # shellcheck disable=SC2034
  local -n tg__create_args="$3"
  declare -A tg__create_params=([aid]="$2")
  tg__array_copy tg__create_args tg__create_params
  if [ -v "4" ]; then
    tg__create_params[parent]="$4"
  fi
  if [ -v "5" ]; then
    tg__create_params[visibility]="$5"
  fi
  if [ -v "tg__create_params[text]" ]; then
    tg__create_params[text]="$(tg_str_quote "${tg__create_params[text]}")"
  fi
  if [ -v "tg__create_params[type]" ]; then
    tg__create_params[type]="$(tg_str_quote "${tg__create_params[type]}")"
  fi
  tg_json_send "$1" tg__create_params
  tg_msg_recv
}

function tg_create_linear() {
  tg__create "createLinearLayout" "$@"
}

function tg_create_frame() {
  tg__create "createFrameLayout" "$@"
}

function tg_create_swipe_refresh() {
  tg__create "createSwipeRefreshLayout" "$@"
}

function tg_create_text() {
  tg__create "createTextView" "$@"
}

function tg_create_edit() {
  tg__create "createEditText" "$@"
}

function tg_create_button() {
  tg__create "createButton" "$@"
}

function tg_create_image() {
  tg__create "createImageView" "$@"
}

function tg_create_space() {
  tg__create "createSpace" "$@"
}

function tg_create_nested_scroll() {
  tg__create "createNestedScrollView" "$@"
}

function tg_create_horizontal_scroll() {
  tg__create "createHorizontalScrollView" "$@"
}

function tg_create_radio() {
  tg__create "createRadioButton" "$@"
}

function tg_create_radio_group() {
  tg__create "createRadioGroup" "$@"
}

function tg_create_checkbox() {
  tg__create "createCheckbox" "$@"
}

function tg_create_toggle() {
  tg__create "createToggleButton" "$@"
}

function tg_create_switch() {
  tg__create "createSwitch" "$@"
}

function tg_create_spinner() {
  tg__create "createSpinner" "$@"
}

function tg_create_progress() {
  tg__create "createProgressBar" "$@"
}

function tg_create_tab() {
  tg__create "createTabLayout" "$@"
}

function tg_create_grid() {
  tg__create "createGridLayout" "$@"
}

function tg_create_web() {
  tg__create "createWebView" "$@"
}












### VIEW MANIPULATION

function tg_view_show_cursor() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [show]="$3")
  tg_json_send "showCursor" tg__local_params
}

function tg_view_linear() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  if [ -v "3" ]; then
      tg__local_params[weight]="$3"
    fi
  if [ -v "4" ]; then
    tg__local_params[position]="$4"
  fi
  tg_json_send "setLinearLayoutParams" tg__local_params
}

function tg_view_grid() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  if [ -v "3" ]; then
    tg__local_params[row]="$3"
  fi
  if [ -v "4" ]; then
    tg__local_params[col]="$4"
  fi
  if [ -v "5" ]; then
    tg__local_params[rowsize]="$5"
  fi
  if [ -v "6" ]; then
    tg__local_params[colsize]="$6"
  fi
  if [ -v "7" ]; then
    tg__local_params[alignmentrow]="$(tg_str_quote "$7")"
  fi
  if [ -v "8" ]; then
    tg__local_params[alignmentcol]="$(tg_str_quote "$8")"
  fi
  tg_json_send "setGridLayoutParams" tg__local_params
}

function tg_view_location() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [x]="$3" [y]="$4")
  if [ -v "5" ]; then
    tg__local_params[dp]="$5"
    fi
  if [ -v "6" ]; then
    tg__local_params[top]="$6"
  fi
  tg_json_send "setViewLocation" tg__local_params
}

function tg_view_vis() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [vis]="$3")
  tg_json_send "setVisibility" tg__local_params
}

function tg_view_width() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [width]="$3")
  if [ -v "4" ]; then
    tg__local_params[px]="$4"
  fi
  tg_json_send "setWidth" tg__local_params
}

function tg_view_height() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [height]="$3")
  if [ -v "4" ]; then
    tg__local_params[px]="$4"
  fi
  tg_json_send "setHeight" tg__local_params
}

function tg_view_dimensions() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "getDimensions" tg__local_params
  tg_msg_recv
}

function tg_view_delete() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "deleteView" tg__local_params
}

function tg_view_delete_children() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "deleteChildren" tg__local_params
}

function tg_view_margin() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [margin]="$3")
  if [ -v "4" ]; then
    tg__local_params[dir]="$(tg_str_quote "$4")"
  fi
  tg_json_send "setMargin" tg__local_params
}

function tg_view_padding() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [padding]="$3")
  if [ -v "4" ]; then
    tg__local_params[dir]="$(tg_str_quote "$4")"
  fi
  tg_json_send "setPadding" tg__local_params
}

function tg_view_bg_color() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setBackgroundColor" tg__local_params
}

function tg_view_text_color() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setTextColor" tg__local_params
}

function tg_view_progress() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [progress]="$3")
  tg_json_send "setProgress" tg__local_params
}

function tg_view_refreshing() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [refresh]="$3")
  tg_json_send "setRefreshing" tg__local_params
}

function tg_view_text() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [text]="$(tg_str_quote "$3")")
  tg_json_send "setText" tg__local_params
}

function tg_view_gravity() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [horizontal]="$3" [vertical]="$4")
  tg_json_send "setGravity" tg__local_params
}

function tg_view_text_size() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [size]="$3")
  tg_json_send "setTextSize" tg__local_params
}

function tg_view_get_text() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "getText" tg__local_params
  tg_msg_recv | jq -r '.'
}

function tg_view_checked() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [checked]="$3")
  tg_json_send "setChecked" tg__local_params
}

function tg_view_request_focus() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [forcesoft]="$3")
  tg_json_send "requestFocus" tg__local_params
}

function tg_view_get_scroll() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "getScrollPosition" tg__local_params
  tg_msg_recv
}

function tg_view_set_scroll() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [x]="$3" [y]="$4")
  if [ -v "5" ]; then
    tg__local_params[soft]="$5"
  fi
  tg_json_send "setScrollPosition" tg__local_params
}

function tg_view_list() {
  declare -A tg_view_list_params=([aid]="$1" [id]="$2")
  local -n tg_view_list_list="$3"
  local tg_view_list_array="["
  for key in "${!tg_view_list_list[@]}"; do
    tg_view_list_array="${tg_view_list_array}$(tg_str_quote "${tg_view_list_list["$key"]}"),"
  done
  if [ "${#tg_view_list_list[@]}" ]; then
    tg_view_list_array="${tg_view_list_array::-1}]"
  else
    tg_view_list_array="$tg_view_list_array]"
  fi
  tg_view_list_params[list]="$tg_view_list_array"
  tg_json_send "setList" tg_view_list_params
}

function tg_view_image() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [img]='"'"$3"'"')
  tg_json_send "setImage" tg__local_params
}

function tg_view_select_tab() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [tab]="$3")
  tg_json_send "selectTab" tg__local_params
}

function tg_view_select_item() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [item]="$3")
  tg_json_send "selectItem" tg__local_params
}

function tg_view_clickable() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [clickable]="$3")
  tg_json_send "setClickable" tg__local_params
}














### REMOTE LAYOUTS, WIDGETS & NOTIFICATIONS

function tg_remote_create_layout() {
  declare -A tg__local_params=()
  tg_json_send "createRemoteLayout" tg__local_params
  tg_msg_recv
}

function tg_remote_delete_layout() {
  declare -A tg__local_params=([rid]="$1")
  tg_json_send "deleteRemoteLayout" tg__local_params
}

function tg_remote_create_frame() {
  declare -A tg__local_params=([rid]="$1")
  if [ -v "2" ]; then
    tg__local_params[parent]="$2"
  fi
  tg_json_send "addRemoteFrameLayout" tg__local_params
  tg_msg_recv
}

function tg_remote_create_text() {
  declare -A tg__local_params=([rid]="$1")
  if [ -v "2" ]; then
    tg__local_params[parent]="$2"
  fi
  tg_json_send "addRemoteTextView" tg__local_params
  tg_msg_recv
}

function tg_remote_create_button() {
  declare -A tg__local_params=([rid]="$1")
  if [ -v "2" ]; then
    tg__local_params[parent]="$2"
  fi
  tg_json_send "addRemoteButton" tg__local_params
  tg_msg_recv
}

function tg_remote_create_image() {
  declare -A tg__local_params=([rid]="$1")
  if [ -v "2" ]; then
    tg__local_params[parent]="$2"
  fi
  tg_json_send "addRemoteImageView" tg__local_params
  tg_msg_recv
}

function tg_remote_create_progress() {
  declare -A tg__local_params=([rid]="$1")
  if [ -v "2" ]; then
    tg__local_params[parent]="$2"
  fi
  tg_json_send "addRemoteProgressBar" tg__local_params
  tg_msg_recv
}

function tg_remote_bg_color() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setRemoteBackgroundColor" tg__local_params
}

function tg_remote_progress() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [progress]="$3" [max]=100)
  tg_json_send "setRemoteProgressBar" tg__local_params
}

function tg_remote_text() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [text]="$(tg_str_quote "$3")")
  tg_json_send "setRemoteText" tg__local_params
}

function tg_remote_text_size() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [size]="$3")
  if [ -v "4" ]; then
    tg__local_params[px]="$4"
  fi
  tg_json_send "setRemoteTextSize" tg__local_params
}

function tg_remote_text_color() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setRemoteTextColor" tg__local_params
}

function tg_remote_vis() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [vis]="$3")
  tg_json_send "setRemoteVisibility" tg__local_params
}

function tg_remote_padding() {
  declare -A tg__local_params=([rid]="$1" [id]="$2")
  if [ -v "3" ]; then
    tg__local_params[top]="$3"
  fi
  if [ -v "4" ]; then
    tg__local_params[right]="$4"
  fi
  if [ -v "5" ]; then
    tg__local_params[bottom]="$5"
  fi
  if [ -v "6" ]; then
    tg__local_params[left]="$6"
  fi
  tg_json_send "setRemotePadding" tg__local_params
}

function tg_remote_image() {
  declare -A tg__local_params=([rid]="$1" [id]="$2" [img]="$(tg_str_quote "$3")")
  tg_json_send "setRemoteImage" tg__local_params
}

function tg_widget_layout() {
  declare -A tg__local_params=([rid]="$1" [wid]="$2")
  tg_json_send "setWidgetLayout" tg__local_params
}

function tg_not_create_channel() {
  declare -A tg__local_params=([id]="$(tg_str_quote "$1")" [importance]="$2" [name]="$(tg_str_quote "$3")")
  tg_json_send "createNotificationChannel" tg__local_params
}

function tg_not_create() {
  declare -A tg__local_params=([channel]="$(tg_str_quote "$1")" [importance]="$2")
  # shellcheck disable=SC2034
  local -n tg_not_create_args="$3"
  tg__array_copy tg_not_create_args tg__local_params
  if [ -v "tg__local_params[title]" ]; then
    tg__local_params[title]="$(tg_str_quote "${tg__local_params[title]}")"
  fi
  if [ -v "tg__local_params[content]" ]; then
    tg__local_params[content]="$(tg_str_quote "${tg__local_params[content]}")"
  fi
  if [ -v "tg__local_params[largeImage]" ]; then
    tg__local_params[largeImage]="$(tg_str_quote "${tg__local_params[largeImage]}")"
  fi
  if [ -v "tg__local_params[largeText]" ]; then
    tg__local_params[largeText]="$(tg_str_quote "${tg__local_params[largeText]}")"
  fi
  if [ -v "tg__local_params[icon]" ]; then
    tg__local_params[icon]="$(tg_str_quote "${tg__local_params[icon]}")"
  fi
  if [ -v "3" ]; then
    local -n tg_not_create_actions="$3"
    local array="["
    for key in "${!tg_not_create_actions[@]}"; do
      array="${array}$(tg_str_quote "${tg_not_create_actions["$key"]}"),"
    done
    if [ "${#tg_not_create_actions[@]}" ]; then
      array="${array::-1}]"
    else
      array="$array]"
    fi
    tg__local_params[actions]="$array"
  fi
  tg_json_send "createNotification" tg__local_params
}

function tg_not_cancel() {
  declare -A tg__local_params=([id]="$1")
  tg_json_send "cancelNotification" tg__local_params
}

### EVENT CONTROL



function tg_event_send_click() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendClickEvent" tg__local_params
}

function tg_event_send_long_click() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendLongClickEvent" tg__local_params
}

function tg_event_send_focus() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendFocusChangeEvent" tg__local_params
}

function tg_event_send_touch() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendTouchEvent" tg__local_params
}

function tg_event_send_text() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendTextEvent" tg__local_params
}







### WEBVIEW

function tg_web_allow_js() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [allow]="$3")
  tg_json_send "allowJavascript" tg__local_params
}

function tg_web_allow_content() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [allow]="$3")
  tg_json_send "allowContentURI" tg__local_params
}

function tg_web_set_data() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [doc]="$(tg_str_quote "$3")")
  tg_json_send "setData" tg__local_params
}

function tg_web_load_uri() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [uri]="$(tg_str_quote "$3")")
  tg_json_send "loadURI" tg__local_params
}

function tg_web_allow_navigation() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [allow]="$3")
  tg_json_send "allowNavigation" tg__local_params
}

function tg_web_back() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "goBack" tg__local_params
}

function tg_web_forward() {
  declare -A tg__local_params=([aid]="$1" [id]="$2")
  tg_json_send "goForward" tg__local_params
}

function tg_web_eval_js() {
  declare -A tg__local_params=([aid]="$1" [id]="$2" [code]="$(tg_str_quote "$3")")
  tg_json_send "evaluateJS" tg__local_params
}



### EVENT HANDLING


function tg_event_type() {
  echo "$1" | jq -r '.type'
}

function tg_event_value() {
  echo "$1" | jq -r '.value'
}

function tg_event_aid() {
  echo "$1" | jq -r '.value.aid'
}

function tg_event_id() {
  echo "$1" | jq -r '.value.id'
}













### SETUP



# find helper binary
helper="@TERMUX_PREFIX@/libexec/termux-gui-bash-helper"

# generate random socket names
sock_main="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 60)"
sock_event="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 60)"

# shellcheck disable=SC2154
trap 'set +u; kill -9 $tg__main_PID >/dev/null 2>&1; kill -9 $tg__event_PID >/dev/null 2>&1' EXIT



# start listening on teh sockets
coproc tg__main { $helper --main "$sock_main" ; }

# redirect stderr, save it and restore it, to suppress the warning for running 2 coprocs
exec 3>&2 2>/dev/null

coproc tg__event { exec 2>&3 3>&- ; $helper "$sock_event" ; }

exec 2>&3 3>&-

# contact plugin
# use termux-am if available
if ! termux-am broadcast -n com.termux.gui/.GUIReceiver --es mainSocket "$sock_main" --es eventSocket "$sock_event" >/dev/null 2>&1; then
  am broadcast -n com.termux.gui/.GUIReceiver --es mainSocket "$sock_main" --es eventSocket "$sock_event" >/dev/null 2>&1
fi



# clear up variables
unset helper
unset am_command
unset sock_main
unset sock_event


# Run user script if not sourced
if ! (return 0 2>/dev/null); then
  # shellcheck disable=SC1090
  . "$@"
fi
