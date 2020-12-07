# Install Programs/Tools

## Open Source

 ### Basic Utilities

```bash
$ sudo apt update
$ sudo apt install \
	apt-transport-https software-properties-common aptitude ubuntu-restricted-extras \
	wget git rar unzip \
	screen net-tools network-manager-openvpn-gnome \
	gparted htop iotop bmon \
	thunderbird xul-ext-lightning \
	gnome-sound-recorder vlc \
	octave \
	pinta gnome-paint
```

### PDF Arranger

Better than `PDF Shuffler`

```bash
$ sudo apt remove pdfarranger # edit: apt package has some problems
$ python3 -m pip install --upgrade pip
$ pip3 install --user pikepdf
$ pip3 install --user --upgrade https://github.com/pdfarranger/pdfarranger/zipball/master
$ pdfarranger
```

### Peek

```bash
$ sudo add-apt-repository ppa:peek-developers/stable
$ sudo apt update
$ sudo apt install peek
```

### Typora

Best for markdown files.

```bash
$ wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
$ sudo add-apt-repository 'deb https://typora.io/linux ./'
$ sudo apt update
$ sudo apt install typora
```

### Balena Etcher

```bash
$ echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
$ sudo apt update
$ sudo apt install balena-etcher-electron
```

### VirtualBox

After installating VirtualBox, install extension pack: https://download.virtualbox.org/virtualbox/

```bash
$ wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
$ wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
$ sudo add-apt-repository "deb http://download.virtualbox.org/virtualbox/debian xenial contrib"
$ sudo apt update
$ sudo apt install virtualbox
```

### TOC

Usage: `$ toc README.md`

```bash
$ wget https://raw.githubusercontent.com/ekalinin/github-markdown-toc/master/gh-md-toc
$ sudo mv gh-md-toc /usr/bin/toc
$ sudo chmod 555 /usr/bin/toc
```

### Visual Studio Code

```bash
$ wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
4 sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
4 sudo rm -f /etc/apt/sources.list.d/vscode.list # somehow adds itself into two different locations. So removing one of them
$ sudo apt update
$ sudo apt install code
```

### OBS Studio

Very good recording and streaming app.

```bash
$ sudo apt install ffmpeg
$ sudo add-apt-repository ppa:obsproject/obs-studio
$ sudo apt update
$ sudo apt install obs-studio
```



## Closed Source

### GitKraken

Visualized git operations.

```bash
$ wget https://release.axocdn.com/linux/gitkraken-amd64.deb
$ sudo dpkg -i gitkraken-amd64.deb
$ sudo apt install -f
$ rm gitkraken-amd64.deb
```

## Skype

```bash
$ wget -4 https://go.skype.com/skypeforlinux-64.deb
$ sudo dpkg -i skypeforlinux-64.deb
$ sudo apt install -f
$ rm skypeforlinux-64.deb
```

## Foxit Reader

It is possible to highlight some texts and save them.

https://www.foxitsoftware.com/downloads/

