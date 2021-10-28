<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

  - [LD_PRELOAD](#ld_preload)
- [&#91;UTIL&#93; Disable Touchpad When Mouse is Plugged](#util-disable-touchpad-when-mouse-is-plugged)
- [&#91;LOG&#93; Enable S.M.A.R.T.](#log-enable-smart)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### LD_PRELOAD

(not tested yet)

- https://github.com/whitequark/unrandom
- https://github.com/sickill/stderred
- https://github.com/vi/timeskew
- https://github.com/FiloSottile/otherport
- https://github.com/libhugetlbfs/libhugetlbfs
- https://github.com/jacereda/fsatrace
- https://github.com/lilydjwg/stdoutisatty
- https://github.com/jktr/arg-inject
- https://github.com/taeguk/free_checker
- https://github.com/msantos/libproxyproto
- https://github.com/de-vri-es/inet-remap
- https://github.com/msantos/libsockfilter
- https://github.com/majek/fluxcapacitor



--------



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

