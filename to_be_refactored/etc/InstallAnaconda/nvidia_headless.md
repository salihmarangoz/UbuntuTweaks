# Intel for Display, Nvidia for CUDA

**Source:** https://gist.github.com/wangruohui/bc7b9f424e3d5deb0c0b8bba990b1bc5

Please check the source link before start reading. 

I have a laptop installed Ubuntu 18.04 with Intel dedicated GPU and Nvidia GPU. I installed my driver with `sudo ubuntu-drivers autoinstall` before which is named PPA method in the source URL. So all I did was running these commands:

```bash
$ sudo apt purge *nvidia*
$ sudo add-apt-repository ppa:graphics-drivers/ppa
$ sudo apt update
$ sudo apt install nvidia-headless-418 nvidia-utils-418 # This was version 418 for me
```

As a result, I was able make Intel GPU to calculate OpenGL and other graphics, and use Nvidia GPU all for CUDA computations.

Output of my `nvidia-smi`: (I think driver and cuda versions are wrong but still does the job)

```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 465.19.01    Driver Version: 465.19.01    CUDA Version: 11.3     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  On   | 00000000:01:00.0 N/A |                  N/A |
| N/A   41C    P8    N/A /  N/A |      0MiB /  4039MiB |     N/A      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
```

