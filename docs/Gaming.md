# Gaming

[toc]

## Playing with an Integrated GPU (Intel/AMD)

Better drivers can be installed. See:

```bash
$ sudo add-apt-repository ppa:oibaf/graphics-drivers
$ sudo apt install --install-recommends linux-generic-hwe-20.04
$ sudo apt upgrade
$ sudo apt install -f # if it crashes while upgrading
```



## Playing with a Dedicated GPU (Nvidia)

Install the latest drivers via:

```bash
$ sudo apt update
$ sudo ubuntu-drivers autoinstall
```



## Playing with a Dedicated GPU (AMD)

I don't have any experience with dedicated AMD cards.


<div class="alert alert-warning"> <b>NOTE</b> Pull Requests Welcome </div>



## Recommended Performance Tweaks

There are some performance tweaks that I can recommend. These may increase power consumption thus decreasing battery life.

Tweaks can be only found here:

- Check BIOS for performance settings. There may be an option for favoring GPU performance. 
- **Very important for gaming laptops! I personally experienced ~20% performance increase.**  If you have a dedicated GPU, check BIOS for the option for disabling the integrated GPU. For example, with Nvidia Optimus games are being rendered on the Nvidia GPU and the frames are being sent to the integrated GPU via PCI-e. If there is a MUX device for plugging out the internal monitor from the integrated GPU and plugging in to the dedicated GPU this may be controlled in BIOS, or maybe in Nvidia Settings if it is Nvidia Advanced Optimus.
- If there is thermal throttling think about changing thermal paste and maybe undervolting the CPU.
- Think about having 2x memory sticks (e.g. 2x 8GB RAM's) to use the benefits of dual channel memory. Also, increasing the available memory gives more room to cache files (if you have an extremely fast SSD, e.g. Samsung 980 Pro plugged to PCI-e 4 slot, then this may not be necessary)

Tweaks from `Performance.md`:

- Keep the CPU in `performance` mode always. This is a recommended modification for some games. (e.g. Tomb Raider) -> https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/docs/Performance.md#cpu-performance-processor-scaling-governor 
- Disable security mitigations (Spectre, Meltdown) to achieve ~10% performance gain in some CPU's. Be aware about the security risks. -> https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/docs/Performance.md#cpu-disable-security-mitigations

- Disable modifying access times for the files to reduce disk writes. https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/docs/Performance.md#cpu-disable-security-mitigations

- Disabling Wifi power save feature may decrease the latency and download/upload speeds in some cards. (For me download/upload speeds improved ~15%) -> https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/docs/Performance.md#net-turn-off-wifi-power-save-feature

Additionally, if you have a slow computer with/without low memory then check the whole document: https://github.com/salihmarangoz/UbuntuTweaks/blob/20.04/docs/Performance.md





## Steam + Proton

Check games before buying and before playing from www.protondb.com if they are running well or need some tweaks.



## Proton GloriousEggroll

Have numerous fixes for many games to be used with Steam. GloriousEggroll needs installation of Wine, Winetricks, etc. See the links below:

- https://github.com/GloriousEggroll/proton-ge-custom#installation
- https://github.com/GloriousEggroll/proton-ge-custom/releases

- https://github.com/GloriousEggroll/proton-ge-custom#enabling



