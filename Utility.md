# Utility Tweaks

   * [Utility/Fix Tweaks](#utilityfix-tweaks)
      * [[AUDIO] PulseAudio Mic Echo Cancellation Feature](#audio-pulseaudio-mic-echo-cancellation-feature)
         * [1. Configuration For One Sound Card](#1-configuration-for-one-sound-card)
         * [2. Configuration For Multiple Sound Cards](#2-configuration-for-multiple-sound-cards)
      * [[AUDIO] PulseAudio Crackling Sound Solution](#audio-pulseaudio-crackling-sound-solution)
      * [[AUDIO] PulseAudio Better Sound Quality](#audio-pulseaudio-better-sound-quality)
      * [[GNOME] Hide User List in Ubuntu 20.04 Login Screen](#gnome-hide-user-list-in-ubuntu-2004-login-screen)
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
load-module module-echo-cancel use_master_format=1 rate=48000
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
load-module module-echo-cancel use_master_format=1 rate=48000 sink_name=sink_ec source_name=source_ec sink_master=YOUR_SINK_MASTER source_master=YOUR_SOURCE_MASTER
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

TODO: DOESNT WORK WITH NVME DEVICES.

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

