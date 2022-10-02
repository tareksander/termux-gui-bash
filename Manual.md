## Name
**tgui-bash** - Termux:GUI in bash

## Synopsis
**tgui-bash** *filepath* ...  
**tgui-bash** -h ...  
source **tgui-bash**

## Description
Sets up a connection to the Termux:GUI plugin through a small C helper, defines functions to interact with the plugin and finally sources the parameter into the script, so the functions are available.  
  
Can be used in a shebang (`#!/bin/tgui-bash`) or sourced.
  
Using `set -eo pipefail` is advised to make your script exit when the connection to the plugin gets broken.
For development, you should use `set -u` to make sure you spelled the constant names correctly.

This library also uses the EXIT trap handler, so make sure to just add to it, but not overwrite it.

## Options
`-h` Shows this manual or the tutorial in a browser of your choice. The following positional arguments are taken as answers to the questions.


## Environment
All environment variables that affect bash will affect this program.


## Functions

For passing arrays to functions and returning arrays, [bash namerefs](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) are used.  
Reference parameters are marked with & and accept a variable name.  
Colors are specified in RGBA in hex with `aabbggrr`.  
Boolean values use the literal text `true` and `false`, as they are directly used for the JSON messages to the plugin.  
Images should be in PNG or JPEG format and base64 encoded (`base64 -w 0 file` or `image_generating_command | base64 -w 0`).
Public functions and variables start with `tg_`, private functions and variables with `tg__`.  
Private functions and variables can change between versions, public ones should be stable.

  
More documentation for the functions as defined in the protocol is available [here](https://github.com/termux/termux-gui/blob/main/Protocol.md#protocol-methods).




### Global Functions



| Name                       | Description                                                 | Parameters | Return code               |
|----------------------------|-------------------------------------------------------------|------------|---------------------------|
| tg_global_turn_screen_on   | Turns the screen on.                                        |            |                           |
| tg_global_is_locked        | Returns whether the screen is locked.                       |            | 0: locked<br/>1: unlocked |
| tg_global_version          | Returns the version code of the plugin to stdout.           |            |                           |
| tg_msg_recv_event          | Returns an event if one is available, else an empty string. |            |                           |
| tg_msg_recv_event_blocking | Waits for an event and returns it.                          |            |                           |





### Activity Functions


| Name                              | Description                                                                                                                              | Parameters                                                                                                                                                                                                      |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| tg_activity_new                   | Creates a new Activity. See the `tgc_activity_*` constants for keys and their effect.                                                    | <ol><li>& Options associative array. See the constants for keys.</li><li>& Return array. \[0] will contain the Activity id, \[1] will contain the Task id (if the Task id wasn't given as an option).</li></ol> |
| tg_activity_finish                | Finishes an Activity.                                                                                                                    | The Activity id of the Activity.                                                                                                                                                                                |
| tg_activity_to_back               | Moves the Task of an Activity to the back.                                                                                               | The Activity id of the Activity.                                                                                                                                                                                |
| tg_activity_theme                 | Sets the theme of the Activity.                                                                                                          | <ol><li>The Activity id of the Activity.</li><li>The status bar color.</li><li>The primary color.</li><li>The window background color.</li><li>The text color.</li><li>The accent color</li></ol>               |
| tg_activity_description           | Sets the Task description and icon.                                                                                                      | <ol><li>The Activity id of the Activity.</li><li>The description (appears unused).</li><li>The icon.</li></ol>                                                                                                  |
| tg_activity_pip_params            | Sets the aspect ratio for picture-in-picture mode.                                                                                       | <ol><li>The Activity id of the Activity.</li><li>The numerator of the aspect ratio.</li><li>The denominator of the aspect ratio.</li></ol>                                                                      |
| tg_activity_input                 | Sets how the Activity responds to the soft keyboard. "resize" resizes the Activity to fit the keyboard, "pan", pans the Activity upward. | <ol><li>The Activity id of the Activity.</li><li>The response option.</li></ol>                                                                                                                                 |
| tg_activity_pip                   | Makes an Activity enter or leave picture-in-picture-mode.                                                                                | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether the Activity should be in pip or not.</li></ol>                                                                                               |
| tg_activity_pip_auto              | Set if an Activity should go into pip automatically if the user leaves.                                                                  | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether the Activity should go into pip automatically or not.</li></ol>                                                                               |
| tg_activity_keep_screen_on        | Sets if showing the Activity should keep the screen from turning off.                                                                    | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether screen should be kept on.</li></ol>                                                                                                           |
| tg_activity_orientation           | Sets the Orientation of the Activity.                                                                                                    | <ol><li>The Activity id of the Activity.</li><li>Orientation. Please see table ["Android Activity Orientation Table"](#android-activity-orientation-table) below for values.</li></ol>                          |
| tg_activity_position              | Sets the screen position for an overlay Activity.                                                                                        | <ol><li>The Activity id of the Activity.</li><li>The x position.</li><li>The y position.</li></ol>                                                                                                              |
| tg_activity_configuration         | Gets the configuration for the Activity as a string. Get the values with the `tg_configuration_*` functions.                             | <ol><li>The Activity id of the Activity.</li></ol>                                                                                                                                                              |
| tg_activity_request_unlock        | Requests the user to unlock the screen or unlocks it if the screen isn't protected.                                                      | <ol><li>The Activity id of the Activity.</li></ol>                                                                                                                                                              |
| tg_activity_hide_soft_keyboard    | Hides the software keyboard.                                                                                                             | <ol><li>The Activity id of the Activity.</li></ol>                                                                                                                                                              |
| tg_activity_intercept_back_button | Sets whether the back button should be intercepted. See the constant `tg_actvivity_intercept` fro more information.                      | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether to intercept the back button.</li></ol>                                                                                                       |




### Task Functions



| Name             | Description                             | Parameters   |
|------------------|-----------------------------------------|--------------|
| tg_task_finish   | Finishes all activites in a Task.       | The Task id. |
| tg_task_to_front | Makes a Task visible to the user again. | The Task id. |



### Configuration Functions

These functions all get the configuration string as the first parameter.

| Name                            | Description                                                                              |
|---------------------------------|------------------------------------------------------------------------------------------|
| tg_configuration_dark_mode      | Whether dark mode is enabled, "true" or "false". "null" on Android versions prior to 10. |
| tg_configuration_country        | The country as a 2-letter string.                                                        |
| tg_configuration_language       | The language as a 2-letter string.                                                       |
| tg_configuration_orientation    | The screen orientation, either "landscape" or "portrait".                                |
| tg_configuration_keyboardHidden | Whether a keyboard is currently available, as the string "true" or "false".              |
| tg_configuration_screenwidth    | The current window width in dp.                                                          |
| tg_configuration_screenheight   | The current window height in dp.                                                         |
| tg_configuration_fontscale      | The current font scale value as a floating point number.                                 |
| tg_configuration_density        | The display density as a float, such that screenwidth * density = screenwidth_in_px.     |



### View Creation Functions

All functions take the Activity id as the first parameter and
a parameter associative array reference as the second parameter.  
The third parameter is an optional parent view id.  
For root Views, specify `""` as the third parameter or leave it out.  
The fourth parameter is the optional initial visibility of the View.  
The id of the created View is returned on stdout.  
The key for the parameter array are listed under the constants under `tgc_create_*`.


| Name                        | Description                     |
|-----------------------------|---------------------------------|
| tg_create_linear            | Creates a LinearLayout.         |
| tg_create_frame             | Creates a FrameLayout.          |
| tg_create_swipe_refresh     | Creates a SwipeRefreshLayout.   |
| tg_create_text              | Creates a TextView.             |
| tg_create_edit              | Creates an EditText.            |
| tg_create_button            | Creates a Button.               |
| tg_create_image             | Creates an ImageView.           |
| tg_create_space             | Creates a Space.                |
| tg_create_nested_scroll     | Creates a NestedScrollView.     |
| tg_create_horizontal_scroll | Creates a HorizontalScrollView. |
| tg_create_radio             | Creates a RadioButton.          |
| tg_create_radio_group       | Creates a RadioGroup.           |
| tg_create_checkbox          | Creates a Checkbox.             |
| tg_create_toggle            | Creates a ToggleButton.         |
| tg_create_switch            | Creates a Switch.               |
| tg_create_spinner           | Creates a Spinner.              |
| tg_create_progress          | Creates a ProgressBar.          |
| tg_create_tab               | Creates a TabLayout.            |
| tg_create_grid              | Creates a GridLayout.           |
| tg_create_web               | Creates a WebView.              |



### View Functions

All these functions get the Activity id and the View id as the first and second parameters respectively.


| Name                    | Description                                                                                                                                               | Parameters                                                                                                                                                                                                                                                                                |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| tg_view_show_cursor     | Sets whether or not a cursor is shown in an EditText.                                                                                                     | <ol start="3"><li>Boolean. Whether to show the cursor or not.</li></ol>                                                                                                                                                                                                                   |
| tg_view_linear          | Sets the LinearLayout parameters for a View in a LinearLayout.                                                                                            | <ol start="3"><li>The weight of the View.</li><li>The position of the View.</li></ol>                                                                                                                                                                                                     |
| tg_view_grid            | Sets the GridLayout parameters for a View in a GridLayout.                                                                                                | <ol start="3"><li>The starting row of the View.</li><li>The starting column of the View.</li><li>The amount of rows this View uses.</li><li>The amount of columns this View uses</li><li>The alignment of the View in the row.</li><li>The alignment of the View in the column.</li></ol> |
| tg_view_location        | Sets position of a View.                                                                                                                                  | <ol start="3"><li>The x position.</li><li>The y position</li><li>Whether to position is in dp or not.</li><li>Whether the View should be on top of al others.</li></ol>                                                                                                                   |
| tg_view_vis             | Sets the visibility of a Vew.                                                                                                                             | <ol start="3"><li>The visibility of the View.</li></ol>                                                                                                                                                                                                                                   |
| tg_view_width           | Sets the width of the view.                                                                                                                               | <ol start="3"><li>The width of the View.</li><li>Whether the width is in px or not.</li></ol>                                                                                                                                                                                             |
| tg_view_height          | Sets the height of the view.                                                                                                                              | <ol start="3"><li>The height of the View.</li><li>Whether the height is in px or not.</li></ol>                                                                                                                                                                                           |
| tg_view_dimensions      | Gets the current with and height of a View in pixels.                                                                                                     |                                                                                                                                                                                                                                                                                           |
| tg_view_delete          | Deletes a View and its children from the Layout hierarchy.                                                                                                |                                                                                                                                                                                                                                                                                           |
| tg_view_delete_children | Deletes the children of a View from the Layout hierarchy.                                                                                                 |                                                                                                                                                                                                                                                                                           |
| tg_view_margin          | Sets the margin of a View.                                                                                                                                | <ol start="3"><li>The margin in dp.</li><li>The direction of the margin. Leave empty for all directions.</li></ol>                                                                                                                                                                        |
| tg_view_padding         | Sets the padding of a View.                                                                                                                               | <ol start="3"><li>The padding in dp.</li><li>The direction of the padding. Leave empty for all directions.</li></ol>                                                                                                                                                                      |
| tg_view_bg_color        | Sets the background color of a View.                                                                                                                      | <ol start="3"><li>The color.</li></ol>                                                                                                                                                                                                                                                    |
| tg_view_text_color      | Sets the text color of a View.                                                                                                                            | <ol start="3"><li>The color</li></ol>                                                                                                                                                                                                                                                     |
| tg_view_progress        | Sets the progress of a ProgressBar.                                                                                                                       | <ol start="3"><li>The progress in range from 0 to 100.</li></ol>                                                                                                                                                                                                                          |
| tg_view_refreshing      | Sets whether a SwipeRefreshLayout is refreshing.                                                                                                          | <ol start="3"><li>Whether the SwipeRefreshLayout is refreshing.</li></ol>                                                                                                                                                                                                                 |
| tg_view_text            | Sets the text of the View.                                                                                                                                | <ol start="3"><li>The text.</li></ol>                                                                                                                                                                                                                                                     |
| tg_view_gravity         | Sets the gravity of the text of the View.                                                                                                                 | <ol start="3"><li>The horizontal gravity.</li><li>The vertical gravity</li></ol>                                                                                                                                                                                                          |
| tg_view_text_size       | Sets the text size.                                                                                                                                       | <ol start="3"><li>The text size in sp.</li></ol>                                                                                                                                                                                                                                          |
| tg_view_get_text        | gets the text of the View.                                                                                                                                |                                                                                                                                                                                                                                                                                           |
| tg_view_checked         | Sets a RadioButton, CheckBox, Switch or ToggleButton to checked or unchecked explicitly.                                                                  | <ol start="3"><li>Whether the View is checked.</li></ol>                                                                                                                                                                                                                                  |
| tg_view_request_focus   | Focuses a View and opens the soft keyboard if the View has Keyboard input.                                                                                | <ol start="3"><li>Whether the soft keyboard should be forced to open.</li></ol>                                                                                                                                                                                                           |
| tg_view_get_scroll      | Gets the x and y scroll position of an NestedScrollView or HorizontalScrollView.                                                                          |                                                                                                                                                                                                                                                                                           |
| tg_view_set_scroll      | Sets the x and y scroll position of an NestedScrollView or HorizontalScrollView.                                                                          | <ol start="3"><li>The x scroll position.</li><li>The y scroll position.</li><li>Whether the srcoll should be smooth.</li></ol>                                                                                                                                                            |
| tg_view_list            | Set the list of a Spinner or TabLayout.                                                                                                                   | <ol start="3"><li>& The array of tab/item names.</li></ol>                                                                                                                                                                                                                                |
| tg_view_image           | Sets the image for an ImageView.                                                                                                                          | <ol start="3"><li>The image as a base64 encoded string.</li></ol>                                                                                                                                                                                                                         |
| tg_view_select_tab      | Selects a Tab in a TabLayout. The corresponding itemselected event is also send.                                                                          | <ol start="3"><li>The tab index, starting from 0.</li></ol>                                                                                                                                                                                                                               |
| tg_view_select_item     | Selects a item in a Spinner. The corresponding itemselected event is also send.                                                                           | <ol start="3"><li>The item index, starting from 0.</li></ol>                                                                                                                                                                                                                              |
| tg_view_clickable       | Sets whether a View can be clicked by the user (if yes, emits a sound and animation when clicked and sends a click event (if click events are enabled))). | <ol start="3"><li>Whether the View should be clickable.</li></ol>                                                                                                                                                                                                                         |


### Remote Layout, Widget & Notification Functions



| Name                      | Description                                                                                           | Parameters                                                                                                                          |
|---------------------------|-------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|
| tg_remote_create_layout   | Creates a new remote Layout. Returns the id for the remote Layout                                     |                                                                                                                                     |
| tg_remote_delete_layout   | Deletes a remote Layout.                                                                              | <ol><li>The id of the Layout to delete.</li></ol>                                                                                   |
| tg_remote_create_frame    | Creates a FrameLayout in a remote Layout. Returns the View id in the Layout.                          | <ol><li>The id of the Layout.</li><li>Optional. The parent if for the View.</li></ol>                                               |
| tg_remote_create_text     | Creates a TextView in a remote Layout. Returns the View id in the Layout.                             | <ol><li>The id of the Layout.</li><li>Optional. The parent if for the View.</li></ol>                                               |
| tg_remote_create_button   | Creates a Button in a remote Layout. Returns the View id in the Layout.                               | <ol><li>The id of the Layout.</li><li>Optional. The parent if for the View.</li></ol>                                               |
| tg_remote_create_image    | Creates an ImageView in a remote Layout. Returns the View id in the Layout.                           | <ol><li>The id of the Layout.</li><li>Optional. The parent if for the View.</li></ol>                                               |
| tg_remote_create_progress | Creates a ProgressBar in a remote Layout. Returns the View id in the Layout.                          | <ol><li>The id of the Layout.</li><li>Optional. The parent if for the View.</li></ol>                                               |
| tg_remote_bg_color        | Sets the background color for a View in a remote Layout.                                              | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The background color.</li></ol>                                   |
| tg_remote_progress        | Sets values for a ProgressBar in a remote Layout.                                                     | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The progress between 0 and 100.</li></ol>                         |
| tg_remote_text            | Sets the text of a remote View.                                                                       | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The text.</li></ol>                                               |
| tg_remote_text_size       | Sets the text size of a remote View.                                                                  | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The text size.</li></ol>                                          |
| tg_remote_text_color      | Sets the Text color for a View in a remote Layout.                                                    | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The text color.</li></ol>                                         |
| tg_remote_vis             | Sets the visibility for a View in a remote Layout.                                                    | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The View visibility.</li></ol>                                    |
| tg_remote_padding         | Sets the padding in pixels for a View in a remote Layout.                                             | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The padding.</li></ol>                                            |
| tg_remote_image           | Sets the image of a remote ImageView.                                                                 | <ol><li>The id of the Layout.</li><li>The id of the View.</li><li>The image.</li></ol>                                              |
| tg_widget_layout          | Sets the layout of a Widget to a remote Layout.                                                       | <ol><li>The id of the Layout.</li><li>The id of the Widget.</li></ol>                                                               |
| tg_not_create_channel     | On Android 8.0 and higher this creates a NotificationChannel, if one with the given id doesn't exist. | <ol><li>The id string of the channel.</li><li>The importance of the channel.</li><li>The user-visible name.</li></ol>               |
| tg_not_create             | Creates a notification. Returns the notification id used for further calls.                           | <ol><li>The channel id.</li><li>The notification importance</li><li>& The parameter array. See the `tgc_not_*` constants.</li></ol> |
| tg_not_cancel             | Cancels a notification.                                                                               | <ol><li>The id of the Notification to cancel.</li></ol>                                                                             |



### Event Functions

These functions change whether specific events are send for Views.  
The first parameter is the Activity id of the View, the second the id of the View
and the third is the boolean for whether to send the event or not.

| Name                     |
|--------------------------|
| tg_event_send_click      |
| tg_event_send_long_click |
| tg_event_send_focus      |
| tg_event_send_touch      |
| tg_event_send_text       |


### Event Parsing Functions

Events are send as JSON, and are thus not usable directly in Bash.  
That's where the dependency on `jq` comes in: it is used to parse the events.  
You can use `jq` on the event data directly, but for some common tasks there are utility functions.  
They all get the event data as their only parameter.  
For more information about events, see [the protocol specification](https://github.com/termux/termux-gui/blob/main/Protocol.md#events).

| Name           | Description                                                                                    |
|----------------|------------------------------------------------------------------------------------------------|
| tg_event_type  | Returns the event type, which can then be compared to one of the `tgc_ev_*` constants.         |
| tg_event_value | Returns the event value, which is a JSON object for some events and a direct value for others. |
| tg_event_aid   | Returns the Activity id of the event, or "null" if not present.                                |
| tg_event_id    | Returns the View id of the event, or "null" if not present.                                    |

### WebView Functions

All these functions get the Activity id and the View id as the first and second parameters respectively.

| Name                    | Description                                                        | Parameters                                                   |
|-------------------------|--------------------------------------------------------------------|--------------------------------------------------------------|
| tg_web_allow_js         | Sets whether Javascript is allowed to run in the WebView.          | <ol start="3"><li>Boolean.Whether to allow or not.</li></ol> |
| tg_web_allow_content    | Sets whether content URIs are allowed in the WebView.              | <ol start="3"><li>Boolean.Whether to allow or not.</li></ol> |
| tg_web_set_data         | Sets the document.                                                 | <ol start="3"><li>The data.</li></ol>                        |
| tg_web_load_uri         | Loads a specific URI.                                              | <ol start="3"><li>The URI.</li></ol>                         |
| tg_web_allow_navigation | Sets whether user/Javascript navigation is allowed in the WebView. | <ol start="3"><li>Boolean.Whether to allow or not.</li></ol> |
| tg_web_back             | Goes back in the history.                                          |                                                              |
| tg_web_forward          | Goes forward in the history.                                       |                                                              |
| tg_web_eval_js          | Runs Javascript.                                                   | <ol start="3"><li>The Javascript.</li></ol>                  |

## Constants



#### tgc_actvivity_tid="tid"
Key for the `tg_activity_new` options array. The value is a number.
Specify a Task id here if you want Activities to launch over each other in the same Task.

#### tgc_actvivity_dialog="dialog"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to make the Activity a dialog.

#### tgc_actvivity_canceloutside="canceloutside"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to false if you want your dialog to not be dismissed when the user taps on something else.

#### tgc_actvivity_pip="pip"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to let the Activity start in picture-in-picture mode.

#### tgc_actvivity_lockscreen="lockscreen"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to make the Activity stay visible and interactable on the lockscreen.
Make sure your interface is secure in this case, to not allow arbitrary command execution or file I/O.

#### tgc_actvivity_overlay="overlay"
Key for the `tg_activity_new` options array. The value is a boolean.
This launches the Activity as an overlay over everything else, similar to picture-in-picture mode, but you can interact with all Views.

#### tgc_actvivity_intercept="intercept"
Key for the `tg_activity_new` options array. The value is a boolean.
This option makes the back button send an event instead of finishing the Activity.


#### tgc_create_text="text"
Key for the `tg_create_*` parameter array.  
For Button, TextView and EditText, this is the initial Text.

#### tgc_create_selectable_text="selectableText"

Key for the `tg_create_*` parameter array.  
For TextViews, this specifies whether the text can be selected. Default is false.

#### tgc_create_clickable_links="clickableLinks"

Key for the `tg_create_*` parameter array.  
For TextViews, this specifies whether links can be clicked or not. Default is false.

#### tgc_create_vertical="vertical"

Key for the `tg_create_*` parameter array.  
For LinearLayout, this specifies if the Layout is vertical or horizontal.  
If not specified, vertical is assumed.

#### tgc_create_snapping="snapping"

Key for the `tg_create_*` parameter array.  
NestedScrollView and HorizontalScrollView snap to the nearest item if this is set to true.  
Default is false.

#### tgc_create_fill_viewport="fillviewport"

Key for the `tg_create_*` parameter array.  
Makes the child of a HorizontalScrollView or a NestedScrollView automatically expand to the ScrollView size.  
Default is false.

#### tgc_create_no_bar="nobar"

Key for the `tg_create_*` parameter array.  
Hides the scroll bar for HorizontalScrollView and NestedScrollView.  
Default is false.

#### tgc_create_checked="checked"

Key for the `tg_create_*` parameter array.  
Whether a RadioButton, CheckBox, Switch or ToggleButton should be checked.  
Defaults to false.

#### tgc_create_single_line="singleline"

Key for the `tg_create_*` parameter array.  
Whether an EditText should enable multiple lines to be entered.

#### tgc_create_line="line"

Key for the `tg_create_*` parameter array.  
Whether the line below an EditText should be shown.

#### tgc_create_type="type"

Key for the `tg_create_*` parameter array.  
For EditText this specifies the [input type](https://developer.android.com/reference/android/widget/TextView#attr_android:inputType): can be one of "text", "textMultiLine", "phone", "date", "time", "datetime", "number", "numberDecimal", "numberPassword", "numberSigned", "numberDecimalSigned", "textEmailAddress", "textPassword". "text" is the default. Specifying singleline as true sets this to "text".

#### tgc_create_rows="rows"

Key for the `tg_create_*` parameter array.  
Row count for GridLayout.

#### tgc_create_cols="cols"

Key for the `tg_create_*` parameter array.  
Column count for GridLayout.

#### tgc_create_all_caps="allcaps"

Key for the `tg_create_*` parameter array.  
Use this when creating a button to make all text automatically all caps (using small caps if possible).

#### tgc_vis_gone="0"

Visibility constant for Views. This makes Views invisible and take up no space in the Layout.

#### tgc_vis_visible="2"

Visibility constant for Views. This makes Views visible.
#### tgc_vis_hidden="1"

Visibility constant for Views. This makes Views invisible, but still take up space in the Layout.

#### tgc_view_wrap_content='"WRAP_CONTENT"'

Size constant for Views. This makes Views take as much space as needed for their content.

#### tgc_view_match_parent='"MATCH_PARENT"'

Size constant for Views. This makes Views take as much space as their parent.

#### tgc_grid_top="top"

Alignment for Views in GridLayout.

#### tgc_grid_bottom="bottom"

Alignment for Views in GridLayout.

#### tgc_grid_left="left"

Alignment for Views in GridLayout.

#### tgc_grid_right="right"

Alignment for Views in GridLayout.

#### tgc_grid_center="center"

Alignment for Views in GridLayout.

#### tgc_grid_baseline="baseline"

Alignment for Views in GridLayout.

#### tgc_grid_fill="fill"

Alignment for Views in GridLayout.

#### tgc_dir_top="top"

Direction constant.

#### tgc_dir_bottom="bottom"

Direction constant.

#### tgc_dir_left="left"

Direction constant.

#### tgc_dir_right="right"

Direction constant.

#### tgc_grav_top_left="0"

Text gravity constant. This makes text gravitate to the top/left.

#### tgc_grav_center="1"

Text gravity constant. This makes text gravitate to the center.

#### tgc_grav_bottom_right="2"

Text gravity constant. This makes text gravitate to the bottom/right.

#### tgc_not_id="id"

Key for the `tg_not_create` parameter array.  
The id of the notification to update. If not specified, generates a new id.

#### tgc_not_ongoing="ongoing"

Key for the `tg_not_create` parameter array.  
If true, the notification cannot be dismissed by the user,
but the notification is automatically dismissed when you close the connection to the plugin.

#### tgc_not_layout="layout"

Key for the `tg_not_create` parameter array.  
The id of the remote Layout to use.

#### tgc_not_expanded_layout="expandedLayout"

Key for the `tg_not_create` parameter array.  
The id of the remote Layout to use when the notification has been expanded.

#### tgc_not_hud_layout="hudLayout"

Key for the `tg_not_create` parameter array.
The id of the remote Layout to use when the notification is shown as a head-up notification.

#### tgc_not_title="title"

Key for the `tg_not_create` parameter array.
The notification title.

#### tgc_not_content="content"

Key for the `tg_not_create` parameter array.
The notification content text.

#### tgc_not_large_image="largeImage"

Key for the `tg_not_create` parameter array.
A large image to display in the expanded view. You can only set either largeImage or largeText.

#### tgc_not_large_text="largeText"

Key for the `tg_not_create` parameter array.
A large block of text to display in the expanded view. HTML formatting is supported.
You can only set either largeImage or largeText.

#### tgc_not_large_image_thumbnail="largeImageAsThumbnail"

Key for the `tg_not_create` parameter array.
If true, the largeImage is shown as a thumbnail in the collapsed view.

#### tgc_not_icon="icon"

Key for the `tg_not_create` parameter array.
An image for the Notification in PNG or JPEG.
Defaults to the Termux:GUI app icon if left empty.

#### tgc_not_alert_once="alertOnce"

Key for the `tg_not_create` parameter array.
If this call is used to update a notification, don't alert the user again.

#### tgc_not_show_timestamp="showTimestamp"

Key for the `tg_not_create` parameter array.
Shows the timestamp of the notification.

#### tgc_not_timestamp="timestamp"

Key for the `tg_not_create` parameter array.
The timestamp to use in form of milliseconds since start of the epoch.

#### tgc_not_actions="actions"

Key for the `tg_not_create` parameter array.
An array of strings with the names of actions.
Pressing actions will generate a notificationaction event.

### Event Constants

For more information about events, see [the protocol specification](https://github.com/termux/termux-gui/blob/main/Protocol.md#events).

#### tgc_ev_click="click"


#### tgc_ev_long_click="longClick"


#### tgc_ev_focus_change="focusChange"


#### tgc_ev_refresh="refresh"


#### tgc_ev_selected="selected"


#### tgc_ev_item_selected="itemselected"


#### tgc_ev_text="text"


#### tgc_ev_back="back"


#### tgc_ev_webview_navigation="webviewNavigation"


#### tgc_ev_webview_http_error="webviewHTTPError"


#### tgc_ev_webview_error="webviewError"


#### tgc_ev_webview_destroyed="webviewDestroyed"


#### tgc_ev_webview_progress="webviewProgress"


#### tgc_ev_webview_console_message="webviewConsoleMessage"


#### tgc_ev_create="create"


#### tgc_ev_start="start"


#### tgc_ev_resume="resume"


#### tgc_ev_pause="pause"


#### tgc_ev_stop="stop"


#### tgc_ev_destroy="destroy"


#### tgc_ev_config="config"


#### tgc_ev_user_leave_hint="UserLeaveHint"


#### tgc_ev_pip_changed="pipchanged"


#### tgc_ev_airplane="airplane"


#### tgc_ev_locale="locale"


#### tgc_ev_screen_on="screen_on"


#### tgc_ev_screen_off="screen_off"


#### tgc_ev_timezone="timezone"


#### tgc_ev_notification="notification"


#### tgc_ev_notification_dismissed="notificationDismissed"


#### tgc_ev_notification_action="notificationaction"


#### tgc_ev_remote_click="remoteclick"





## External Resources



### [Android Activity Orientation Table](https://developer.android.com/reference/android/R.attr#screenOrientation)

| Constant         | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|:-----------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| behind           | Keep the screen in the same orientation as whatever is behind  this activity.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_BEHIND.                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| fullSensor       | Orientation is determined by a physical orientation sensor:  the display will rotate based on how the user moves the device.  This allows any of the 4 possible rotations, regardless of what  the device will normally do (for example some devices won't  normally use 180 degree rotation).  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_FULL_SENSOR.                                                                                                                                                                                                            |
| fullUser         | Respect the user's sensor-based rotation preference, but if  sensor-based rotation is enabled then allow the screen to rotate  in all 4 possible directions regardless of what  the device will normally do (for example some devices won't  normally use 180 degree rotation).  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_FULL_USER.                                                                                                                                                                                                                             |
| landscape        | Would like to have the screen in a landscape orientation: that  is, with the display wider than it is tall, ignoring sensor data.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE.                                                                                                                                                                                                                                                                                                                                                                           |
| locked           | Screen is locked to its current rotation, whatever that is.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_LOCKED.                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| nosensor         | Always ignore orientation determined by orientation sensor:  the display will not rotate when the user moves the device.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_NOSENSOR.                                                                                                                                                                                                                                                                                                                                                                                     |
| portrait         | Would like to have the screen in a portrait orientation: that  is, with the display taller than it is wide, ignoring sensor data.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_PORTRAIT.                                                                                                                                                                                                                                                                                                                                                                            |
| reverseLandscape | Would like to have the screen in landscape orientation, turned in  the opposite direction from normal landscape.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE.                                                                                                                                                                                                                                                                                                                                                                                    |
| reversePortrait  | Would like to have the screen in portrait orientation, turned in  the opposite direction from normal portrait.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT.                                                                                                                                                                                                                                                                                                                                                                                       |
| sensor           | Orientation is determined by a physical orientation sensor:  the display will rotate based on how the user moves the device.  Ignores user's setting to turn off sensor-based rotation.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_SENSOR.                                                                                                                                                                                                                                                                                                                        |
| sensorLandscape  | Would like to have the screen in landscape orientation, but can  use the sensor to change which direction the screen is facing.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE.                                                                                                                                                                                                                                                                                                                                                                      |
| sensorPortrait   | Would like to have the screen in portrait orientation, but can  use the sensor to change which direction the screen is facing.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT.                                                                                                                                                                                                                                                                                                                                                                        |
| unspecified      | No preference specified: let the system decide the best  orientation.  This will either be the orientation selected  by the activity below, or the user's preferred orientation  if this activity is the bottom of a task. If the user  explicitly turned off sensor based orientation through settings  sensor based device rotation will be ignored. If not by default  sensor based orientation will be taken into account and the  orientation will changed based on how the user rotates the device.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED. |
| user             | Use the user's current preferred orientation of the handset.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_USER.                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| userLandscape    | Would like to have the screen in landscape orientation, but if  the user has enabled sensor-based rotation then we can use the  sensor to change which direction the screen is facing.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_USER_LANDSCAPE.                                                                                                                                                                                                                                                                                                                 |
| userPortrait     | Would like to have the screen in portrait orientation, but if  the user has enabled sensor-based rotation then we can use the  sensor to change which direction the screen is facing.  Corresponds to  ActivityInfo.SCREEN_ORIENTATION_USER_PORTRAIT.                                                                                                                                                                                                                                                                                                                   |



## Bugs
Report bugs as GitHub issues: <https://github.com/tareksander/termux-gui-bash/issues>


## Author
Tarek Sander
