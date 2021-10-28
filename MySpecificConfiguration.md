# This File Includes My Custom Installation For Tuxedo Stellaris 15

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [This File Includes My Custom Installation For Tuxedo Stellaris 15](#this-file-includes-my-custom-installation-for-tuxedo-stellaris-15)
  - [.bashrc](#bashrc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

- Installed Ubuntu 20.04

- While installing Ubuntu don't forget to tick **`Download updates while installing`**



```bash
sudo apt update
sudo apt upgrade
sudo apt remove unattended-upgrades


# open http://deb.tuxedocomputers.com/ubuntu/pool/main/t/tuxedo-tomte/ and download tuxedo tomte
# open a new terminal at the location of the downloaded file then install
sudo apt install ./tuxedo-tomte_2.4.19_all.deb
# NOW WAIT AND AFTER RECEIVING THE NOTIFICATION REBOOT THE PC
sudo tuxedo-tomte block tuxedo-mirrors
sudo tuxedo-tomte block tuxedo-repos
sudo tuxedo-tomte block nvidia-driver
sudo tuxedo-tomte block kernel
sudo tuxedo-tomte block mesa-utils
sudo tuxedo-tomte block amdgpu-dkms


# open software % updates
# change 'download from' to Main Server
# from developer options enable pre-released updates
# reboot


sudo gedit /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet mitigations=off amdgpu.backlight=off"
sudo update-grub


sudo ubuntu-drivers autoinstall
# if this doesnt work update to the latest driver in 'additional drivers'


# restart and open display settings set it to other than 40hz (for ex. 165hz)


sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt install --install-recommends linux-generic-hwe-20.04
sudo apt upgrade
sudo apt install -f # if it crashes while upgrading


sudo nano /etc/fstab
# comment swap entry
# add noatime like this:  UUID=... / ext4 errors=remount-ro,noatime 0 1

```



## .bashrc

```bash
function disable_touchpad(){
    DEVICE_ID=`xinput list | grep -Eo 'Touchpad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
    echo 'Touchpad has been disabled:'
    xinput list | grep Touchpad
    xinput set-prop $DEVICE_ID "Device Enabled" 0
}

function enable_touchpad(){
    DEVICE_ID=`xinput list | grep -Eo 'Touchpad\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}'`
    echo 'Touchpad has been enabled:'
    xinput list | grep Touchpad
    xinput set-prop $DEVICE_ID "Device Enabled" 1
}
```



https://github.com/tuxedocomputers/tuxedo-plymouth-one
