# Bashrc Easy

## Install / Update:

```bash
$ git clone https://github.com/salihmarangoz/UbuntuTweaks.git
$ cd UbuntuTweaks/etc
$ bash bashrc_easy_installer.sh
```

## Print Available Commands:

```bash
$ help_bashrc
```

Which outputs a text like this:

```
[*] Parameters:
BASHRC_EASY_FILES: /home/salih/.bashrc.easy.files
BASHRC_CPU_THREADS: 2

[*] Available commands:
fix-skype                 --> Kills Skype background processes without terminating the program
jekyll_server             --> Starts jekyll docker used for rendering github.io webpages
android_remote_control    --> Android screenshare to the PC. Enable USB debugging on android, then connect with a USB.
no_network                --> Start $@ with no internet connection
py                        --> Shorter version of python3
gitaddcommitpush          --> Adds all files in the current location, commits @1 and pushes to the origin
temp_chromium             --> Temporary chromium-browser. Can be reset with temp_chromium_reset
temp_chromium_reset       --> Describes instructions for resetting temp_chromium profile
dif                       --> Colorful alternative to "diff", using git diff
scan_text                 --> Select an area on the screen to run OCR and get text output
scan_qrcode               --> Select an area on the screen to run zbarimg and get text output
enhance_image             --> Neural image enhancer with 2x resolution increase
compress_audio            --> Compress audio with MP3
compress_video            --> Compress videos with Vary the Constant Rate Factor to MP4
summarize_video           --> Summarizes the video by deleting duplicate frames
stabilize_video           --> Stabilizes/deshakes video by using vid.stab ffmpeg plugin
```
