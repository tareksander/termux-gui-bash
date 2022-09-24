## Name
**tgui-bash** - Termux:GUI in bash

## Synopsis
**tgui-bash** *filepath*

## Description
Sets up a connection to the Termux:GUI plugin through a small C helper, defines functions to interact with the plugin and finally sources the parameter into the script, so the functions are available.  
  
Can be used in a shebang (`#!/bin/tgui-bash`) or sourced.
  
Using `set -eo pipefail` is advised to make your script exit when the connection to the plugin gets broken.


## Options
There are currently no options.


## Environment
All environment variables that affect bash will affect this program.


## Constants



#### tg_actvivity_tid="tid"
Key for the `tg_activity_new` options array. The value is a number.
Specify a Task id here if you want Activities to launch over each other in the same Task.

#### tg_actvivity_dialog="dialog"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to make the Activity a dialog.

#### tg_actvivity_canceloutside="canceloutside"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to false if you want your dialog to not be dismissed when the user taps on something else.

#### tg_actvivity_pip="pip"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to let the Activity start in picture-in-picture mode.

#### tg_actvivity_lockscreen="lockscreen"
Key for the `tg_activity_new` options array. The value is a boolean.
Set this to make the Activity stay visible and interactable on the lockscreen.
Make sure your interface is secure in this case, to not allow arbitrary command execution or file I/O.

#### tg_actvivity_overlay="overlay"
Key for the `tg_activity_new` options array. The value is a boolean.
This launches the Activity as an overlay over everything else, similar to picture-in-picture mode, but you can interact with all Views.

#### tg_actvivity_intercept="intercept"
Key for the `tg_activity_new` options array. The value is a boolean.
This option makes the back button send an event instead of finishing the Activity.














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



| Name                     | Description                                       | Parameters | Return code               |
|--------------------------|---------------------------------------------------|------------|---------------------------|
| tg_global_turn_screen_on | Turns the screen on.                              |            |                           |
| tg_global_is_locked      | Returns whether the screen is locked.             |            | 0: locked<br/>1: unlocked |
| tg_global_version        | Returns the version code of the plugin to stdout. |            |                           |





### Activity Functions


| Name                              | Description                                                                                                                              | Parameters                                                                                                                                                                                                      | Return code |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| tg_activity_new                   | Creates a new Activity. See the `tg_activity_*` constants for keys and their effect.                                                     | <ol><li>& Options associative array. See the constants for keys.</li><li>& Return array. \[0] will contain the Activity id, \[1] will contain the Task id (if the Task id wasn't given as an option).</li></ol> |             |
| tg_activity_finish                | Finishes an Activity.                                                                                                                    | The Activity id of the Activity.                                                                                                                                                                                |             |
| tg_activity_to_back               | Moves the Task of an Activity to the back.                                                                                               | The Activity id of the Activity.                                                                                                                                                                                |             |
| tg_activity_theme                 | Sets the theme of the Activity.                                                                                                          | <ol><li>The Activity id of the Activity.</li><li>The status bar color.</li><li>The primary color.</li><li>The window background color.</li><li>The text color.</li><li>The accent color</li></ol>               |             |
| tg_activity_description           | Sets the Task description and icon.                                                                                                      | <ol><li>The Activity id of the Activity.</li><li>The description (appears unused).</li><li>The icon.</li></ol>                                                                                                  |             |
| tg_activity_pip_params            | Sets the aspect ratio for picture-in-picture mode.                                                                                       | <ol><li>The Activity id of the Activity.</li><li>The numerator of the aspect ratio.</li><li>The denominator of the aspect ratio.</li></ol>                                                                      |             |
| tg_activity_input                 | Sets how the Activity responds to the soft keyboard. "resize" resizes the Activity to fit the keyboard, "pan", pans the Activity upward. | <ol><li>The Activity id of the Activity.</li><li>The response option.</li></ol>                                                                                                                                 |             |
| tg_activity_pip                   | Makes an Activity enter or leave picture-in-picture-mode.                                                                                | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether the Activity should be in pip or not.</li></ol>                                                                                               |             |
| tg_activity_pip_auto              | Set if an Activity should go into pip automatically if the user leaves.                                                                  | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether the Activity should go into pip automatically or not.</li></ol>                                                                               |             |
| tg_activity_keep_screen_on        | Sets if showing the Activity should keep the screen from turning off.                                                                    | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether screen should be kept on.</li></ol>                                                                                                           |             |
| tg_activity_orientation           | Sets the Orientation of the Activity.                                                                                                    | <ol><li>The Activity id of the Activity.</li><li>Orientation. Please see table ["Android Activity Orientation Table"](#android-activity-orientation-table) below for values.</li></ol>                          |             |
| tg_activity_position              | Sets the screen position for an overlay Activity.                                                                                        | <ol><li>The Activity id of the Activity.</li><li>The x position.</li><li>The y position.</li></ol>                                                                                                              |             |
| tg_activity_configuration         | Gets the configuration for the Activity as a string. Get the values with the `tg_configuration_*` funtions.                              | <ol><li>The Activity id of the Activity.</li></ol>                                                                                                                                                              |             |
| tg_activity_request_unlock        | Requests the user to unlock the screen or unlocks it if the screen isn't protected.                                                      | <ol><li>The Activity id of the Activity.</li></ol>                                                                                                                                                              |             |
| tg_activity_hide_soft_keyboard    | Hides the software keyboard.                                                                                                             | <ol><li>The Activity id of the Activity.</li></ol>                                                                                                                                                              |             |
| tg_activity_intercept_back_button | Sets whether the back button should be intercepted. See the constant `tg_actvivity_intercept` fro more information.                      | <ol><li>The Activity id of the Activity.</li><li>Boolean: Whether to intercept the back button.</li></ol>                                                                                                       |             |




### Task Functions



| Name             | Description                             | Parameters   | Return code |
|------------------|-----------------------------------------|--------------|-------------|
| tg_task_finish   | Finishes all activites in a Task.       | The Task id. |             |
| tg_task_to_front | Makes a Task visible to the user again. | The Task id. |             |



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

All functions take the Activity id as the first parameter and the parent layout as the second parameter.
For root Views, specify `""` as the second parameter.

| Name | Description | Parameters | Return code |
|------|-------------|------------|-------------|
|      |             |            |             |



### View Functions



| Name | Description | Parameters | Return code |
|------|-------------|------------|-------------|
|      |             |            |             |


### Remote Layout, Widget & Notification Functions



| Name | Description | Parameters | Return code |
|------|-------------|------------|-------------|
|      |             |            |             |




### Event Functions



| Name | Description | Parameters | Return code |
|------|-------------|------------|-------------|
|      |             |            |             |





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