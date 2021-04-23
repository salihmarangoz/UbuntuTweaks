# Install Anaconda and Libraries

Guides:

- [Install Anaconda and Configure Your Environment](dlml_anaconda.md)
  - Python, Octave, C++ kernels
  - Movable anaconda3 folder

- [Compile PyTorch Binaries](compile_pytorch.md)
  - Custom and minimal PyTorch build
  - Faster but difficult to manage conda environment
  - Can compile for old GPU's
- [Compile PyTorch and Create Conda Packages](conda_pytorch.md)
  - Custom and minimal PyTorch build
  - Compiling and installations happens in docker container
  - Create your own custom conda packages
  - Can compile for old GPU's

- [Use Intel for Display, Nvidia for CUDA](nvidia_headless.md)
  - Xorg will not lag while using CUDA for heavy tasks.
  - Xorg will not use any memory in Nvidia GPU.
  - Bad for gaming, because can't switch between drivers without reinstalling.