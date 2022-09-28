# Bash Library Tutorial

Make sure you installed the library like explained in the README.  
This tutorial assumes you have the basic understanding of the Android GUI from
the [crash course](https://github.com/termux/termux-gui).  
The full source code can also be found in the tutorial folder.

## Basic structure

To use the library, you have 2 options:
- Use the shebang `#!/bin/tgui-bash` instead of `#!/bin/bash`. The library will initialize itself and then load your script.
- Source the library with `. tgui-bash`.

The library exits when your script exits, and all remaining Activities are cleaned up by the Plugin after that.


## Hello World

````bash
#!/bin/tgui-bash

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

