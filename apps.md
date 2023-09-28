<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Applications](#applications)
  - [App Installation Sources](#app-installation-sources)
    - [APT](#apt)
    - [Apps for GNOME](#apps-for-gnome)
    - [KDE Applications](#kde-applications)
    - [Flathub](#flathub)
    - [Snap](#snap)
    - [AppImage](#appimage)
    - [Closed Source](#closed-source)
  - [My Favorites](#my-favorites)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Applications

App sources:

-  [APT](https://ubuntu.com/server/docs/package-management): Default Ubuntu package manager. First choice if possible.
-  [Flathub](https://flathub.org/home): Installation of flatpak is needed. See the [Ubuntu Quick Setup](https://flatpak.org/setup/Ubuntu) guide. 
-  [Snap](https://snapcraft.io/store):  Comes pre-installed with Ubuntu.                             
-  [Apps for GNOME](https://apps.gnome.org/): Apps primarily designed for Gnome.                           
-  [KDE Applications](https://apps.kde.org/): Apps primarily designed for KDE.                             
-  [AppImage](https://appimage.org/): Linux apps that run anywhere.                                
-  [Docker Hub](https://hub.docker.com/search?q=): You may find some applications here, but prefer Flathub, Snap or AppImage if possible. 

## My Favorite Apps

| Open Source? Wine?                   | App Name           | Description                                                  | Notes                                                        | How to install                                               |
| ------------------------------------ | ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| :heavy_multiplication_x:             | Typora             | Markdown editor.                                             | I recommend enabling `inline math` and `highlight` syntax support in the settings. | Look for the **0.11.18** deb file on the internet for the latest free version. Otherwise [see](https://typora.io/). |
| :heavy_multiplication_x:             | Sublime Merge      | Git client from the makers of Sublime Text.                  |                                                              | [Here](https://www.sublimemerge.com/docs/linux_repositories) |
| :ballot_box_with_check:              | OnlyOffice         | Office apps.                                                 | Handles MS Office files better.                              | `$ sudo snap install onlyoffice-ds onlyoffice-desktopeditors` |
| :ballot_box_with_check:              | Krita              | Painting Software                                            | For creating art.                                            | `$ sudo snap install krita`                                  |
| :ballot_box_with_check:              | Peek               | Flexible screenrecorder.                                     |                                                              | [Here](https://github.com/phw/peek#ubuntu)                   |
| :ballot_box_with_check:              | LocalSend          | Share files to nearby devices.                               | Supports Windows, macOS, Linux, Android and iOS              | [Here](https://localsend.org/#/)                             |
| :ballot_box_with_check:              | Balena Etcher      | Flash your OS installer into your USB stick.                 |                                                              | [Here](https://www.balena.io/etcher/)                        |
| :ballot_box_with_check:              | OBS Studio         | Video recording and streaming.                               |                                                              | [Here](https://obsproject.com/wiki/install-instructions#linux) |
| :ballot_box_with_check:              | yt-dlp             | Youtube downloader.                                          |                                                              | [Here](https://github.com/yt-dlp/yt-dlp/wiki/Installation)   |
| :ballot_box_with_check:              | TeXstudio          | LaTeX editor.                                                | Needs some disk space to install.                            | `$ sudo apt-get install --install-suggests texstudio* texlive-*` |
| :ballot_box_with_check:              | PDF Arranger       | Merge, split, rotate, crop, rearrange PDF documents.         | Do not install via snap. Some install sources may be outdated. If it is installed from multiple sources remove until one left. | [Here](https://github.com/pdfarranger/pdfarranger)           |
| :ballot_box_with_check:              | DDC/CI control     | Control your monitor's brightness etc. using a media cable (e.g. HDMI). | Also see its gnome extension: [Here](https://extensions.gnome.org/extension/2944/ddc-brightness-control/) | [Here](https://github.com/ddccontrol/ddccontrol#installation-from-official-packages) |
| :ballot_box_with_check:              | nautilus-mediainfo | View media information in the properties tab.                | Run `$ nautilus -q` after installation to stop the already running process. | [Here](https://github.com/linux-man/nautilus-mediainfo)      |
| :ballot_box_with_check:              | git-nautilus-icons | Marks git status to file/folder icons.                       | ![](https://github.com/chrisjbillington/git-nautilus-icons/raw/master/screenshot_nautilus.png) | [Here](https://github.com/chrisjbillington/git-nautilus-icons#installation) |
| :heavy_multiplication_x::wine_glass: | SpaceSniffer       | Alternative to baobab.                                       |                                                              | [Here](http://www.uderzo.it/main_products/space_sniffer/index.html) |
| :heavy_multiplication_x::wine_glass: | Anti-Twin          | Duplicate file finder with byte and image comparison features. |                                                              | [Here](http://www.joerg-rosenthal.com/en/antitwin/)          |





- From Ubuntu repositories:

  ```bash
  # okular: PDF Reader
  $ sudo apt install \
  	okular
  ```

  
