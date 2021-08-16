# Compile PyTorch Binaries

**Assuming that anaconda and latest Nvidia driver is installed !!!**

The drawback of this method is you can't manage your environment with anaconda so there is a possibility that your compiled packages can be overwritten. 

## Configuration

```bash
export VIRT_ENV_NAME="pytorch-build"                     # Anaconda env name
export VIRT_ENV_DISPLAY_NAME="Python 3 (PyTorch GPU)"    # Displayed kernel name

# Set CUDA env variables. I have used Cuda 10.0
export CUDA_NVCC_EXECUTABLE="/usr/local/cuda-10.0/bin/nvcc"
export CUDA_HOME="/usr/local/cuda-10.0"
export CUDNN_INCLUDE_PATH="/usr/local/cuda-10.0/include/"
export CUDNN_LIBRARY_PATH="/usr/local/cuda-10.0/lib64/"
export LIBRARY_PATH="/usr/local/cuda-10.0/lib64"
export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME

export TORCH_CUDA_ARCH_LIST=3.0     # Set CUDA compute capability (My GPU's was 3.0)
export USE_CUDA=1                   # For adding GPU capability to pytorch
export USE_CUDNN=1                  # For better CUDA performance
export USE_MKLDNN=1                 # For faster CPU operations
export MAX_JOBS=4                   # Limit max jobs
export BUILD_CAFFE2=0               # Disable caffe2 build
export BUILD_CAFFE2_OPS=0
export BUILD_TEST=0                 # Don't compile tests
export BUILD_BINARY=0               # Don't compile cpp binaries
export USE_DISTRIBUTED=0            # Disable distributed computing features
```

## Install CUDA, cuBLAS, cuDNN

```bash
$ sudo add-apt-repository ppa:graphics-drivers
$ sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
$ sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
$ sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list'
$ sudo apt update
$ sudo apt install libomp-dev cuda-toolkit-10-0 cuda-cublas-dev-10-0
$ sudo apt install libcudnn7-dev=7.6.5.32-1+cuda10.0 libcudnn7=7.6.5.32-1+cuda10.0
```

## Set up Anaconda

```bash
# Set up env
$ conda create -y --name "$VIRT_ENV_NAME"
$ source activate "$VIRT_ENV_NAME"

# Install build dependencies
$ conda install numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions future six requests dataclasses

# Disable anaconda linker temporarly
$ cd ~/anaconda3/envs/pytorch-build/compiler_compat
$ mv ld ld-old
```

## Build PyTorch

```bash
# Download PyTorch
$ cd ~
$ git clone --recursive https://github.com/pytorch/pytorch -b v1.8.1  # set pytorch version here
$ cd ~/pytorch
$ git checkout v1.8.1  # set pytorch version here
$ git submodule sync
$ git submodule update --init --recursive

# Compile PyTorch
$ export CMAKE_PREFIX_PATH=${CONDA_PREFIX:-"$(dirname $(which conda))/../"}
$ python setup.py install  # run "python setup.py clean" before retrying
```

## Set up Anaconda (2)

```bash
# Enable anaconda linker back
$ cd ~/anaconda3/envs/pytorch-build/compiler_compat
$ mv ld-old ld

# Install some ML/linalg/plot libs
$ conda install -c  conda-forge ipykernel matplotlib Pillow pandas scipy scikit-image scikit-learn sympy

# Add kernel to ipykernel
$ python -m ipykernel install --user --name "$VIRT_ENV_NAME" --display-name "$VIRT_ENV_DISPLAY_NAME"
```

## PyTorch Extras

```bash
# Note: --no-deps may break dependencies and can cause problem in the feature but you shouldn't install another version of PyTorch in this environment, so use it
$ conda install torchvision=0.9.0=py38_cu101 -c pytorch --no-deps
$ conda install pytorch-model-summary -c conda-forge --no-deps
```