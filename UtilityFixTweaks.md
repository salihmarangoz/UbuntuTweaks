# Utility/Fix Tweaks

   * [Utility/Fix Tweaks](#utilityfix-tweaks)
      * [[AUDIO] PulseAudio Mic Echo Cancellation Feature](#audio-pulseaudio-mic-echo-cancellation-feature)
         * [1. Configuration For One Sound Card](#1-configuration-for-one-sound-card)
         * [2. Configuration For Multiple Sound Cards](#2-configuration-for-multiple-sound-cards)
      * [[AUDIO] PulseAudio Crackling Sound Solution](#audio-pulseaudio-crackling-sound-solution)
      * [[AUDIO] PulseAudio Better Sound Quality](#audio-pulseaudio-better-sound-quality)
      * [[GNOME] Hide User List in Ubuntu 18.04 Login Screen](#gnome-hide-user-list-in-ubuntu-1804-login-screen)
      * [[GNOME] GnomeTweaks (laptop lid suspend, desktop icons etc.)](#gnome-gnometweaks-laptop-lid-suspend-desktop-icons-etc)
      * [[GNOME] Gnome Extensions](#gnome-gnome-extensions)
         * [1. GSConnect](#1-gsconnect)
      * [[GNOME] Remap Default Home Folders (Desktop, Pictures, Downloads, etc.)](#gnome-remap-default-home-folders-desktop-pictures-downloads-etc)
      * [[NAUTILUS] Nautilus Git Icons](#nautilus-nautilus-git-icons)
      * [[NAUTILUS] Nautilus Media Properties](#nautilus-nautilus-media-properties)
      * [[UTIL] Disable Touchpad When Mouse is Plugged](#util-disable-touchpad-when-mouse-is-plugged)
      * [[LOG] Enable S.M.A.R.T.](#log-enable-smart)
      * [[LOG] Delete Log Archives Regularly](#log-delete-log-archives-regularly)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## [AUDIO] PulseAudio Mic Echo Cancellation Feature

Echo cancellation is a useful tool to have while talking Skype etc **without headphones.**

**Source(s):** https://www.reddit.com/r/linux/comments/2yqfqp/just_found_that_pulseaudio_have_noise/

https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Enable_Echo/Noise-Cancellation

https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-echo-cancel

### 1. Configuration For One Sound Card

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



### 2. Configuration For Multiple Sound Cards

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



## [AUDIO] PulseAudio Crackling Sound Solution

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



## [AUDIO] PulseAudio Better Sound Quality

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



## [GNOME] Hide User List in Ubuntu 18.04 Login Screen

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



## [GNOME] GnomeTweaks (laptop lid suspend, desktop icons etc.)

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


## [GNOME] Gnome Extensions

Increase your productivity and customize your desktop.

- Install required packages:

```bash
$ sudo apt install gnome-shell-extensions chromium-browser chrome-gnome-shell
```

- Install Chromium-Gnome Shell plugin:

https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep

- Now you can browse and add some extensions from here: https://extensions.gnome.org/
- If you want to enable/disable extensions natively run this command:

```bash
$ gnome-shell-extension-prefs
```

- Here is a list of extensions which I combined for myself:

  - https://extensions.gnome.org/extension/6/applications-menu/
  - https://extensions.gnome.org/extension/1262/bing-wallpaper-changer/
  - https://extensions.gnome.org/extension/2386/calendar-improved/
  - https://extensions.gnome.org/extension/1276/night-light-slider/
  - https://extensions.gnome.org/extension/1236/noannoyance/
  - https://extensions.gnome.org/extension/750/openweather/
  - https://extensions.gnome.org/extension/1403/remove-alttab-delay/
  - https://extensions.gnome.org/extension/800/remove-dropdown-arrows/
  - https://extensions.gnome.org/extension/906/sound-output-device-chooser/

### 1. GSConnect

Connect your smartphone to the PC. File sharing, taking photo, sending SMS, media controls, etc.

Note: If you just want the "Send this page to the mobile phone" feature on your browser, just switch from Chromium to Google Chrome. 

- https://extensions.gnome.org/extension/1319/gsconnect/ (gnome extension)
- https://chrome.google.com/webstore/detail/gsconnect/jfnifeihccihocjbfcfhicmmgpjicaec/related?hl=en (chrome extension)
- https://play.google.com/store/apps/details?id=org.kde.kdeconnect_tp&hl=en_US&gl=US (to smartphone)



## [GNOME] Remap Default Home Folders (Desktop, Pictures, Downloads, etc.)

I maintain a single folder for all my files to make it easier for backup. This is useful for especially for it, and also helps cleaning the home folder.

```bash
$ xdg-user-dirs-update --set DOWNLOAD /path/to/new/downloads_folder
$ xdg-user-dirs-update --set DESKTOP /path/to/new/desktop_folder
$ xdg-user-dirs-update --set DOCUMENTS /path/to/new/documents_folder
$ xdg-user-dirs-update --set PICTURES /path/to/new/pictures_folder
$ xdg-user-dirs-update --set TEMPLATES /path/to/new/templates_folder
```



## [NAUTILUS] Nautilus Git Icons

See the source for the installation procedure. Image below taken from the original project repository. 

**Source:** https://github.com/chrisjbillington/git-nautilus-icons

![](https://github.com/chrisjbillington/git-nautilus-icons/raw/master/screenshot_caja.png)



## [NAUTILUS] Nautilus Media Properties

Right-click a file and select properties. Now there is a new tab for media properties.

**Source:** https://github.com/linux-man/nautilus-mediainfo

```bash
$ sudo add-apt-repository ppa:caldas-lopes/ppa
$ sudo apt install nautilus-mediainfo
$ nautilus -q # kill nautilus
```



## [UTIL] Disable Touchpad When Mouse is Plugged

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


## [LOG] Enable S.M.A.R.T.

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

## [LOG] Delete Log Archives Regularly

Old logs sometimes hold a lot of space on disk. 

- Edit cron (you can select `nano` as editor):

```bash
$ sudo crontab -e
```

- Add the following line (press `ctrl+x` then answer with `y` to save the file):

```
@reboot /usr/bin/find /var/log -name "*.gz" -type f -delete
```
