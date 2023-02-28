# Gnome

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Gnome Extensions](#gnome-extensions)
  - [1. GSConnect](#1-gsconnect)
- [Hide Username on the Login Screen](#hide-username-on-the-login-screen)
- [GnomeTweaks (laptop lid suspend, desktop icons etc.)](#gnometweaks-laptop-lid-suspend-desktop-icons-etc)
- [Remap Default Folders (Desktop, Pictures, Downloads, etc.)](#remap-default-folders-desktop-pictures-downloads-etc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Hide Username on the Login Screen

The Gnome login screen normally shows a list of available users to log in as. For those who want to disable showing the user list, and manually type a username to login with, below I will show you how.

**Source:** https://tipsonubuntu.com/2020/05/21/hide-user-list-ubuntu-20-04-login-screen/

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
$ export DISPLAY=:0
$ gsettings set org.gnome.login-screen disable-user-list true
```

(RESTORE): To restore the change, open terminal and **re-do** previous steps, except running the last command with:

```bash
$ gsettings set org.gnome.login-screen disable-user-list false
```



## GnomeTweaks (laptop lid suspend, desktop icons etc.)

There are some tweaks which can increase utility of Gnome. These are tested on Ubuntu 20.04 and may not work on its older versions.

- Install gnome tweaks:

```bash
$ sudo apt install gnome-tweaks
```

- Run the program:

```
$ gnome-tweaks
```

- Here are some configurations which I found them useful:
- **Disable Animations on Very Slow Computers**
  - `General` -> `Animations` -> `OFF`
- **Disable Suspend When Laptop Lid is Closed**
  - `General` -> `Suspend when laptop lid is closed` -> `OFF`
- **Enable Battery Percentage Showing Up on the Top Bar**
  - `Top Bar` -> `Battery Percentage` -> `ON`
- **Enable Date Showing Up on the Top Bar**
  - `Top Bar` -> `Date` -> `ON`



## Remap Default Folders (Desktop, Pictures, Downloads, etc.)

I personally maintain a single folder for all my files to make it easier for backup. This is useful for especially for this case.

```bash
$ xdg-user-dirs-update --set DOWNLOAD /path/to/new/downloads_folder
$ xdg-user-dirs-update --set DESKTOP /path/to/new/desktop_folder
$ xdg-user-dirs-update --set DOCUMENTS /path/to/new/documents_folder
$ xdg-user-dirs-update --set PICTURES /path/to/new/pictures_folder
$ xdg-user-dirs-update --set TEMPLATES /path/to/new/templates_folder
```

