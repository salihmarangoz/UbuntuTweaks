# Gaming

[toc]

## Drivers

### Integrated GPU Driver (Intel/AMD)

Better drivers can be installed. See:

```bash
$ sudo add-apt-repository ppa:oibaf/graphics-drivers
$ sudo apt install --install-recommends linux-generic-hwe-20.04
$ sudo apt upgrade
$ sudo apt install -f # if it crashes while upgrading
```



### Dedicated GPU Driver (Nvidia)

Install the latest drivers via:

```bash
$ sudo apt update
$ sudo ubuntu-drivers autoinstall
```



### Dedicated GPU Driver (AMD)

**`HELP NEEDED HERE. PULL REQUESTS WELCOME`**



## Steam + Proton

Check games before buying and before playing from www.protondb.com if they are running well, able to run on Linux, or need some tweaks.

**Also check tweaks noted here: https://www.protondb.com/help/improving-performance**



### Proton GloriousEggroll

Have numerous fixes for many games to be used with Steam. GloriousEggroll needs installation of Wine, Winetricks, etc. See the links below:

- https://github.com/GloriousEggroll/proton-ge-custom#installation
- https://github.com/GloriousEggroll/proton-ge-custom/releases

- https://github.com/GloriousEggroll/proton-ge-custom#enabling



### Steam Launch Options

Steam allows setting launch options per game. Always check www.protondb.com before playing for the first time for a better experience. Set the launch option similar to this:

```
WINE_FULLSCREEN_FSR=1 VKD3D_CONFIG=upload_hvv gamemoderun %command%
```

Some selected options I think that are useful:

- **`VKD3D_CONFIG=upload_hvv`** -> Enables support for vkd3d/dx12 Resizable BAR which may result in performance improvements in some games up to ~20%. Check if Resizable BAR is enabled on your GPU. GloriousEggroll achieved performance boost in Forza Horizon 4 with just enabling this option and achieving 25 FPS boost (133 to 160). See the video and the description: https://www.youtube.com/watch?v=wKIw2X2-bDg

- **`WINE_FULLSCREEN_FSR=1`** -> Enables AMD FidelityFX Super Resolution (FSR) for upscaling rendered frames. This is similar to Nvidia DLSS technology. If you have a 3K/4K screen then you can render frames in 1080p and upscale to your monitor's resolution with this option. 

- **`DXVK_FRAME_RATE=165`** -> Limits frame rate to 165 FPS. Set this value as you like. Sometimes limiting framerate is not supported in games which may cause overheating or very high noise because of the high fan speeds. I recommend to set this value starting from 60 up to to your monitor's refresh rate.

- **`PULSE_LATENCY_MSEC=100`** -> Sometimes audio may be popping or crackling in some games (e.g. Red Dead Redemption 2). This option may solve your problem.

- **`MANGOHUD=1`** -> Enables MangoHUD for tracking CPU/GPU utilization, frame times, frame rates etc. Needs installation: https://github.com/flightlessmango/MangoHud

- **`__GL_THREADED_OPTIMIZATION=1`** -> May increase FPS in some OpenGL games, but also decrease the performance and stability. Use wisely!

- **`__NV_PRIME_RENDER_OFFLOAD=1`** -> Forces using Nvidia dGPU. Instead of using this option try to disable iGPU if possible for better performance.

  

Some selected launch options for some games (may not work perfectly for your system):

- **Red Dead Redemption 2** -> `PULSE_LATENCY_MSEC=100  VKD3D_CONFIG=upload_hvv gamemoderun %command% -height 2560 -width 1440 -fullscreen -high -USEALLAVAILABLECORES -ignorepipelinecache -sgadriver=Vulkan`
- **Bioshock Infinite** -> `PROTON_NO_ESYNC=1 PROTON_NO_FSYNC=1 VKD3D_CONFIG=upload_hvv DXVK_LOG_LEVEL=none gamemoderun %command%`
- **Grand Theft Auto IV** -> `D3D_CONFIG=upload_hvv WINE_FULLSCREEN_FSR=1 gamemoderun %command%`
- **The Witcher 3** -> `PROTON_NO_ESYNC=1 DXVK_LOG_LEVEL=none FULLSCREEN_FSR=1 VKD3D_CONFIG=upload_hvv gamemoderun %command%`
- **Frostpunk** -> `VKD3D_CONFIG=upload_hvv gamemoderun %command%`
- **Death Stranding** -> `gamemoderun %command%` (Use Proton 6.3 if you are having online connection problem)
- **Tomb Raider** -> `PROTON_NO_ESYNC=1 PROTON_NO_FSYNC=1 __GL_THREADED_OPTIMIZATION=1 WINE_FULLSCREEN_FSR=1 VKD3D_CONFIG=upload_hvv gamemoderun %command%`



## Recommended Performance Tweaks

There are some performance tweaks that I can recommend. As these tweaks may change the computer's power states,  power consumption may be increased thus decreasing battery life. See the tweaks below:

- Check BIOS for performance settings. There may be an option for favoring GPU performance, e.g. giving more room for boosting.
- **Very important for gaming laptops! I personally experienced ~20% performance increase.**  
  - If you have a dedicated GPU, check BIOS for the option for disabling the integrated GPU. For example, with Nvidia Optimus games are being rendered on the Nvidia GPU and the frames are being sent to the integrated GPU via PCI-e. If there is a MUX device for plugging out the internal monitor from the integrated GPU and plugging in to the dedicated GPU this may be controlled in BIOS, or maybe in Nvidia Settings if it is Nvidia Advanced Optimus. 
  - If you don't have the previous option, external display output may be connected to the dedicated GPU. Using an external monitor would increase the performance in this case. Also, check if your GPU and monitor supports Gsync or Freesync, which may increase your gaming experience (removing tearing in low frames, and lower delays compared to Vsync).
- If thermal throttling happens think about changing the thermal paste and/or maybe undervolting the CPU.
- Think about having 2x memory sticks (e.g. 2x 8GB RAM's) to use the benefits of dual channel memory. Also, increasing the available memory gives more room to cache files (if you have an extremely fast SSD, e.g. Samsung 980 Pro plugged to PCI-e 4 slot, then this may not be necessary)

Additional Recommended Tweaks from `Performance.md`:

- Always keep the CPU in `performance` mode. This is a recommended modification for some games. (e.g. Tomb Raider). This may hurt the battery life heavily, so to switch between profiles also see `CPUFREQ`. -> [Performance Processor Scaling Governor](Performance.md#cpu-performance-processor-scaling-governor )
- Disable security mitigations (Spectre, Meltdown) to achieve ~10% performance gain in some CPU's. Be aware about the security risks. This may increase the battery life too. -> [Disable Security Mitigations](Performance.md#cpu-disable-security-mitigations) 

- Disable modifying access times for the files to reduce disk writes. -> [Ext4 Mount with noatime Option](Performance.md#hdd-ext4-mount-with-noatime-option)

- Disabling Wifi power save feature may decrease the latency and increase download/upload speeds in some cards. (For me download/upload speeds improved ~15%). This may decrease battery life. -> [Turn Off Wifi Power Save Feature](Performance.md#net-turn-off-wifi-power-save-feature)

- Additionally, if you have a slow computer with/without low memory then check the whole document: [Performance.md](Performance.md)



## More Tricks

Not enough? Let's continue...

### Vmtouch

Caches files to the memory. May fix shutters games with bad disk I/O optimizations. I recommend using this if whole game folder can fit to the memory.

```bash
# Install:
$ sudo apt install vmtouch

# Cache Whole Game Folder:
$ vmtouch -t /path/to/game/folder
```



### CPU Turbo Mode

**Thread:** https://www.reddit.com/r/tuxedocomputers/comments/p4r2bj/amd_5000_series_turbo_mode_high_temperatures/

TLDR; Disable turbo mode for more silent daily use, and make the GPU be able to boost better and longer times.

Intel and AMD CPU's have Turbo modes where core frequencies can go up to 5GHz in some systems. But increasing frequency by 1% doesn't increase power consumption by 1% but a few fold. So try to disable Turbo mode and give a room for GPU to boost. Use a CPU manager app/extension to turn it off (see: https://extensions.gnome.org/extension/1082/cpufreq/) and see if any throttling occurs under heavy load (benchmarks, games, etc.).



### Better Responsive Kernel

**Source:** https://xanmod.org/

```bash
$ echo 'deb http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
$ wget -qO - https://dl.xanmod.org/gpg.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/xanmod-kernel.gpg add -
$ sudo apt update && sudo apt install linux-xanmod

# Setting the FQ-PIE Queuing Discipline
$ echo 'net.core.default_qdisc = fq_pie' | sudo tee /etc/sysctl.d/90-override.conf
```



### Mouse Pooling Rate

**Source:** https://www.urbanterror.info/forums/topic/21844-howto-changing-mouse-polling-rate-on-ubuntu/

Increasing mouse pooling rate may hurt gaming performance and cause shuttering. I have a gaming mouse and 1000Hz doesn't cause any problems for me, but keep this in mind.

**Also, TLP may reduce mouse pooling rate when it is not used. Can be problematic for competitive gaming. You may uninstall that package if needed.**

Ubuntu's default mouse pooling rate is 125Hz. If you have a mouse with higher sampler rate increase as below:

```bash
sudo gedit /etc/modules
```

Add these two lines (don't forget to modify `x`):

```
-r usbhid
usbhid mousepoll=x
```

Here the value `x` can be:

```
1 = 1000Hz
2 = 500Hz
4 = 250Hz
8 = 125Hz
10 = 100Hz (Default)
```

If you have `TLP` then disabling usb power management or uninstalling this module can prevent sluggish mouse movements.

