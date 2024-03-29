# Install Programs/Tools

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Apps Easy to Install](#apps-easy-to-install)
- [Open Source Apps](#open-source-apps)
  - [Basic Utilities](#basic-utilities)
  - [PDF Arranger](#pdf-arranger)
  - [Tmux](#tmux)
  - [Fritzing](#fritzing)
  - [Firejail](#firejail)
- [Closed Source Apps](#closed-source-apps)
  - [Sublime Text](#sublime-text)
- [Wine (<u>W</u>ine <u>I</u>s <u>N</u>ot an <u>E</u>mulator)](#wine-uwuine-uius-unuot-an-ueumulator)
  - [MS Office 2007 (with Wine)](#ms-office-2007-with-wine)
- [Other/Mixed](#othermixed)
  - [Chromium / Chrome Addons](#chromium--chrome-addons)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Installation commands may be changed in the future, so it is recommended to check the source.

## Open Source Apps

### Basic Utilities

```bash
$ sudo apt update
$ sudo apt install \
	aptitude apt-transport-https software-properties-common ubuntu-restricted-extras \
	wget git rar unzip curl \
	screen net-tools \
	gparted htop iotop bmon \
	thunderbird xul-ext-lightning libreoffice \
	pinta gimp vlc \
	octave
	
# For Gnome
$ sudo apt install network-manager-openvpn-gnome \
				   gnome-music \
                   gnome-sound-recorder \
                   gnome-documents \
                   gnome-system-monitor \
                   gnome-backgrounds \
                   gnome-paint \
                   eog
```


### PDF Arranger

https://github.com/pdfarranger/pdfarranger

Better than `PDF Shuffler` and other variations.

```bash
$ sudo apt remove pdfarranger # edit: apt package has some problems
$ sudo apt-get install python3-pip python3-distutils-extra python3-wheel python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-poppler-0.18 python3-setuptools
$ python3 -m pip install --upgrade pip
$ pip3 install --user pikepdf
$ pip3 install --user --upgrade https://github.com/pdfarranger/pdfarranger/archive/1.7.0rc1.zip
```

### Tmux

```bash
# Install
$ sudo apt install tmux

# Custom Configuration
$ echo >$HOME/.tmux.conf
$ cat >$HOME/.tmux.conf << EOF
set-option -g default-command "exec /bin/bash"
set-option -g allow-rename off
set -g default-terminal "screen-256color"
set -g status off
set -g mouse on
EOF
```

### Fritzing

https://fritzing.org

CAD software for designing electronics hardware. For more: https://en.wikipedia.org/wiki/Fritzing

```bash
$ sudo apt install libqt5printsupport5 libqt5xml5 libqt5sql5 libqt5serialport5 libqt5sql5-sqlite
$ sudo apt install fritzing fritzing-data fritzing-parts
```

### Firejail

Linux namespaces sandbox program. Makes it possible to limit CPU/RAM/etc. system resources for applications.

```bash
$ sudo apt install firejail
# Go to "~/.local/share/applications" or "/usr/share/applications" and modify .desktop files.
# Add this as a prefix to Exec= section. This will make the app unable to connect to the internet:
# firejail --noprofile --net=none
```



## Closed Source Apps

### Sublime Text

```bash
# Install
$ wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
$ echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
$ sudo apt update
$ sudo apt install sublime-text

# Custom Configuration
$ mkdir -p $HOME/.config/sublime-text-3/Packages/User
$ cat >$HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings << EOF
{
    "draw_white_space": "all",
    "translate_tabs_to_spaces": true,
    "hardware_acceleration": "opengl"
}
EOF
```



## Wine (<u>W</u>ine <u>I</u>s <u>N</u>ot an <u>E</u>mulator)

Wine is an compatibility layer for running executables for Windows. 

**Note:** Since Wine installation changes time to time it is not noted here. Search for a way on the Internet. Sorry.



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



## Other/Mixed

### Chromium / Chrome Addons

- [**Markdown Viewer**](https://chrome.google.com/webstore/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk) (After installing remove automatically access to files for privacy)
- [**Jupyter Notebook Viewer**](https://chrome.google.com/webstore/detail/jupyter-notebook-viewer/ocabfdicbcamoonfhalkdojedklfcjmf) (After installing remove automatically access to files for privacy)

- [**Picture-in-Picture Extension**](https://chrome.google.com/webstore/detail/picture-in-picture-extens/hkgfoiooedgoejojocmhlaklaeopbecg/related?hl=en)
- [**Find Code for Research Papers - CatalyzeX**](https://chrome.google.com/webstore/detail/find-code-for-research-pa/aikkeehnlfpamidigaffhfmgbkdeheil?hl=en)
- [**uBlock Origin**](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en)
- [**Grammarly for Chrome**](https://chrome.google.com/webstore/detail/grammarly-for-chrome/kbfnbcaeplbcioakkpcpgfkobkghlhen?hl=en)
- [**YouTube Dark Theme**](https://chrome.google.com/webstore/detail/youtube-dark-theme/icgoeaddhagkbjnnigiblfebijeinfme?hl=en)
- [**YouTube NonStop**](https://chrome.google.com/webstore/detail/youtube-nonstop/nlkaejimjacpillmajjnopmpbkbnocid?hl=en)
- [**Cookie Notice Blocker**](https://chrome.google.com/webstore/detail/cookie-notice-blocker/odhmfmnoejhihkmfebnolljiibpnednn?hl=en-GB)
- [**Ad Blocker for Facebook**](https://chrome.google.com/webstore/detail/ad-blocker-for-facebook/kinpgphmiekapnpbmobneleaiemkefag?hl=en)
- [**Video DownloadHelper**](https://chrome.google.com/webstore/detail/video-downloadhelper/lmjnegcaeklhafolokijcfjliaokphfk) (The companion app can be installed to run better)
- [**GNOME Shell integration**](https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=en) (See **UtilityFixTweaks.md** before installing)
- [**GSConnect**](https://chrome.google.com/webstore/detail/gsconnect/jfnifeihccihocjbfcfhicmmgpjicaec?hl=en) (See **UtilityFixTweaks.md** before installing)

