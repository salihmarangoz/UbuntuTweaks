# Removed Tweaks (Don't Use)


## [HDD] Mount /tmp as tmpfs (and Move Browser Cache)

**Source(s):** https://wiki.archlinux.org/index.php/Chromium/Tips_and_tricks#Tmpfs

https://www.linuxliteos.com/forums/other/how-to-limit-chromium-browser's-cache-size/

Mounting `/tmp` folder into RAM, will reduce disk access and increase lifespan of the device. Use this if you have extra ~500MB in your RAM. Internet usage maybe increase, so if you are using metered connection this tweak is not recommended.

- Modify the file which includes 

```bash
$ sudo nano /etc/fstab
```

- Then add the following line:

```
tmpfs /tmp tmpfs rw,nosuid,nodev
```

- Apply changes with the command below. This command should output nothing.

```bash
$ sudo mount -a
```

- Continue with `1.4.1. Configuration for Firefox` and/or `1.4.2. Configuration for Chromium`

### 1. Configuration for Firefox

- Enter this URL into Firefox browser:

```
about:config
```

- Find the key **`browser.cache.disk.parent_directory`** and change its value to **`/tmp/firefox-cache`**
- Restart Firefox and check if new cache folder is being used:

```bash
$ ls /tmp/firefox-cache
```

### 2. Configuration for Chromium

- Modify chromium settings file:

```bash
$ sudo nano /etc/chromium-browser/default
```

- Replace the line contains **`CHROMIUM_FLAGS=""`** with this: (262144000 byte = 250 MB. I personally go for 1GB cache)

```
CHROMIUM_FLAGS="--disk-cache-size=262144000 --disk-cache-dir=/tmp/chromium-cache"
```

- Restart Chromium and check if new cache folder is being used:

```bash
$ ls /tmp/chromium-cache
```

### 3. Configuration for Google Chrome

- Modify Google Chrome executable:

```bash
sudo nano /opt/google/chrome/google-chrome
```

- Modify the last line and make it look like this: (Added --disk-cache parameter. You can add --disk-cache-size parameter like shown in the 1.4.2)

```
exec -a "$0" "$HERE/chrome" "$@" --disk-cache-dir=/tmp
```

