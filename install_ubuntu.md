<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Install Ubuntu](#install-ubuntu)
  - [1. Create an Ubuntu Installer Medium](#1-create-an-ubuntu-installer-medium)
  - [2. Reboot into BIOS](#2-reboot-into-bios)
  - [3. Partitioning](#3-partitioning)
  - [4. Naming](#4-naming)
  - [Possible Problems and Fixes](#possible-problems-and-fixes)
    - [Can't Boot Windows After Installation?](#cant-boot-windows-after-installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Install Ubuntu



## 1. Create an Ubuntu Installer Medium

1. You can download the ISO [on this page](https://ubuntu.com/download/desktop). I would recommend downloading versions like xx.04.x (e.g. 22.04.2), because this the LTS version of Ubuntu which means five years of free security and maintenance updates.

2. Flash to a USB stick using [balenaEtcher](https://www.balena.io/etcher) (my favorite tool).

## 2. Reboot into BIOS

I prefer disabling Secure Boot, because it is creating some issues and extra work for no to little gain.

## 3. Installation Type (partitioning)



## 4. Updates and Other Software

normal installation + third party software



## 5. Naming



## Possible Problems and Fixes

### Can't Boot Windows After Installation?

[Boot-Repair page](https://help.ubuntu.com/community/Boot-Repair) can be easily found with "ubuntu boot fix" keywords searched with Google. This tool is aimed entirely at those new to Ubuntu who want to get past their booting issues and enjoy using Linux.

**TLDR;** Install and run the Boot-Repair tool using the command below and follow the instructions on the app:

```bash
$ sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt update
$ sudo apt install -y boot-repair && boot-repair
```

