# Ubuntu Tweaks Guide


   * [Ubuntu Tweaks Guide](#ubuntu-tweaks-guide)
      * [Introduction](#introduction)
      * [To-Do](#to-do)
      * [1. Change CPU Scaling Governor to Performance](#1-change-cpu-scaling-governor-to-performance)
      * [2. Disable Security Mitigations](#2-disable-security-mitigations)
      * [3. Install Preload](#3-install-preload)
      * [4. Move Firefox Cache to RAM](#4-move-firefox-cache-to-ram)
      * [5. Move Browser Profile to RAM](#5-move-browser-profile-to-ram)
      * [6. Turn Off Wifi Power Management](#6-turn-off-wifi-power-management)
      * [7. PulseAudio Mic Echo Cancellation Feature](#7-pulseaudio-mic-echo-cancellation-feature)
      * [8. PulseAudio Crackling Sound Solution](#8-pulseaudio-crackling-sound-solution)
      * [9. Hide User List in Ubuntu 18.04 Login Screen](#9-hide-user-list-in-ubuntu-1804-login-screen)
      * [10. Disable Automatic Suspend When Laptop Lid is Closed](#10-disable-automatic-suspend-when-laptop-lid-is-closed)
      * [11. ZRAM as a Compressed RAM Block](#11-zram-as-a-compressed-ram-block)
      * [12. Disable Swapfile in HDD](#12-disable-swapfile-in-hdd)
      * [13. Delete Log Archives Regularly](#13-delete-log-archives-regularly)



## Introduction

Here are some tweaks for **`Ubuntu 18.04`** which I use personally to speed up and fix my computer. Because these tweaks are optimized for my system, to note that my computer features are; `Intel i7 CPU`, `16GB memory`, `HDD`, `Wifi` and `a dead battery`.

**Note: Configurations listed in this guide are not recommended for server environments.**



## To-Do

- [ ] CPU Scaling Governor -> Make it Permanent
- [ ] Decrease log amount with filtering



## 1. Change CPU Scaling Governor to Performance

**Source:** https://www.gamingonlinux.com/articles/you-will-want-to-force-your-cpu-into-high-performance-mode-for-vulkan-games-on-linux.9369/

- Check current CPU scaling governor with the following command:

```bash
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```

- To change the governor to performance run:

```bash
$ echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

**Note(1): If you are using with also battery install `indicator-cpufreq` to control the governor.**

**Note(2): Check the CPU temperature after configurations**



## 2. Disable Security Mitigations

Reclaim the CPU power while increasing the security risks. Double edge sword!

**Source(s):** 

https://make-linux-fast-again.com/

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



## 3. Install Preload

**Source:** https://www.hecticgeek.com/2013/05/using-preload-ubuntu-13-04/

Preload, monitors user activity and caches programs into RAM. Prefer this if you are using apps and programs in HDD. No need for SSD users.

- Install the program with the following command. No further configurations are needed.

```bash
$ sudo apt install preload
```



## 4. Move Firefox Cache to RAM

Moving Firefox cache will reduce HDD access thus it will increase the performance. Internet usage maybe increase, so if you are using metered connection **don't** set this up.

- To mount `/tmp` folder to RAM run the followin command:

```bash
$ sudo nano /etc/fstab
```

- Then add the following line:

```
tmpfs /tmp tmpfs rw,nosuid,nodev
```

- Open Firefox and enter this address to URL bar:

```
about:config
```

- Find key **`browser.cache.disk.parent_directory`** and change its value to **`/tmp`**
- Reboot the system.



## 5. Move Browser Profile to RAM

**Source:** https://wiki.archlinux.org/index.php/Profile-sync-daemon

Moving Firefox cache will reduce HDD access thus it will increase the performance. In order to achieve that we will use `profile-sync-daemon`.

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



## 6. Turn Off Wifi Power Management

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



## 7. PulseAudio Mic Echo Cancellation Feature

Echo cancellation is a useful tool to have while talking Skype etc **without headphones.**

`Source:` https://www.reddit.com/r/linux/comments/2yqfqp/just_found_that_pulseaudio_have_noise/

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



## 8. PulseAudio Crackling Sound Solution

The newer implementation of the PulseAudio sound server uses  timer-based audio scheduling instead of the traditional,  interrupt-driven approach. Timer-based scheduling may expose issues in some ALSA drivers. On the other hand, other drivers might be glitchy without it on, so check  to see what works on your system. 

`Source:` https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Glitches,_skips_or_crackling

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



## 9. Hide User List in Ubuntu 18.04 Login Screen

Source: http://ubuntuhandbook.org/index.php/2018/04/hide-user-list-ubuntu-18-04-login-screen/

The Gnome login screen normally shows a list of available users to log in as. For those who want to disable showing the user list, and manually type a username to login with, below I will show you how.

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



## 10. Disable Automatic Suspend When Laptop Lid is Closed

I can sometimes unwanted going into suspend state when lid is closed.

**Note:** Tested on Ubuntu 18.04. May not work older versions.

- Install gnome tweaks:

```bash
$ sudo apt install gnome-tweaks
```

- Run the program:

```
$ gnome-tweaks
```

- In `Power` section switch off the item named `"Suspend when laptop lid is closed"`



## 11. ZRAM as a Compressed RAM Block

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



## 12. Disable Swapfile in HDD

Ubuntu 18.04 comes with default swapfile. In out-of-memory situations this swapfile doesn't provide a solution rather than system freeze.

- Modify `fstab`:

```bash
$ sudo nano /etc/fstab
```

- Comment out the line which starts with `/swapfile`. The full line should look like this after editing:

```
#/swapfile none swap sw 0 0
```

- Reboot the PC.



## 13. Delete Log Archives Regularly

Logs sometimes hold a lot of space on disk. 

- Edit cron:

```bash
$ sudo crontab -e
```

- Add the following line:

```
@reboot /usr/bin/find /var/log -name "*.gz" -type f -delete
```

