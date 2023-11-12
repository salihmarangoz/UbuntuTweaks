

# install typora, google chrome



```bash
sudo apt remove unattended-upgrades
sudo apt install build-essential
sudo apt install ubuntu-restricted-extras gstreamer1.0-libav
sudo apt install vlc ffmpeg

sudo apt remove *nvidia*
sudo apt remove *nvidia*:i386
sudo apt install nvidia-driver-418

sudo apt install python3-pip python-is-python3
```



```bash
$ sudo apt remove pdfarranger # edit: apt package has some problems
$ sudo apt-get install python3-pip python3-distutils-extra python3-wheel python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-poppler-0.18 python3-setuptools
$ python3 -m pip install --upgrade pip
$ pip3 install --user pikepdf
$ pip3 install --user --upgrade https://github.com/pdfarranger/pdfarranger/archive/1.10.0.zip
```





------------------------------------------

sudo apt-get install libxvidcore4 gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-plugins-bad gstreamer1.0-alsa gstreamer1.0-libav
