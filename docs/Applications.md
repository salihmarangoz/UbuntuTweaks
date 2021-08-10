# Install Programs/Tools

Installation commands may be changed in the future, so it is recommended to check the source.

   * [Install Programs/Tools](#install-programstools)
      * [Open Source Apps](#open-source-apps)
         * [Basic Utilities](#basic-utilities)
         * [PDF Arranger](#pdf-arranger)
         * [Peek](#peek)
         * [Typora](#typora)
         * [Balena Etcher](#balena-etcher)
         * [VirtualBox](#virtualbox)
         * [TOC](#toc)
         * [Tmux](#tmux)
         * [Visual Studio Code](#visual-studio-code)
         * [OBS Studio](#obs-studio)
         * [Fritzing](#fritzing)
         * [Youtube-dl](#youtube-dl)
         * [ShrinkPDF](#shrinkpdf)
      * [Closed Source Apps](#closed-source-apps)
         * [Sublime Text](#sublime-text)
         * [GitKraken](#gitkraken)
         * [Skype](#skype)
         * [Foxit Reader](#foxit-reader)
         * [SpaceSniffer (with Wine)](#spacesniffer-with-wine)
         * [Anti-Twin (with Wine)](#anti-twin-with-wine)
         * [MS Office 2007 (with Wine)](#ms-office-2007-with-wine)
      * [Other/Mixed Apps](#othermixed-apps)
         * [Chromium / Chrome Addons](#chromium--chrome-addons)
         * [LD_PRELOAD](#ld_preload)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## Open Source Apps

 ### Basic Utilities

```bash
$ sudo apt update
$ sudo apt install \
	apt-transport-https software-properties-common ubuntu-restricted-extras \
	aptitude \
	wget git rar unzip curl \
	screen net-tools network-manager-openvpn-gnome \
	gparted htop iotop bmon \
	thunderbird xul-ext-lightning \
	gnome-sound-recorder vlc \
	octave \
	pinta gnome-paint gimp
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

### Peek

```bash
$ sudo add-apt-repository ppa:peek-developers/stable
$ sudo apt update
$ sudo apt install peek
```

### Typora

https://typora.io/

Best for markdown files.

```bash
$ wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
$ sudo add-apt-repository 'deb https://typora.io/linux ./'
$ sudo apt update
$ sudo apt install typora
```

After installing it would be beneficial to enable `inline math` and `highlight` syntax support in the settings.

### Balena Etcher

https://www.balena.io/etcher/

See: https://github.com/balena-io/etcher?d_id=2d48faac-d9ce-4800-88d4-68f9c7a57a8aR#debian-and-ubuntu-based-package-repository-gnulinux-x86x64

```bash
curl -1sLf \
   'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' \
   | sudo -E bash
   
sudo apt-get install balena-etcher-electron
```

### VirtualBox

https://www.virtualbox.org/

```bash
$ sudo apt install virtualbox virtualbox-ext-pack
```

### TOC

https://github.com/ekalinin/github-markdown-toc

Usage: `$ toc README.md`

```bash
$ wget https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
$ sudo mv gh-md-toc /usr/bin/toc
$ sudo chmod 555 /usr/bin/toc
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

### OBS Studio

https://obsproject.com/

Very good recording and streaming app.

```bash
$ sudo add-apt-repository ppa:obsproject/obs-studio
$ sudo apt install obs-studio
```

### Fritzing

https://fritzing.org

CAD software for designing electronics hardware. For more: https://en.wikipedia.org/wiki/Fritzing

```bash
$ sudo apt install libqt5printsupport5 libqt5xml5 libqt5sql5 libqt5serialport5 libqt5sql5-sqlite
$ sudo apt install fritzing fritzing-data fritzing-parts
```

### Youtube-dl

https://github.com/ytdl-org/youtube-dl

Youtube video, subtitle, thumbnail, etc. downloader which supports batch downloadings (downloading a list).

```bash
$ sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
$ sudo chmod a+rx /usr/local/bin/youtube-dl
```

### ShrinkPDF

http://www.alfredklomp.com/programming/shrinkpdf/

Reduces PDF filesize by lossy recompressing (reducing DPI). The script and its usage can be found in the link.



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

### Sublime Merge

See: https://www.sublimemerge.com/docs/linux_repositories

### Skype

https://www.skype.com/en/

```bash
$ wget -4 https://go.skype.com/skypeforlinux-64.deb
$ sudo dpkg -i skypeforlinux-64.deb
$ sudo apt install -f
$ rm skypeforlinux-64.deb
```

### Foxit Reader

https://www.foxitsoftware.com/downloads/

It is possible to highlight some texts and save them.



### SpaceSniffer (with Wine)

http://www.uderzo.it/main_products/space_sniffer/index.html

Beautiful alternative to native Disk Usage Analyzer (baobab).



### Anti-Twin (with Wine)

http://www.joerg-rosenthal.com/en/antitwin/

Duplicate file finder with byte and image comparison features.



### MS Office 2007 (with Wine)

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
$ sudo apt-add-repository 'deb http://dl.winehq.org/wine-builds/ubuntu/ bionic main'
$ wget -qO- https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | sudo apt-key add -
$ sudo sh -c 'echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./" > /etc/apt/sources.list.d/obs.list'
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





## Other/Mixed Apps

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



### LD_PRELOAD

(not tested yet)

- https://github.com/whitequark/unrandom
- https://github.com/sickill/stderred
- https://github.com/vi/timeskew
- https://github.com/FiloSottile/otherport
- https://github.com/libhugetlbfs/libhugetlbfs
- https://github.com/jacereda/fsatrace
- https://github.com/lilydjwg/stdoutisatty
- https://github.com/jktr/arg-inject
- https://github.com/taeguk/free_checker
- https://github.com/msantos/libproxyproto
- https://github.com/de-vri-es/inet-remap
- https://github.com/msantos/libsockfilter
- https://github.com/majek/fluxcapacitor