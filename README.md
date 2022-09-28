# Termux:GUI Bash
Bash library for Termux:GUI.

[Documentation](Manual.md)

[Tutorial](TUTORIAL.md)

### Installing

#### From Source

Additional dependency: CMake

````bash
git clone https://github.com/tareksander/termux-gui-bash.git
cd termux-gui-bash
cmake . -DCMAKE_INSTALL_PREFIX=$PREFIX
make install
````

### Dependencies

- [jq](https://github.com/stedolan/jq)
- Bash (should be installed by default in Termux)

### License

The license is the [Mozilla Public License 2.0](https://www.mozilla.org/en-US/MPL/2.0/).  
TL;DR: You can use this library in your own projects, regardless of the license you choose for it. Modifications to this
library have to be published under the MPL 2.0 (or a GNU license in some cases) though.

