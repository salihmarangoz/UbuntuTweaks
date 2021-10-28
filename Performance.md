# Performance Tweaks

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Performance Tweaks](#performance-tweaks)
- [TODO: xanmod does some of them. Seperate topics.](#todo-xanmod-does-some-of-them-seperate-topics)
  - [&#91;CPU&#93; Performance Processor Scaling Governor](#cpu-performance-processor-scaling-governor)
  - [&#91;CPU&#93; Disable Security Mitigations](#cpu-disable-security-mitigations)
  - [&#91;RAM&#93; Compressed Memory](#ram-compressed-memory)
  - [&#91;GPU&#93; Update On-Board GPU Drivers](#gpu-update-on-board-gpu-drivers)
  - [&#91;HDD&#93; Ext4 Mount with noatime Option](#hdd-ext4-mount-with-noatime-option)
  - [&#91;HDD&#93; Preload](#hdd-preload)
  - [&#91;HDD&#93; Manually Cache Folders (browsers, apps, etc.)](#hdd-manually-cache-folders-browsers-apps-etc)
  - [&#91;HDD&#93; BFQ Disk Scheduler](#hdd-bfq-disk-scheduler)
  - [&#91;HDD/SSD&#93; Disable Default Swapfile on Disk](#hddssd-disable-default-swapfile-on-disk)
  - [&#91;HDD&#93; Defrag & Optimize Ext4 Partitions](#hdd-defrag--optimize-ext4-partitions)
  - [&#91;SSD&#93; SSD Scheduler](#ssd-ssd-scheduler)
  - [&#91;NET&#93; Turn Off Wifi Power Save Feature](#net-turn-off-wifi-power-save-feature)
  - [&#91;NET&#93; Faster TCP (BBR, Fast TCP Open)](#net-faster-tcp-bbr-fast-tcp-open)
  - [&#91;OS&#93; Disable Unnecessary Services](#os-disable-unnecessary-services)
  - [&#91;EXE&#93; Improve Browser Performance](#exe-improve-browser-performance)
    - [1.14.1 Chrome Stable](#1141-chrome-stable)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# TODO: xanmod does some of them. Seperate topics.


## [CPU] Performance Processor Scaling Governor

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



## [CPU] Disable Security Mitigations
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
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off"
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


## [RAM] Compressed Memory

If your PC is out of memory or has no extra space for caching, give it a shot!

- Create ZRAM script:

```bash
$ sudo touch /usr/bin/zram.sh
$ sudo chmod 555 /usr/bin/zram.sh
$ sudo nano /usr/bin/zram.sh
```

- Paste the following lines: 
  - Note(1): Modify `ZRAM_MEMORY` according to your PC configuration. Half of the original RAM would be good to go.
  - Note(2): Change `lz4` to `zstd` to increase compress ratio, but will cost CPU time. Source: https://github.com/facebook/zstd
  - Note(3): Some other scripts on the Internet create zram devices depending on CPU cores, but it is not needed since multiple streams can be set for one single device.

```
##########################
ZRAM_MEMORY=2048
##########################
set -x
CORES=$(nproc --all)
modprobe zram
ZRAM_DEVICE=
while [ -z "$ZRAM_DEVICE" ] 
do
	ZRAM_DEVICE=$(zramctl --find --size "$ZRAM_MEMORY"M --streams $CORES --algorithm lz4)
	sleep 5
done
mkswap $ZRAM_DEVICE
swapon --priority 5 $ZRAM_DEVICE
```

- Set the script run on boot:

```bash
$ sudo crontab -e
```

- Paste the following lines:

```
@reboot /bin/bash /usr/bin/zram.sh
```

- Reboot the PC. Check the swap memory via `htop`.


## [GPU] Update On-Board GPU Drivers

Get latest Intel/AMD on-board graphics drivers to support latest features like OpenGL 4.5.

**Source:** https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers?field.series_filter=focal

```bash
# For Ubuntu 18
$ sudo add-apt-repository ppa:oibaf/graphics-drivers
$ sudo apt update
$ sudo apt install --install-recommends linux-generic-hwe-20.04
$ sudo apt upgrade
$ sudo apt install -f # if it crashes while upgrading
```


## [HDD] Ext4 Mount with noatime Option

Prevent saving file last access times on the hard drive. Reduces disk access thus improving performance.

```bash
$ sudo nano /etc/fstab
```

- Add `noatime` word like shown below:

`UUID=12242bc2-d367-468e-af75-c6a35bd610ca / ext4 errors=remount-ro,noatime 0 1`

- Reboot the PC




## [HDD] Preload

Preload, monitors user activity and caches programs into RAM. Prefer this if you are using HDD. No need for SSD users.

**Source:** https://www.hecticgeek.com/2013/05/using-preload-ubuntu-13-04/

- Install the program with the following command. No further configurations are needed.

```bash
$ sudo apt install preload
```


## [HDD] Manually Cache Folders (browsers, apps, etc.)

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


## [HDD] BFQ Disk Scheduler

**Source(s):** https://www.phoronix.com/scan.php?page=article&item=linux-50hdd-io

https://community.chakralinux.org/t/how-to-enable-the-bfq-i-o-scheduler-on-kernel-4-12/6418

- Edit grub file:

```bash
$ sudo nano /etc/default/grub
```

- Add `scsi_mod.use_blk_mq=1` to `GRUB_CMDLINE_LINUX_DEFAULT="..."` then save the file. Update grup configuration:

```bash
$ sudo update-grub
```

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

## [HDD/SSD] Disable Default Swapfile on Disk

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

## [HDD] Defrag & Optimize Ext4 Partitions

```bash
###############################################
########## VERY IMPORTANT !!! #################
# BOOT PC FROM A UBUNTU IMAGE USB STICK #######
###############################################
$ sudo fsck.ext4 -y -f -v -D /dev/sdX
# Now mount the partition, then run:
$ sudo e4defrag -v /dev/sdX
```



## [SSD] SSD Scheduler

TODO



## [NET] Turn Off Wifi Power Save Feature

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



## [NET] Faster TCP (BBR, Fast TCP Open)

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



## [OS] Disable Unnecessary Services

Reduce memory usage on weak systems about ~300Mb. Be careful and do your search before removing any packages.

**Source:** https://prahladyeri.com/blog/2017/09/how-to-trim-your-new-ubuntu-installation-of-extra-fat-and-make-it-faster.html

```bash
# DISABLE UPDATE/UPGRADE SERVICES (If you do it manually and hate upgrade notifications)
$ sudo apt remove unattended-upgrades # Automatic upgrades
$ sudo mv /etc/xdg/autostart/update-notifier.desktop /etc/xdg/autostart/update-notifier.desktop.old # Disable update notifer

# DISABLE THESE SERVICES ON OLD/WEAK SYSTEMS
$ sudo apt remove whoopsie # Error Repoting, remove it on weak systems
$ sudo systemctl mask packagekit.service # Disable if you don't use gnome-software
$ sudo systemctl mask geoclue.service # CAUTION: Disable if you don't use Night Light or location services
$ sudo apt remove gnome-software # Software Store. Remove if you don't use it

# DISABLE EVOLUTION/GNOME-ONLINE-ACCOUNTS (Email, calender, contact sync app. Disable it if you don't use it. It uses a lot of memory)
$ sudo apt remove gnome-online-accounts # Gnome online accounts plugins
$ sudo chmod -x /usr/lib/evolution/evolution-calendar-factory
$ sudo chmod -x /usr/lib/evolution/evolution-addressbook-factory
$ sudo chmod -x /usr/lib/evolution/evolution-source-registry
```



## [EXE] Improve Browser Performance

**Source:**  https://gist.github.com/ibLeDy/1495735312943b9dd646fd9ddf618513

### 1.14.1 Chrome Stable

I have choosen some flags to set. See the `source` for all usable flags. Type `about:flags` to address bar and do the following modifications:

**Note:** If something goes wrong start Chrome Stable with `--no-experiments` command line option.

- Experimental WebAssembly (Enabled)
- WebAssembly baseline compiler (Enabled)
- WebAssembly lazy compilation (Enabled)
- WebAssembly SIMD support. (Enabled)
- WebAssembly threads support (Enabled)
- WebAssembly tiering (Enabled)
- Zero-copy rasterizer (Enabled)
- Parallel downloading (Enabled)
