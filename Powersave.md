# Powersave Tweaks

[toc]

## Introduction

These tweaks are mostly for laptops.



## Turn off CPU Turbo

Todo



## Turn off NVIDIA dGPU

This feature can save 10W of power being used in the battery mode. Firstly, test if your dGPU is turned off with this command:

```bash
$ cat /sys/bus/pci/devices/0000:01:00.0/power_state
```

If it returns `D3cold` the dGPU is turned off. This is good. I recommend you to read this anyway.

If it returns `D0`, `D2`, or a similar entry it means dGPU is turned on. There some possible ways to solve it:

- Make sure no application is reading dGPU temperature. (e.g. psensor can wake up and keep the dGPU awake all the time. See the [bug report](https://bugs.launchpad.net/ubuntu/+source/psensor/+bug/1943087))
- Make sure `On-demand` is selected in PowerMizer in NVIDIA X Server Settings. `Max Performance` keeps the device active all the time.
- Make sure `cat /sys/bus/pci/devices/0000:01:00.0/d3cold_allowed` returns 1. If not writing 1 to this file may solve the problem temporarly.
- Make sure `nvidia-smi` returns one or two `/usr/lib/xorg/Xorg` processes. If there are other processes the device may not stop. If there is a screen connected to the dGPU the device may not sleep.
- Make sure you are using the latest NVIDIA driver.

- Lastly, if it still doesn't work make sure to read latest driver readme. (For 470.63.01: http://us.download.nvidia.com/XFree86/Linux-x86_64/470.63.01/README/dynamicpowermanagement.html)



## TLP

```bash
$ sudo apt install tlp --install-suggests
```

