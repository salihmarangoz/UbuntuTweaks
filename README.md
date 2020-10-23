# Ubuntu Tweaks Guide

Table of Contents
=================

   * [Ubuntu Tweaks Guide](#ubuntu-tweaks-guide)
   * [Table of Contents](#table-of-contents)
      * [Introduction](#introduction)
      * [To-Do](#to-do)
      * [1. Performance Tweaks](#1-performance-tweaks)
         * [1.1. Change CPU Scaling Governor to Performance](#11-change-cpu-scaling-governor-to-performance)
         * [1.2. Disable Security Mitigations](#12-disable-security-mitigations)
         * [1.3. Preload](#13-preload)
         * [1.4. Mount /tmp as tmpfs (and Move Browser Cache)](#14-mount-tmp-as-tmpfs-and-move-browser-cache)
            * [1.4.1. Configuration for Firefox](#141-configuration-for-firefox)
            * [1.4.2. Configuration for Chromium](#142-configuration-for-chromium)
            * [1.4.3. Configuration for Google Chrome](#143-configuration-for-google-chrome)
         * [1.5. Manually Cache Folders with Vmtouch (browsers, apps, etc.)](#15-manually-cache-folders-with-vmtouch-browsers-apps-etc)
         * [1.6. Turn Off Wifi Power Management](#16-turn-off-wifi-power-management)
         * [1.7. ZRAM as a Compressed RAM Block](#17-zram-as-a-compressed-ram-block)
         * [1.8. Faster TCP (BBR, Fast TCP Open)](#18-faster-tcp-bbr-fast-tcp-open)
         * [1.9. Disable Unnecessary Services](#19-disable-unnecessary-services)
         * [1.10. Ext4 Mount with noatime Option](#110-ext4-mount-with-noatime-option)
         * [1.11. Update On-Board GPU Drivers](#111-update-on-board-gpu-drivers)
         * [1.12. Remove Snap Apps (and replace with native apps)](#112-remove-snap-apps-and-replace-with-native-apps)
         * [1.13. Change Disk Scheduler (For HDD's)](#113-change-disk-scheduler-for-hdds)
         * [1.14. Improve Browser Performance](#114-improve-browser-performance)
            * [1.14.1 Chromium](#1141-chromium)
      * [2. Utility/Fix Tweaks](#2-utilityfix-tweaks)
         * [2.1. PulseAudio Mic Echo Cancellation Feature](#21-pulseaudio-mic-echo-cancellation-feature)
            * [2.1.1. Configuration For One Sound Card](#211-configuration-for-one-sound-card)
            * [2.1.2. Configuration For Multiple Sound Cards](#212-configuration-for-multiple-sound-cards)
         * [2.2. PulseAudio Crackling Sound Solution](#22-pulseaudio-crackling-sound-solution)
         * [2.3. PulseAudio Better Sound Quality](#23-pulseaudio-better-sound-quality)
         * [2.4. Hide User List in Ubuntu 18.04 Login Screen](#24-hide-user-list-in-ubuntu-1804-login-screen)
         * [2.5. GnomeTweaks (laptop lid suspend, desktop icons etc.)](#25-gnometweaks-laptop-lid-suspend-desktop-icons-etc)
         * [2.6. Disable Touchpad When Mouse is Plugged](#26-disable-touchpad-when-mouse-is-plugged)
         * [2.7. Disable Default Swapfile on Disk](#27-disable-default-swapfile-on-disk)
         * [2.8. Delete Log Archives Regularly](#28-delete-log-archives-regularly)
         * [2.9. Enable S.M.A.R.T.](#29-enable-smart)
         * [2.10. Gnome Extensions](#210-gnome-extensions)
            * [2.10.1. GSConnect](#2101-gsconnect)
         * [2.11. Limit Network Bandwidth](#211-limit-network-bandwidth)
         * [2.12. Remap Default Home Folders (Desktop, Pictures, Downloads, etc.)](#212-remap-default-home-folders-desktop-pictures-downloads-etc)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## Introduction

Here are some tweaks for **Ubuntu 18.04** to speed up and fix some problems. Backup your computer in case of any data loss before starting to apply this guide. I don't recommend applying any fix tweaks if you don't have any related problems. And lastly, read the instructions carefully. Good luck!

**Note: Configurations listed in this guide are not recommended for server environments.**



## To-Do

- [ ] Decrease log amount with filtering
- [ ] Add sources where they are missing
- [ ] https://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that
- [ ] Sound quality decreases while using echo-cancelation
- [ ] S.M.A.R.T. e-mail setup https://help.ubuntu.com/community/EmailAlerts



## 1. Performance Tweaks

### 1.1. Change CPU Scaling Governor to Performance

Intel CPU's reported to be run faster when changed its scaling governor to performance mode. For laptops this may decrease battery life.

**Source:** https://askubuntu.com/questions/1021748/set-cpu-governor-to-performance-in-18-04#comment1820782_1049313

**NOTE:** If you are using a laptop with battery try installing https://extensions.gnome.org/extension/945/cpu-power-manager/ For more information see section [2.10. Gnome Extensions](#210-gnome-extensions)

- Running the following command is enough:

```bash
$ sudo systemctl disable ondemand
```

- Check the CPU governor after reboot:

```bash
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
```



### 1.2. Disable Security Mitigations
Reclaim the CPU power back taken from security patches. It's been years and there are no viruses using these exploits.

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

Preload, monitors user activity and caches programs into RAM. Prefer this if you are using HDD. No need for SSD users.

**Source:** https://www.hecticgeek.com/2013/05/using-preload-ubuntu-13-04/

- Install the program with the following command. No further configurations are needed.

```bash
$ sudo apt install preload
```



### 1.4. Mount /tmp as tmpfs (and Move Browser Cache)

**Source(s):** https://wiki.archlinux.org/index.php/Chromium/Tips_and_tricks#Tmpfs

https://www.linuxliteos.com/forums/other/how-to-limit-chromium-browser's-cache-size/

Mounting `/tmp` folder into RAM, will reduce disk access and increase lifespan of the device. Use this if you have extra ~500MB in your RAM. Internet usage maybe increase, so if you are using metered connection this tweak is not recommended.

- Modify the file which includes 

```bash
$ sudo nano /etc/fstab
```

- Then add the following line:

```
tmpfs /tmp tmpfs rw,nosuid,nodev
```

- Apply changes with the command below. This command should output nothing.

```bash
$ sudo mount -a
```

- Continue with `1.4.1. Configuration for Firefox` and/or `1.4.2. Configuration for Chromium`

#### 1.4.1. Configuration for Firefox

- Enter this URL into Firefox browser:

```
about:config
```

- Find the key **`browser.cache.disk.parent_directory`** and change its value to **`/tmp/firefox-cache`**
- Restart Firefox and check if new cache folder is being used:

```bash
$ ls /tmp/firefox-cache
```

#### 1.4.2. Configuration for Chromium

- Modify chromium settings file:

```bash
$ sudo nano /etc/chromium-browser/default
```

- Replace the line contains **`CHROMIUM_FLAGS=""`** with this: (262144000 byte = 250 MB. I personally go for 1GB cache)

```
CHROMIUM_FLAGS="--disk-cache-size=262144000 --disk-cache-dir=/tmp/chromium-cache"
```

- Restart Chromium and check if new cache folder is being used:

```bash
$ ls /tmp/chromium-cache
```

#### 1.4.3. Configuration for Google Chrome

- Modify Google Chrome executable:

```bash
sudo nano /opt/google/chrome/google-chrome
```

- Modify the last line and make it look like this: (Added --disk-cache parameter. You can add --disk-cache-size parameter like shown in the 1.4.2)

```
exec -a "$0" "$HERE/chrome" "$@" --disk-cache-dir=/tmp
```



### 1.5. Manually Cache Folders with Vmtouch (browsers, apps, etc.)

Select folders/files to cache into virtual memory to improve user experience when cold boot.

**Source:** https://hoytech.com/vmtouch/

- Install vmtouch and configure files/folders list:

```bash
$ sudo apt install vmtouch
$ sudo touch /etc/vmtouch_list
$ sudo chmod 555 /etc/vmtouch_list
$ sudo nano /etc/vmtouch_list
```

- Make your list like located below: (You need to modify this file according to you needs. These folders will be cached into RAM when PC boot up)

```
/usr/lib/chromium-browser/
/home/salih/.config/chromium/
/usr/share/typora/
/usr/share/discord/
```

- Set to run on boot:

```bash
$ sudo crontab -e
```

- Paste the following line:

```
@reboot /usr/bin/vmtouch -f -t -b /etc/vmtouch_list > /etc/vmtouch_log 2>&1
```

- You can check log file `/etc/vmtouch_log` if there are errors or not.



### 1.6. Turn Off Wifi Power Management

Speed up wifi performance. Not recommended for laptops in battery mode.

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
$ sudo touch /usr/bin/zram.sh
$ sudo chmod 555 /usr/bin/zram.sh
$ sudo nano /usr/bin/zram.sh
```

- Paste the following lines: 
  - Note(1): Modify `ZRAM_MEMORY` according to your PC configuration.
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



### 1.9. Disable Unnecessary Services

Reduce memory usage on weak systems about ~300Mb. Be careful and do your search before removing any packages.

**Source:** https://prahladyeri.com/blog/2017/09/how-to-trim-your-new-ubuntu-installation-of-extra-fat-and-make-it-faster.html

```bash
# DISABLE UPDATE/UPGRADE SERVICES (If you do it manually and hate upgrade notifications)
$ sudo apt remove unattended-upgrades # Automatic upgrades
$ sudo mv /etc/xdg/autostart/update-notifier.desktop /etc/xdg/autostart/update-notifier.desktop.old # Disable update notifer
$ sudo mv /etc/xdg/autostart/gnome-software-service.desktop /etc/xdg/autostart/gnome-software-service.desktop.old # Disable gnome software updater

# DISABLE PRINTER SERVICES (If you don't use a printer)
sudo systemctl disable cups 
sudo systemctl disable cups-browsed

# DISABLE THESE SERVICES ON OLD/WEAK SYSTEMS
$ sudo apt remove whoopsie # Error Repoting, remove it on weak systems
$ sudo systemctl mask packagekit.service # Disable if you don't use gnome-software
$ sudo systemctl mask geoclue.service # CAUTION: Disable if you don't use Night Light or location services
$ sudo apt remove gnome-software # Software Store. Remove if you don't use it
$ sudo apt remove deja-dup # Automatic backup tool

# DISABLE EVOLUTION/GNOME-ONLINE-ACCOUNTS (Email, calender, contact sync app. Disable it if you don't use it. It uses a lot of memory)
$ sudo apt remove gnome-online-accounts # Gnome online accounts plugins
$ sudo chmod -x /usr/lib/evolution/evolution-calendar-factory
$ sudo chmod -x /usr/lib/evolution/evolution-addressbook-factory
$ sudo chmod -x /usr/lib/evolution/evolution-source-registry
```



### 1.10. Ext4 Mount with noatime Option

Prevent saving file last access times on the hard drive. Reduces disk access thus improving performance.

```bash
$ sudo nano /etc/fstab
```

- Add `noatime` word like shown below:

`UUID=12242bc2-d367-468e-af75-c6a35bd610ca / ext4 errors=remount-ro,noatime 0 1`

- Reboot the PC



### 1.11. Update On-Board GPU Drivers

Get latest Intel/AMD on-board graphics drivers to support latest features like OpenGL 4.5.

**Source:** https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers?field.series_filter=bionic

```bash
# For Ubuntu 18
$ sudo add-apt-repository ppa:oibaf/graphics-drivers
$ sudo apt update
$ sudo apt install --install-recommends linux-generic-hwe-18.04
$ sudo apt upgrade
$ sudo apt install -f # if it crashes while upgrading
```



### 1.12. Remove Snap Apps (and replace with native apps)

Snap is a software packaging and deployment system developed by Canonical for the Linux operating system. With snap we can install programs like in our smart phones. But in my perspective it doesn't work well and background services use memory a lot. So I can recommend removing snap.

```bash
# Remove Snap and its packages:
$ snap remove gnome-3-34-1804 gnome-calculator gnome-characters gnome-logs gnome-system-monitor gtk-common-themes
$ snap remove core18
$ snap remove snapd
$ sudo apt remove snapd

# Install native version of uninstalled packages:
$ sudo apt install gnome-calculator gnome-characters gnome-logs gnome-system-monitor
```



### 1.13. Change Disk Scheduler (For HDD's)

**Source(s):** https://www.phoronix.com/scan.php?page=article&item=linux-50hdd-io

https://community.chakralinux.org/t/how-to-enable-the-bfq-i-o-scheduler-on-kernel-4-12/6418

- Create a new udev rule:

```bash
$ sudo nano /etc/udev/rules.d/60-scheduler.rules
```

- Add the lines below:

```
# set cfq scheduler for rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
```

- Update grub file:

```bash
$ sudo udevadm control --reload
$ sudo udevadm trigger
```

- After reboot, test with this command:

```bash
$ cat /sys/block/sda/queue/scheduler
```

- The output must be like this:

```
mq-deadline [bfq] none
```



### 1.14. Improve Browser Performance

**Source:**  https://gist.github.com/ibLeDy/1495735312943b9dd646fd9ddf618513

#### 1.14.1 Chromium

I have choosen some flags to set. See the `source` for all usable flags. Type `about:flags` to address bar and do the following modifications:

**Note:** If everything goes wrong start Chromium with `--no-experiments` command line option.

- Experimental QUIC protocol (Enabled)
- Experimental WebAssembly (Enabled)
- WebAssembly baseline compiler (Enabled)
- WebAssembly lazy compilation (Enabled)
- WebAssembly SIMD support. (Enabled)
- WebAssembly threads support (Enabled)
- WebAssembly tiering (Enabled)
- Zero-copy rasterizer (Enabled)
- Tab Groups (Enabled)
- Tab Groups Collapse (Enabled)
- Parallel downloading (Enabled)
- Enable lazy image loading (Enabled - Automati...)
- Enable lazy frame loading  (Enabled - Automati...)
- Parallelize layers (Enabled)
- Heavy Ad Intervention (Enabled)



## 2. Utility/Fix Tweaks

### 2.1. PulseAudio Mic Echo Cancellation Feature

Echo cancellation is a useful tool to have while talking Skype etc **without headphones.**

**Source(s):** https://www.reddit.com/r/linux/comments/2yqfqp/just_found_that_pulseaudio_have_noise/

https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Enable_Echo/Noise-Cancellation

https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-echo-cancel

- `CHOOSE A GUIDE BELOW DEPENDING ON HOW MANY SOUND CARDS YOU ARE USING !!!`

#### 2.1.1. Configuration For One Sound Card

- Run the following command:

```bash
$ sudo nano /etc/pulse/default.pa
```

- Add the following line:

```
load-module module-echo-cancel use_master_format=yes
```

- Reload pulseaudio:

```bash
$ pulseaudio -k
```

- Select echo canceled sources in sound settings.
- Now everything is set up.



#### 2.1.2. Configuration For Multiple Sound Cards

For example you are using usb sound card for output and built-in mic as input.

- Before starting we need `YOUR_SINK_MASTER` and `YOUR_SOURCE_MASTER` values. For getting these values select output and input devices which you are going to use in the sound settings of Ubuntu Settings. These values are `alsa_output.usb-C-Media_Electronics_Inc._USB_Advanced_Audio_Device-00.analog-stereo` and `alsa_input.pci-0000_00_1b.0.analog-stereo` respectively, for my situation.
- For getting the value `YOUR_SINK_MASTER` run the following command:

```bash
$ pactl list short sinks
```

- For getting the value `YOUR_SOURCE_MASTER` run the following command:

```bash
$ pactl list short sources
```

- Run the following command:

```bash
$ sudo nano /etc/pulse/default.pa
```

- Add the following lines: (Replace `YOUR_SINK_MASTER` and `YOUR_SOURCE_MASTER`)

```
load-module module-echo-cancel use_master_format=yes sink_name=sink_ec source_name=source_ec sink_master=YOUR_SINK_MASTER source_master=YOUR_SOURCE_MASTER
set-default-sink sink_ec
set-default-source source_ec
```

- Restart the PC.



### 2.2. PulseAudio Crackling Sound Solution

The newer implementation of the PulseAudio sound server uses  timer-based audio scheduling instead of the traditional,  interrupt-driven approach. Timer-based scheduling may expose issues in some ALSA drivers. On the other hand, other drivers might be glitchy without it on, so check  to see what works on your system. **Apply this tweak if you are having cracking sound issue.**

**Source(s):** https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Glitches,_skips_or_crackling

https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Laggy_sound

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

# And add these lines to prevent popping sounds in some applications
default-fragments = 5
default-fragment-size-msec = 2
```

- Then restart the PulseAudio server: 

```bash
$ pulseaudio -k
$ pulseaudio --start
```

(RESTORE): Do the reverse to enable timer-based scheduling, if not already enabled by default. 



### 2.3. PulseAudio Better Sound Quality

Tweak for audiophiles. Increasing sample rate in exchange of CPU time.

**Source:** https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting

- Modify pulseaudio config file:

```bash
$ sudo nano /etc/pulse/daemon.conf
```

- Add the following lines to the end of the file:

```
default-sample-format = s24ne
default-sample-rate = 44100
alternate-sample-rate = 48000
resample-method = speex-float-5
```

- Restart pulseaudio server:

```bash
$ pulseaudio -k
$ pulseaudio --start
```

- Check PulseAudio values:

```bash
$ watch -n 1 pactl list sinks short
```

**NOTE(1):** If you want to get high quality sound with using echo cancellation feature at the same time, just make sure that echo cancellation module enabled with `load-module module-echo-cancel use_master_format=yes`. For more information see `PulseAudio Mic Echo Cancellation Feature` section and `NOTE(3)` in this section.

**NOTE(2):** I have tried this with 96KHz and speex-float-10 but it end up only with high CPU usage. If you are only a listener, leave it as like in this guide, because pulseaudio will switch between 44.1kHz and 48kHz.

**NOTE(3):** There won't be sample rate switch while using `module-echo-cancel`. Maybe related to a bug in pulseaudio or in the module but I was unable to find anything about it.



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
- **(3) Disable Suspend When Laptop Lid is Closed**
  - `Power` -> `Suspend when laptop lid is closed` -> `OFF`
- **(4) Enable Battery Percentage Showing Up on the Top Bar**
  - `Top Bar` -> `Battery Percentage` -> `ON`
- **(5) Enable Date Showing Up on the Top Bar**
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
  - `Actions` -> `Disable touchpad when mouse plugged` -> `ON`
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



### 2.9. Enable S.M.A.R.T.

Enable S.M.A.R.T. for health checks for disks.

- Install smartmontools:

```bash
$ sudo apt install smartmontools # Select `local` for postfix conf if you are not sure
```

- Enable health check for disks (Example is given for /dev/sda below):

```bash
$ smartctl --scan # Print S.M.A.R.T. available disks.
$ sudo smartctl --smart=on /dev/sda # Enable health check for /dev/sda
```



### 2.10. Gnome Extensions

Increase your productivity and customize your desktop.

- Install required packages:

```bash
$ sudo apt install gnome-shell-extension chromium-browser chrome-gnome-shell
```

- Install Chromium-Gnome Shell plugin:

https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep

- Now you can browse and add some extensions from here: https://extensions.gnome.org/
- If you want to enable/disable extensions natively run this command:

```bash
$ gnome-shell-extension-prefs
```

- Here is a list of extensions which I combined for myself:

  - https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/
  - https://extensions.gnome.org/extension/1236/noannoyance/
  - https://extensions.gnome.org/extension/750/openweather/
  - https://extensions.gnome.org/extension/708/panel-osd/
  - https://extensions.gnome.org/extension/779/clipboard-indicator/
  - https://extensions.gnome.org/extension/800/remove-dropdown-arrows/
  - https://extensions.gnome.org/extension/948/rss-feed/
  - https://extensions.gnome.org/extension/1276/night-light-slider/
  - https://extensions.gnome.org/extension/906/sound-output-device-chooser/



#### 2.10.1. GSConnect

Connect your smartphone to the PC. File sharing, taking photo, sending SMS, media controls, etc.

Note: If you just want the "Send this page to the mobile phone" feature on your browser, just switch from Chromium to Google Chrome. 

- https://extensions.gnome.org/extension/1319/gsconnect/ (gnome extension)
- https://chrome.google.com/webstore/detail/gsconnect/jfnifeihccihocjbfcfhicmmgpjicaec/related?hl=en (chrome extension)
- https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp&hl=en_US&gl=US (to smartphone)



### 2.11. Limit Network Bandwidth

If there are multiple computers connected to a router you can limit your network bandwidth and give a room to breath for other devices.

**Source:** https://askubuntu.com/questions/20872/how-do-i-limit-internet-bandwidth

- Install wondershaper package:

```bash
$ sudo apt install wondershaper
```

- Find your network interface: (For this example my network interface is enp4s0f1)

```bash
$ ifconfig
```

- Limit your bandwidth: (For this example: Download 1024 Kbits / Upload 256 Kbits)

```bash
$ sudo wondershaper enp4s0f1 1024 256
```

(RECOVER) Remove limitations for the adapter:

```bash
$ sudo wondershaper clear enp4s0f1
```



### 2.12. Remap Default Home Folders (Desktop, Pictures, Downloads, etc.)

I maintain a single folder for all my files to make it easier for backup. This is useful for especially for it, and also helps cleaning the home folder.

```bash
$ xdg-user-dirs-update --set DOWNLOAD /path/to/new/downloads_folder
$ xdg-user-dirs-update --set DESKTOP /path/to/new/desktop_folder
$ xdg-user-dirs-update --set DOCUMENTS /path/to/new/documents_folder
$ xdg-user-dirs-update --set PICTURES /path/to/new/pictures_folder
$ xdg-user-dirs-update --set TEMPLATES /path/to/new/templates_folder
```



