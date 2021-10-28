# Utility Tweaks

<!-- START doctoc -->
<!-- END doctoc -->

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

