# Install Ubuntu



## 1. Create an Ubuntu Installer Medium

1. You can download the ISO [on this page](https://ubuntu.com/download/desktop). I would recommend downloading versions like xx.04.x (e.g. 22.04.2), because this the LTS version of Ubuntu which means five years of free security and maintenance updates.

2. Flash to a USB stick using [balenaEtcher](https://www.balena.io/etcher) (my favorite tool).

## 2. Reboot into BIOS

I prefer disabling Secure Boot, because it is creating some issues and extra work for no to little gain.

## 3. Partitioning



## 4. Naming



## Possible Problems and Fixes

### Can't Boot Windows After Installation?

[Boot-Repair page](https://help.ubuntu.com/community/Boot-Repair) can be easily found with "ubuntu boot fix" keywords searched with Google. This tool is aimed entirely at those new to Ubuntu who want to get past their booting issues and enjoy using Linux.

**TLDR;** Install and run the Boot-Repair tool using the command below and follow the instructions on the app:

```bash
$ sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt update
$ sudo apt install -y boot-repair && boot-repair
```

