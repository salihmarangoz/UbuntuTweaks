# Wine (<u>W</u>ine <u>I</u>s <u>N</u>ot an <u>E</u>mulator)

TODO: This section needs some work!



### SpaceSniffer (with Wine)

http://www.uderzo.it/main_products/space_sniffer/index.html

Beautiful alternative to native Disk Usage Analyzer (baobab).



### Anti-Twin (with Wine)

http://www.joerg-rosenthal.com/en/antitwin/

Duplicate file finder with byte and image comparison features.



### MS Office 2007 (with Wine)

THIS SECTION NEEDS TO BE UPDATED!

There is a need to create a seperate wine prefix, because it needs to be 32bit and other programs may conflict with MS Office.


```bash
export WINEPREFIX="$HOME/.msoffice2007"  # set wine device folder
export WINEARCH=win32

# Ignore this step if you don't have a wine
# Install Latest Wine with 32bit Support
$ sudo dpkg --add-architecture i386
$ sudo apt update
$ wget -qO- https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
$ sudo apt install software-properties-common
$ sudo apt-add-repository 'deb http://dl.winehq.org/wine-builds/ubuntu/ focal main'
$ wget -qO- https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/Release.key | sudo apt-key add -
$ sudo sh -c 'echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/ ./" > /etc/apt/sources.list.d/obs.list'
$ sudo apt update
$ sudo apt-get install --install-recommends winehq-stable
$ wine --version

# Create wine device and add a DLL exception
$ mkdir -p $WINEPREFIX
$ wine wineboot # install both winemono and gecko
$ winecfg       # In libraries section, add riched20 as a new override and set it as "native windows"

# Install fonts
$ sudo apt install winetricks
$ winetricks corefonts
$ winetricks allfonts
$ winetricks fontsmooth-rgb

# Mount your MS Office 2007 CD, change dir to the cd folder then run the installer exe
# Do this without closing the terminal or run the first 2 export commands in the new terminal.
$ wine ???.exe # Install only excel, powerpoint, word and other office tools. Not onenote, outlook etc.
```

