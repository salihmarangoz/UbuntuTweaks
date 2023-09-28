## Install Ubuntu

- Install Ubuntu 22.04
  - 200MB efi
  - 500MB ext4 /boot
  - 16384MB swap (for hibernation)
  - 733071MB btrfs /
- Remote installation for my case

```bash
sudo apt update
sudo apt remove unattended-upgrades
sudo apt install openssh-server
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo apt install ./teamviewer_amd64.deb
```

- Upgrade

```bash
sudo apt full-upgrade
```

## Hibernation

- https://ubuntuhandbook.org/index.php/2021/08/enable-hibernate-ubuntu-21-10/

- https://support.system76.com/articles/enable-hibernation/
- Also add `mitigations=off`

```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off resume=UUID=8e8ece1c-1428-4180-9d8f-3562f5023ae9"
```

- ```bash
  sudo apt install chrome-gnome-shell
  ```

- ```bash
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb
  ```

- 

## Various Tweaks

- Preload

```bash
sudo apt install preload
```

- S.M.A.R.T.
  - https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/Utility.md#log-enable-smart
- https://github.com/salihmarangoz/easy_bash_utilities
- https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/Applications.md
- https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/Gnome.md

## Google Chrome

- https://chrome.google.com/webstore/detail/youtube-nonstop/nlkaejimjacpillmajjnopmpbkbnocid?hl=en
- https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en
- https://chrome.google.com/webstore/detail/sponsorblock-for-youtube/mnjggcdmjocbbbhaepdhchncahnbgone/related

## Switch from Wayland to Xorg

........

## Configure BTRFS

- noatime and compress for all btrfs subvolumes

  - ```
    UUID=ba4e6752-61cc-4be7-b358-57971a0e880f /               btrfs   defaults,noatime,compress-force=zstd:10,subvol=@ 0       1
    
    UUID=ba4e6752-61cc-4be7-b358-57971a0e880f /home           btrfs   defaults,noatime,compress=zstd,subvol=@home 0       2
    ```
    
  - `sudo mount -a` and reboot

- Compress root
  - https://askubuntu.com/questions/129063/will-btrfs-automatically-compress-existing-files-when-compression-is-enabled
  
  - ```bash
    find / -xdev \( -type f -o -type d \) -exec btrfs filesystem defragment -v -czstd -- {} +
    ```
  
  - ```bash
    sudo apt install btrfs-compsize
    sudo compsize -x /
    ```
  
- Compress home
  
  - ```bash
    find /home -xdev \( -type f -o -type d \) -exec btrfs filesystem defragment -v -czstd -- {} +
    sudo compsize -x /home
    ```
  
  - 
  
- No-COW for VM images
  - install virtualbox and vmware

## Lastly, Take Snapshots



## TODO

snapper & apt-snapper-btrfs https://www.reddit.com/r/debian/comments/pajxbf/apt_snapper_snapshot/
