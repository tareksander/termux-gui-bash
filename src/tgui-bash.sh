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
  echo "jq not installed. pPlease install jq with 'pkg i jq'" >&2
  exit 1
fi





function tg__hex_to_dec() {
  echo "$((16#${1}))"
}





### CONSTANTS

declare -r tgc_actvivity_tid="tid"
# shellcheck disable=SC2034
declare -r tgc_actvivity_dialog="dialog"
# shellcheck disable=SC2034
declare -r tgc_actvivity_canceloutside="canceloutside"
# shellcheck disable=SC2034
declare -r tgc_actvivity_pip="pip"
# shellcheck disable=SC2034
declare -r tgc_actvivity_lockscreen="lockscreen"
# shellcheck disable=SC2034
declare -r tgc_actvivity_overlay="overlay"
# shellcheck disable=SC2034
declare -r tgc_actvivity_intercept="intercept"


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
  local tosend='{"method": "'"$1"'", "params": {'
  if [ "$2" != "" ]; then
    local -n tg_json_send_params="$2"
    if [ "${#tg_json_send_params[@]}" -ne 0 ]; then
      for key in "${!tg_json_send_params[@]}"; do
        tosend="${tosend}"'"'"$key"'":'"${tg_json_send_params[$key]},"
      done
      tosend=${tosend::-1}"}}"
    else
      tosend=${tosend}"}}"
    fi
  else
    tosend=${tosend}"}}"
  fi
  #echo "$tosend"
  tg_msg_send "$tosend"
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
  local rec
  rec="$(tg_msg_recv)"
  if [ ! -v "tg_activity_new_params[${tgc_actvivity_tid}]" ]; then
    tg_activity_new_ret[0]="$(echo "$rec" | jq -r '.[0]')"
    tg_activity_new_ret[1]="$(echo "$rec" | jq -r '.[1]')"
  else
    # shellcheck disable=SC2034
    tg_activity_new_ret[0]="$(echo "$rec" | jq -r '.')"
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
  declare -A params=([aid]="$1" [statusBarColor]="$(tg__hex_to_dec "$2")" [colorPrimary]="$(tg__hex_to_dec "$3")" [windowBackground]="$(tg__hex_to_dec "$4")" [textColor]="$(tg__hex_to_dec "$5")" [colorAccent]="$(tg__hex_to_dec "$6")")
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

function tg__create() {
  # shellcheck disable=SC2034
  local -n tg__create_args="$3"
  declare -A params=([aid]="$2")
  tg__array_copy tg__create_args params
  if [ -v "4" ]; then
    params[parent]="$4"
  fi
  if [ -v "5" ]; then
    params[visibility]="$5"
  fi
  if [ -v "params[text]" ]; then
    params[text]="$(tg_str_quote "${params[text]}")"
  fi
  if [ -v "params[type]" ]; then
    params[type]="$(tg_str_quote "${params[type]}")"
  fi
  tg_json_send "$1" params
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
  declare -A params=([aid]="$1" [id]="$2" [show]="$3")
  tg_json_send "showCursor" params
}

function tg_view_linear() {
  declare -A params=([aid]="$1" [id]="$2")
  if [ -v "3" ]; then
      params[weight]="$3"
    fi
  if [ -v "4" ]; then
    params[position]="$4"
  fi
  tg_json_send "setLinearLayoutParams" params
}

function tg_view_grid() {
  declare -A params=([aid]="$1" [id]="$2")
  if [ -v "3" ]; then
    params[row]="$3"
  fi
  if [ -v "4" ]; then
    params[col]="$4"
  fi
  if [ -v "5" ]; then
    params[rowsize]="$5"
  fi
  if [ -v "6" ]; then
    params[colsize]="$6"
  fi
  if [ -v "7" ]; then
    params[alignmentrow]="$(tg_str_quote "$7")"
  fi
  if [ -v "8" ]; then
    params[alignmentcol]="$(tg_str_quote "$8")"
  fi
  tg_json_send "setGridLayoutParams" params
}

function tg_view_location() {
  declare -A params=([aid]="$1" [id]="$2" [x]="$3" [y]="$4")
  if [ -v "5" ]; then
    params[dp]="$5"
    fi
  if [ -v "6" ]; then
    params[top]="$6"
  fi
  tg_json_send "setViewLocation" params
}

function tg_view_vis() {
  declare -A params=([aid]="$1" [id]="$2" [vis]="$3")
  tg_json_send "setVisibility" params
}

function tg_view_width() {
  declare -A params=([aid]="$1" [id]="$2" [width]="$3")
  if [ -v "4" ]; then
    params[px]="$4"
  fi
  tg_json_send "setWidth" params
}

function tg_view_height() {
  declare -A params=([aid]="$1" [id]="$2" [height]="$3")
  if [ -v "4" ]; then
    params[px]="$4"
  fi
  tg_json_send "setHeight" params
}

function tg_view_dimensions() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "getDimensions" params
  tg_msg_recv
}

function tg_view_delete() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "deleteView" params
}

function tg_view_delete_children() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "deleteChildren" params
}

function tg_view_margin() {
  declare -A params=([aid]="$1" [id]="$2" [margin]="$3")
  if [ -v "4" ]; then
    params[dir]="$(tg_str_quote "$4")"
  fi
  tg_json_send "setMargin" params
}

function tg_view_padding() {
  declare -A params=([aid]="$1" [id]="$2" [padding]="$3")
  if [ -v "4" ]; then
    params[dir]="$(tg_str_quote "$4")"
  fi
  tg_json_send "setPadding" params
}

function tg_view_bg_color() {
  declare -A params=([aid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setBackgroundColor" params
}

function tg_view_text_color() {
  declare -A params=([aid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setTextColor" params
}

function tg_view_progress() {
  declare -A params=([aid]="$1" [id]="$2" [progress]="$3")
  tg_json_send "setProgress" params
}

function tg_view_refreshing() {
  declare -A params=([aid]="$1" [id]="$2" [refresh]="$3")
  tg_json_send "setRefreshing" params
}

function tg_view_text() {
  declare -A params=([aid]="$1" [id]="$2" [text]="$(tg_str_quote "$3")")
  tg_json_send "setText" params
}

function tg_view_gravity() {
  declare -A params=([aid]="$1" [id]="$2" [horizontal]="$3" [vertical]="$4")
  tg_json_send "setGravity" params
}

function tg_view_text_size() {
  declare -A params=([aid]="$1" [id]="$2" [size]="$3")
  tg_json_send "setTextSize" params
}

function tg_view_get_text() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "getText" params
  tg_msg_recv | jq -r '.'
}

function tg_view_checked() {
  declare -A params=([aid]="$1" [id]="$2" [checked]="$3")
  tg_json_send "setChecked" params
}

function tg_view_request_focus() {
  declare -A params=([aid]="$1" [id]="$2" [forcesoft]="$3")
  tg_json_send "requestFocus" params
}

function tg_view_get_scroll() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "getScrollPosition" params
  tg_msg_recv
}

function tg_view_set_scroll() {
  declare -A params=([aid]="$1" [id]="$2" [x]="$3" [y]="$4")
  if [ -v "5" ]; then
    params[soft]="$5"
  fi
  tg_json_send "setScrollPosition" params
}

function tg_view_list() {
  declare -A params=([aid]="$1" [id]="$2")
  local -n tg_view_list_list="$3"
  local array="["
  for key in "${!tg_view_list_list[@]}"; do
    array="${array}$(tg_str_quote "${tg_view_list_list["$key"]}"),"
  done
  if [ "${!tg_view_list_list[@]}" ]; then
    array="${array::-1}]"
  else
    array="$array]"
  fi
  params[list]="$array"
  tg_json_send "setList" params
}

function tg_view_image() {
  declare -A params=([aid]="$1" [id]="$2" [img]='"'"$3"'"')
  tg_json_send "setImage" params
}

function tg_view_select_tab() {
  declare -A params=([aid]="$1" [id]="$2" [tab]="$3")
  tg_json_send "selectTab" params
}

function tg_view_select_item() {
  declare -A params=([aid]="$1" [id]="$2" [item]="$3")
  tg_json_send "selectItem" params
}

function tg_view_clickable() {
  declare -A params=([aid]="$1" [id]="$2" [clickable]="$3")
  tg_json_send "setClickable" params
}














### REMOTE LAYOUTS, WIDGETS & NOTIFICATIONS

function tg_remote_create_layout() {
  declare -A params=()
  tg_json_send "createRemoteLayout" params
  tg_msg_recv
}

function tg_remote_delete_layout() {
  declare -A params=([rid]="$1")
  tg_json_send "deleteRemoteLayout" params
}

function tg_remote_create_frame() {
  declare -A params=([rid]="$1")
  if [ -v "2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "addRemoteFrameLayout" params
  tg_msg_recv
}

function tg_remote_create_text() {
  declare -A params=([rid]="$1")
  if [ -v "2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "addRemoteTextView" params
  tg_msg_recv
}

function tg_remote_create_button() {
  declare -A params=([rid]="$1")
  if [ -v "2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "addRemoteButton" params
  tg_msg_recv
}

function tg_remote_create_image() {
  declare -A params=([rid]="$1")
  if [ -v "2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "addRemoteImageView" params
  tg_msg_recv
}

function tg_remote_create_progress() {
  declare -A params=([rid]="$1")
  if [ -v "2" ]; then
    params[parent]="$2"
  fi
  tg_json_send "addRemoteProgressBar" params
  tg_msg_recv
}

function tg_remote_bg_color() {
  declare -A params=([rid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setRemoteBackgroundColor" params
}

function tg_remote_progress() {
  declare -A params=([rid]="$1" [id]="$2" [progress]="$3" [max]=100)
  tg_json_send "setRemoteProgressBar" params
}

function tg_remote_text() {
  declare -A params=([rid]="$1" [id]="$2" [text]="$(tg_str_quote "$3")")
  tg_json_send "setRemoteText" params
}

function tg_remote_text_size() {
  declare -A params=([rid]="$1" [id]="$2" [size]="$3")
  if [ -v "4" ]; then
    params[px]="$4"
  fi
  tg_json_send "setRemoteTextSize" params
}

function tg_remote_text_color() {
  declare -A params=([rid]="$1" [id]="$2" [color]="$(tg__hex_to_dec "$3")")
  tg_json_send "setRemoteTextColor" params
}

function tg_remote_vis() {
  declare -A params=([rid]="$1" [id]="$2" [vis]="$3")
  tg_json_send "setRemoteVisibility" params
}

function tg_remote_padding() {
  declare -A params=([rid]="$1" [id]="$2")
  if [ -v "3" ]; then
    params[top]="$3"
  fi
  if [ -v "4" ]; then
    params[right]="$4"
  fi
  if [ -v "5" ]; then
    params[bottom]="$5"
  fi
  if [ -v "6" ]; then
    params[left]="$6"
  fi
  tg_json_send "setRemotePadding" params
}

function tg_remote_image() {
  declare -A params=([rid]="$1" [id]="$2" [img]="$(tg_str_quote "$3")")
  tg_json_send "setRemoteImage" params
}

function tg_widget_layout() {
  declare -A params=([rid]="$1" [wid]="$2")
  tg_json_send "setWidgetLayout" params
}

function tg_not_create_channel() {
  declare -A params=([id]="$(tg_str_quote "$1")" [importance]="$2" [name]="$(tg_str_quote "$3")")
  tg_json_send "createNotificationChannel" params
}

function tg_not_create() {
  declare -A params=([channel]="$(tg_str_quote "$1")" [importance]="$2")
  # shellcheck disable=SC2034
  local -n tg_not_create_args="$3"
  tg__array_copy tg_not_create_args params
  if [ -v "params[title]" ]; then
    params[title]="$(tg_str_quote "${params[title]}")"
  fi
  if [ -v "params[content]" ]; then
    params[content]="$(tg_str_quote "${params[content]}")"
  fi
  if [ -v "params[largeImage]" ]; then
    params[largeImage]="$(tg_str_quote "${params[largeImage]}")"
  fi
  if [ -v "params[largeText]" ]; then
    params[largeText]="$(tg_str_quote "${params[largeText]}")"
  fi
  if [ -v "params[icon]" ]; then
    params[icon]="$(tg_str_quote "${params[icon]}")"
  fi
  if [ -v "3" ]; then
    local -n tg_not_create_actions="$3"
    local array="["
    for key in "${!tg_not_create_actions[@]}"; do
      array="${array}$(tg_str_quote "${tg_not_create_actions["$key"]}"),"
    done
    if [ "${!tg_not_create_actions[@]}" ]; then
      array="${array::-1}]"
    else
      array="$array]"
    fi
    params[actions]="$array"
  fi
  tg_json_send "createNotification" params
}

function tg_not_cancel() {
  declare -A params=([id]="$1")
  tg_json_send "cancelNotification" params
}

### EVENT CONTROL



function tg_event_send_click() {
  declare -A params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendClickEvent" params
}

function tg_event_send_long_click() {
  declare -A params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendLongClickEvent" params
}

function tg_event_send_focus() {
  declare -A params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendFocusChangeEvent" params
}

function tg_event_send_touch() {
  declare -A params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendTouchEvent" params
}

function tg_event_send_text() {
  declare -A params=([aid]="$1" [id]="$2" [send]="$3")
  tg_json_send "sendTextEvent" params
}







### WEBVIEW

function tg_web_allow_js() {
  declare -A params=([aid]="$1" [id]="$2" [allow]="$3")
  tg_json_send "allowJavascript" params
}

function tg_web_allow_content() {
  declare -A params=([aid]="$1" [id]="$2" [allow]="$3")
  tg_json_send "allowContentURI" params
}

function tg_web_set_data() {
  declare -A params=([aid]="$1" [id]="$2" [doc]="$(tg_str_quote "$3")")
  tg_json_send "setData" params
}

function tg_web_load_uri() {
  declare -A params=([aid]="$1" [id]="$2" [uri]="$(tg_str_quote "$3")")
  tg_json_send "loadURI" params
}

function tg_web_allow_navigation() {
  declare -A params=([aid]="$1" [id]="$2" [allow]="$3")
  tg_json_send "allowNavigation" params
}

function tg_web_back() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "goBack" params
}

function tg_web_forward() {
  declare -A params=([aid]="$1" [id]="$2")
  tg_json_send "goForward" params
}

function tg_web_eval_js() {
  declare -A params=([aid]="$1" [id]="$2" [code]="$(tg_str_quote "$3")")
  tg_json_send "evaluateJS" params
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
  . "$@"
fi
