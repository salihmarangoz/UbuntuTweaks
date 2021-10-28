<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Utility Tweaks](#utility-tweaks)
  - [&#91;NAUTILUS&#93; Nautilus Git Icons](#nautilus-nautilus-git-icons)
  - [&#91;NAUTILUS&#93; Nautilus Media Properties](#nautilus-nautilus-media-properties)
  - [&#91;UTIL&#93; Disable Touchpad When Mouse is Plugged](#util-disable-touchpad-when-mouse-is-plugged)
  - [&#91;LOG&#93; Enable S.M.A.R.T.](#log-enable-smart)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Utility Tweaks

[toc]

## [NAUTILUS] Nautilus Git Icons

TODO: Doesn't work on Ubuntu 20.04 !!!

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

