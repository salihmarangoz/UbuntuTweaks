# Removed Tweaks

### 1.5. Move Browser Profile to RAM (profile-sync-daemon)

**!!! AFTER SOME UPDATES THIS MODULE MAY PREVENT BROWSERS FROM STARTING. TRY WITH DISABLING IT SO YOU CAN ENABLE IT AGAIN !!!**

Moving Firefox cache will reduce disk access thus increasing the performance in HDD's and improving longevity in SSD's. In order to achieve that we will use `profile-sync-daemon`.

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

- Add the following line and save: (Replace YOURUSERNAMEHERE with your username)

```
YOURUSERNAMEHERE ALL=(ALL) NOPASSWD: /usr/bin/psd-overlay-helper
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