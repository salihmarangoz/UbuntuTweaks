# Ubuntu Tweaks Guide

   * [Ubuntu Tweaks Guide](#ubuntu-tweaks-guide)
      * [Introduction](#introduction)
      * [To-Do](#to-do)
      * [1. Performance Tweaks](#1-performance-tweaks)
         * [1.1. Change CPU Scaling Governor to Performance](#11-change-cpu-scaling-governor-to-performance)
         * [1.2. Disable Security Mitigations](#12-disable-security-mitigations)
         * [1.3. Preload](#13-preload)
         * [1.4. Mount /tmp as tmpfs (and Move Browser Cache)](#14-mount-tmp-as-tmpfs-and-move-browser-cache)
         * [1.5. Move Browser Profile to RAM (profile-sync-daemon)](#15-move-browser-profile-to-ram-profile-sync-daemon)
         * [1.6. Turn Off Wifi Power Management](#16-turn-off-wifi-power-management)
         * [1.7. ZRAM as a Compressed RAM Block](#17-zram-as-a-compressed-ram-block)
         * [1.8. Faster TCP (BBR, Fast TCP Open)](#18-faster-tcp-bbr-fast-tcp-open)
      * [2. Utility/Fix Tweaks](#2-utilityfix-tweaks)
         * [2.1. PulseAudio Mic Echo Cancellation Feature](#21-pulseaudio-mic-echo-cancellation-feature)
         * [2.2. PulseAudio Crackling Sound Solution](#22-pulseaudio-crackling-sound-solution)
         * [2.3. PulseAudio Better Sound Quality](#23-pulseaudio-better-sound-quality)
         * [2.4. Hide User List in Ubuntu 18.04 Login Screen](#24-hide-user-list-in-ubuntu-1804-login-screen)
         * [2.5. GnomeTweaks (laptop lid suspend, desktop icons etc.)](#25-gnometweaks-laptop-lid-suspend-desktop-icons-etc)
         * [2.6. Disable Touchpad When Mouse is Plugged](#26-disable-touchpad-when-mouse-is-plugged)
         * [2.7. Disable Default Swapfile on Disk](#27-disable-default-swapfile-on-disk)
         * [2.8. Delete Log Archives Regularly](#28-delete-log-archives-regularly)

## Introduction

Here are some tweaks for **Ubuntu 18.04** to speed up and fix problems. Because some of these tweaks are optimized for my system, I have to mention that my **laptop PC** configuration: 

- `Ubuntu 18.04` with `Gnome Desktop`
- `Intel® Core™ i7-4710MQ CPU @ 2.50GHz × 8`
- `Intel® HD Graphics 4600`
- `16GB DDR3 RAM`
- `7200 rpm HDD`
- `Wifi` (Intel® Chipset)
- `Dead battery` (Using only AC)

**Note: Configurations listed in this guide are not recommended for server environments.**



## To-Do

- [ ] Decrease log amount with filtering
- [ ] Add sources where they are missing
- [ ] https://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that



## 1. Performance Tweaks

### 1.1. Change CPU Scaling Governor to Performance

Intel CPU's reported to be run faster when changed its scaling governor to performance mode.

**Source:** https://askubuntu.com/questions/1021748/set-cpu-governor-to-performance-in-18-04#comment1820782_1049313

- Running the following command is enough:

```bash
$ sudo systemctl disable ondemand
```

- Check the CPU governor after reboot:

```bash
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```



### 1.2. Disable Security Mitigations

Reclaim the CPU power while increasing the security risks. Double edge sword!

**Source(s):** https://make-linux-fast-again.com/

https://wiki.ubuntu.com/SecurityTeam/KnowledgeBase/SpectreAndMeltdown/MitigationControls

https://www.reddit.com/r/linux/comments/b1ltnr/disabling_kernel_cpu_vulnerabilities_mitigations/

- Open grub configuration with `gedit`.

```bash
$ sudo gedit /etc/default/grub
```

- In the editor change this line;

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
```

- to this then save:

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off mitigations=off"
```

- Apply new configuration:

```bash
$ sudo update-grub
```

- After reboot, check vulnerabilities.

```bash
$ grep . /sys/devices/system/cpu/vulnerabilities/*
```

- This command should give output similar to this:

```
/sys/devices/system/cpu/vulnerabilities/l1tf:Mitigation: PTE Inversion; VMX: vulnerable
/sys/devices/system/cpu/vulnerabilities/mds:Vulnerable; SMT vulnerable
/sys/devices/system/cpu/vulnerabilities/meltdown:Vulnerable
/sys/devices/system/cpu/vulnerabilities/spec_store_bypass:Vulnerable
/sys/devices/system/cpu/vulnerabilities/spectre_v1:Mitigation: __user pointer sanitization
/sys/devices/system/cpu/vulnerabilities/spectre_v2:Vulnerable, IBPB: disabled, STIBP: disabled
```



### 1.3. Preload

Preload, monitors user activity and caches programs into RAM. Prefer this if you are using apps and programs in HDD. No need for SSD users.

**Source:** https://www.hecticgeek.com/2013/05/using-preload-ubuntu-13-04/

- Install the program with the following command. No further configurations are needed.

```bash
$ sudo apt install preload
```



### 1.4. Mount /tmp as tmpfs (and Move Browser Cache)

Mounting `/tmp` folder into RAM, will reduce disk access while increasing lifespan of the device.

- Modify the file which includes 

```bash
$ sudo nano /etc/fstab
```

- Then add the following line:

```
tmpfs /tmp tmpfs rw,nosuid,nodev
```

- Reboot the PC. Now it is done. If you want to move browser cache into this folder apply the operations below. 
- Moving Firefox cache will reduce HDD access thus it will increase the performance. Internet usage maybe increase, so if you are using metered connection **don't** set this up. The similar configuration can be applied to Chromium, Opera etc. Open Firefox and enter this address to the URL bar:

```
about:config
```

- Find the key **`browser.cache.disk.parent_directory`** and change its value to **`/tmp`**
- Reboot the system.



### 1.5. Move Browser Profile to RAM (profile-sync-daemon)

Moving Firefox cache will reduce HDD access thus it will increase the performance. In order to achieve that we will use `profile-sync-daemon`.

**Source:** https://wiki.archlinux.org/index.php/Profile-sync-daemon

- Install the program:

```bash
$ sudo apt install profile-sync-daemon
```

- Run the program to trigger generating configuration files:

```bash
$ psd
```

- Open the configuration file to modify:

```bash
$ nano $HOME/.config/psd/psd.conf
```

- Add following lines to the file: (BACKUP_LIMIT is optional, I prefer its value this way)

```
USE_OVERLAYFS="yes"
BACKUP_LIMIT=1
```

- Open `sudoers` file to give extra permissions for overlayfs:

```bash
sudo nano /etc/sudoers
```

- Add the following line and save:

```
user ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper
```

- Run psd again:

```bash
$ psd
```

- Enable PSD as a service:

```bash
$ systemctl --user start psd.service
$ systemctl --user enable psd.service
```

- Preview current status of psd:

```bash
$ psd preview
```

- It should be like this. All there items must be active. If you are using supported browser it must be shown.

```
Profile-sync-daemon v6.31 on Ubuntu 18.04.3 LTS

 Systemd service is currently active.
 Systemd resync-timer is currently active.
 Overlayfs v23 is currently active.

Psd will manage the following per /home/salih/.config/psd/.psd.conf:

 browser/psname:  firefox/firefox
 owner/group id:  salih/1000
 sync target:     /home/salih/.mozilla/firefox/4hf76691.default
 tmpfs dir:       /run/user/1000/salih-firefox-4hf76691.default
 profile size:    64K
 overlayfs size:  0
 recovery dirs:   none

 browser/psname:  firefox/firefox
 owner/group id:  salih/1000
 sync target:     /home/salih/.mozilla/firefox/9mpd2ih9.default-release
 tmpfs dir:       /run/user/1000/salih-firefox-9mpd2ih9.default-release
 profile size:    145M
 overlayfs size:  37M
 recovery dirs:   none
```



### 1.6. Turn Off Wifi Power Management

Speed up wifi performance.

**Source:** https://easylinuxtipsproject.blogspot.com/p/speed-mint.html

- Run following command:

```bash
$ sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

- Change the value to 2. File should be look like this:

```
[connection]
wifi.powersave = 2
```

- Restart computer, then check it with this command. (It must be off)

```bash
$ iwconfig | grep Management
```



### 1.7. ZRAM as a Compressed RAM Block

If your PC is out of memory or has no extra space for caching, give it a shot!

- Create ZRAM script:

```bash
$ sudo nano /usr/bin/zram.sh
$ sudo chmod 555 /usr/bin/zram.sh
```

- Paste the following lines: 
  - Note(1): Modify `ZRAM_MEMORY` below if needed
  - Note(2): Change `lz4` to `zstd` to increase compress ratio, but will cost CPU time. Source: https://github.com/facebook/zstd
  - Note(3): Some other scripts on the Internet create zram devices depending on CPU cores, but it is not needed since multiple streams can be set for one single device.

```
##########################
ZRAM_MEMORY=2048
##########################
set -x
CORES=$(nproc --all)
modprobe zram
ZRAM_DEVICE=$(zramctl --find --size "$ZRAM_MEMORY"M --streams $CORES --algorithm lz4)
mkswap $ZRAM_DEVICE
swapon --priority 5 $ZRAM_DEVICE
```

- Set the script run on boot:

```bash
$ sudo nano /etc/rc.local
```

- Paste the following lines:

```
#!/bin/bash
bash /usr/bin/zram.sh &
exit 0
```

- Set `rc.local` as executable:

```bash
$ sudo chmod +x /etc/rc.local
```

- Reboot the PC.

If there is a problem check rc.local service with:

```bash
$ sudo systemctl status rc-local
```



### 1.8. Faster TCP (BBR, Fast TCP Open)

It is reported that using this algorithm (BBR) developed by Google and Fast TCP Open increases network speed and reduces delay.

**Source(s):** https://gist.github.com/Jamesits/3d6da2d711bd95c53ccd953f99aee748

https://wiki.archlinux.org/index.php/Sysctl#Enable_TCP_Fast_Open

- Modify loaded modules on boot:

```bash
$ sudo nano /etc/modules-load.d/modules.conf
```

- Add the following line:

```
tcp_bbr
```

- Modify system variable configuration file:

```bash
$ sudo nano /etc/sysctl.conf
```

- Add the following lines:

```
net.ipv4.tcp_fastopen = 3
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```

- Reboot the PC.
- Test if it is running. This command should output `bbr` as printed.

```bash
$ sysctl net.ipv4.tcp_congestion_control
```





## 2. Utility/Fix Tweaks

### 2.1. PulseAudio Mic Echo Cancellation Feature

Echo cancellation is a useful tool to have while talking Skype etc **without headphones.**

**Source:** https://www.reddit.com/r/linux/comments/2yqfqp/just_found_that_pulseaudio_have_noise/

- Run the following command:

```bash
$ sudo nano /etc/pulse/default.pa
```

- Add the following line:

```
load-module module-echo-cancel
```

- Reload pulseaudio:

```bash
$ pulseaudio -k
```

- Select echo canceled sources in sound settings.



### 2.2. PulseAudio Crackling Sound Solution

The newer implementation of the PulseAudio sound server uses  timer-based audio scheduling instead of the traditional,  interrupt-driven approach. Timer-based scheduling may expose issues in some ALSA drivers. On the other hand, other drivers might be glitchy without it on, so check  to see what works on your system. 

**Source:** https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Glitches,_skips_or_crackling

- To turn timer-based scheduling off add `tsched=0` in `/etc/pulse/default.pa`: 

```bash
$ sudo nano /etc/pulse/default.pa
```

- Modify file as explained below:

```bash
# Change this line:
load-module module-udev-detect

# To this line:
load-module module-udev-detect tsched=0
```

- Then restart the PulseAudio server: 

```bash
$ pulseaudio -k
$ pulseaudio --start
```

(RESTORE): Do the reverse to enable timer-based scheduling, if not already enabled by default. 



### 2.3. PulseAudio Better Sound Quality

Tweak for audiophiles. Increasing sample rate in exchange of CPU time.

**Source:** https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Auto-Mute_Mode

- Modify pulseaudio config file:

```bash
$ sudo nano /etc/pulse/daemon.conf
```

- Add the following lines to the end of the file:

```
default-sample-format = float32le
default-sample-rate = 48000
alternate-sample-rate = 96000
resample-method = speex-float-10
```

- Restart pulseaudio server:

```bash
$ pulseaudio -k
$ pulseaudio --start
```

**NOTE:** This configuration may conflict with "Echo Cancelation Feature". In sound settings choose high quality sound or low quality sound with echo cancelation.



### 2.4. Hide User List in Ubuntu 18.04 Login Screen

The Gnome login screen normally shows a list of available users to log in as. For those who want to disable showing the user list, and manually type a username to login with, below I will show you how.

**Source:** http://ubuntuhandbook.org/index.php/2018/04/hide-user-list-ubuntu-18-04-login-screen/

- Run command to get access to root:

```bash
$ sudo -i
```

*Type in your password (no visual feedback while typing) when it prompts and hit Enter.*

- In the terminal, run command to allow gdm to make connections to the X server:

```
# xhost +SI:localuser:gdm
```

- Then switch to user `gdm`, which is required to run gsettings to configure gdm settings.

```
# su gdm -l -s /bin/bash
```

- Finally hide user list from login screen using Gsettings:

```bash
$ gsettings set org.gnome.login-screen disable-user-list true
```

(RESTORE): To restore the change, open terminal and **re-do** previous steps, except running the last command with:

```bash
$ gsettings set org.gnome.login-screen disable-user-list false
```



### 2.5. GnomeTweaks (laptop lid suspend, desktop icons etc.)

There are some tweaks which can increase utility of Gnome. These are tested on Ubuntu 18.04 and may not work on its older versions.

- Install gnome tweaks:

```bash
$ sudo apt install gnome-tweaks
```

- Run the program:

```
$ gnome-tweaks
```

- Here are some configurations which I found them useful:
- **(1) Disable Animations on Very Slow Computers**
  - `Appearance` -> `Animations` -> `OFF`
- **(2) Disable Mounted Volumes Showing on Desktop**
  - `Desktop` -> `Mounted Volumes` -> `OFF`
- **(3) Enable Mouse Pointer Highlight when Ctrl is Pressed** (Problematic while gaming!!!)
  - `Keyboard & Mouse` -> `Pointer Location` -> `ON`
- **(4) Disable Suspend When Laptop Lid is Closed**
  - `Power` -> `Suspend when laptop lid is closed` -> `OFF`
- **(5) Enable Battery Percentage Showing Up on the Top Bar**
  - `Top Bar` -> `Battery Percentage` -> `ON`
- **(6) Enable Date Showing Up on the Top Bar**
  - `Top Bar` -> `Date` -> `ON`



### 2.6. Disable Touchpad When Mouse is Plugged

When mouse is plugged, touchpad should be disable automatically, right? This guide is for `Gnome` users.

**Source:** http://ubuntuhandbook.org/index.php/2018/04/install-touchpad-indicator-ubuntu-18-04-lts/

- Add PPA:

```bash
$ sudo add-apt-repository ppa:atareao/atareao
```

- Install `touchpad-indicator`:

```bash
$ sudo apt install touchpad-indicator
```

- Start the program. (Search with the touchpad keyword)
- It should be shown on the top bar. Click on it and select `Preferences`, then follow the steps below:
- **(1) Disable touchpad when mouse is plugged**
  - `Actions` -> `Disable touchpad when mouse plugged` -> `OFF`
- **(2) Start the program on boot**
  - `General Options` -> `Autostart` -> `ON`
  - `General Options` -> `Start hidden` -> `Unchecked!` (Note: If you check this option top bar icon will be invisible. Not recommended)



### 2.7. Disable Default Swapfile on Disk

Ubuntu 18.04 comes with a swapfile enabled. In out-of-memory situations this swapfile may only cause system freeze. If you are using Ubuntu with SSD, you should disable swap in that device to slow down disk aging.

- Modify `fstab`:

```bash
$ sudo nano /etc/fstab
```

- Comment out the line which starts with `/swapfile`. The full line should look like this after editing:

```
#/swapfile none swap sw 0 0
```

- Reboot the PC.



### 2.8. Delete Log Archives Regularly

Old logs sometimes hold a lot of space on disk. 

- Edit cron (you can select `nano` as editor):

```bash
$ sudo crontab -e
```

- Add the following line (press `ctrl+x` then answer with `y` to save the file):

```
@reboot /usr/bin/find /var/log -name "*.gz" -type f -delete
```

