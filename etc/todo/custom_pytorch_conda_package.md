# Compile PyTorch and Create Custom Conda Package

[TOC]

## This is Dirty! Why Would I Want This?

While I was preparing this documentation of PyTorch was not ok for compiling and creating a conda package afterwards. I tried compiling binaries but when I use `conda install` there is a high probability that my package can be overwritten.  So I want conda to manage compiled packages. And lastly you would want to do this way because;

- Your GPU is old so that CUDA compute capability is lower than 3.7 (Even tough you will need CUDA 9.8 at least) **and** you want a conda package, not wheel, not just binaries.
- You have very limited disk space in the target computer so you want to build your custom (pruned) conda packages. For example you can compile the packages for a single GPU arch target.





## Download Repositories

```bash
# Download PyTorch
$ cd $HOME
$ git clone --recursive https://github.com/pytorch/builder.git
$ git clone --recursive https://github.com/pytorch/vision.git -b v0.9.1 # check readme
$ git clone --recursive https://github.com/pytorch/pytorch -b v1.8.1 # choose stable's
$ cd pytorch
$ git checkout v1.8.1
$ git submodule sync
$ git submodule update --init --recursive
```



## Tweak Builder

- **`$HOME/builder/conda/build_docker.sh `**

```diff
diff --git a/conda/build_docker.sh b/conda/build_docker.sh
index 082a266..0a70b83 100755
--- a/conda/build_docker.sh
+++ b/conda/build_docker.sh
@@ -3,7 +3,7 @@
 export DOCKER_BUILDKIT=1
 TOPDIR=$(git rev-parse --show-toplevel)
 
-CUDA_VERSION=${CUDA_VERSION:-10.2}
+CUDA_VERSION=10.1
 
 case ${CUDA_VERSION} in
   cpu)
```

- **`$HOME/builder/conda/Dockerfile `**

Description: Precompiled docker image is too big. Removed unnecessary Cuda installations. Also mnist part was raising an error so I removed it.

```diff
diff --git a/conda/Dockerfile b/conda/Dockerfile
index 0c1919a..e939296 100644
--- a/conda/Dockerfile
+++ b/conda/Dockerfile
@@ -1,6 +1,6 @@
-ARG CUDA_VERSION=10.2
+ARG CUDA_VERSION=10.1
 ARG BASE_TARGET=cuda${CUDA_VERSION}
-FROM nvidia/cuda:9.2-devel-centos7 as base
+FROM nvidia/cuda:10.1-devel-centos7 as base
 
 ENV LC_ALL en_US.UTF-8
 ENV LANG en_US.UTF-8
@@ -41,42 +41,12 @@ FROM base as cuda
 RUN rm -rf /usr/local/cuda-*
 ADD ./common/install_cuda.sh install_cuda.sh
 
-FROM cuda as cuda9.2
-RUN bash ./install_cuda.sh 9.2
-ENV DESIRED_CUDA=9.2
-
 FROM cuda as cuda10.1
 RUN bash ./install_cuda.sh 10.1
 ENV DESIRED_CUDA=10.1
 
-FROM cuda as cuda10.2
-RUN bash ./install_cuda.sh 10.2
-ENV DESIRED_CUDA=10.2
-
-FROM cuda as cuda11.0
-RUN bash ./install_cuda.sh 11.0
-ENV DESIRED_CUDA=11.0
-
-FROM cuda as cuda11.1
-RUN bash ./install_cuda.sh 11.1
-ENV DESIRED_CUDA=11.1
-
-FROM cuda as cuda11.2
-RUN bash ./install_cuda.sh 11.2
-ENV DESIRED_CUDA=11.2
-
-# Install MNIST test data
-FROM base as mnist
-ADD ./common/install_mnist.sh install_mnist.sh
-RUN bash ./install_mnist.sh
-
 FROM base as all_cuda
-COPY --from=cuda9.2   /usr/local/cuda-9.2  /usr/local/cuda-9.2
 COPY --from=cuda10.1  /usr/local/cuda-10.1 /usr/local/cuda-10.1
-COPY --from=cuda10.2  /usr/local/cuda-10.2 /usr/local/cuda-10.2
-COPY --from=cuda11.0  /usr/local/cuda-11.0 /usr/local/cuda-11.0
-COPY --from=cuda11.1  /usr/local/cuda-11.1 /usr/local/cuda-11.1
-COPY --from=cuda11.2  /usr/local/cuda-11.2 /usr/local/cuda-11.2
 
 # Install LLVM
 COPY --from=pytorch/llvm:9.0.1 /opt/llvm /opt/llvm
@@ -86,7 +56,6 @@ COPY --from=patchelf /patchelf            /usr/local/bin/patchelf
 COPY --from=conda    /opt/conda           /opt/conda
 ADD  ./java/jni.h    /usr/local/include/jni.h
 ENV  PATH /opt/conda/bin:$PATH
-COPY --from=mnist  /usr/local/mnist /usr/local/mnist
 RUN rm -rf /usr/local/cuda
 RUN chmod o+rw /usr/local
 RUN touch /.condarc && \
```

- **`$HOME/builder/conda/build_pytorch.sh `**

Description: While making PyTorch a new conda environment is being created. To use compiled Magma as a required package local folder needs to be set as local conda channel.

```diff
diff --git a/conda/build_pytorch.sh b/conda/build_pytorch.sh
index 15883ba..a7930c2 100755
--- a/conda/build_pytorch.sh
+++ b/conda/build_pytorch.sh
@@ -355,7 +355,8 @@ for py_ver in "${DESIRED_PYTHON[@]}"; do
          PYTORCH_GITHUB_ROOT_DIR="$pytorch_rootdir" \
          PYTORCH_BUILD_STRING="$build_string" \
          PYTORCH_MAGMA_CUDA_VERSION="$cuda_nodot" \
-         conda build -c "$ANACONDA_USER" ${ADDITIONAL_CHANNELS} \
+         conda build -c file:///builder/magma/output/linux-64/ \
+                     -c "$ANACONDA_USER" ${ADDITIONAL_CHANNELS} \
                      --no-anaconda-upload \
                      --python "$py_ver" \
                      --output-folder "$output_folder" \
```

- **`$HOME/builder/conda/pytorch-nightly/build.sh `**

Description: Parameters are taken from https://github.com/pytorch/pytorch/blob/master/setup.py

```diff
diff --git a/conda/pytorch-nightly/build.sh b/conda/pytorch-nightly/build.sh
index adcb55a..e007dcb 100755
--- a/conda/pytorch-nightly/build.sh
+++ b/conda/pytorch-nightly/build.sh
@@ -79,6 +79,18 @@ DEPS_LIST=()
 #     DEPS_LIST+=("/usr/local/cuda/lib64/libnvrtc-builtins.so")
 # fi
 
+export TORCH_CUDA_ARCH_LIST=3.0     # Set CUDA compute capability (My GPU's was 3.0)
+export USE_CUDA=1                   # For adding GPU capability to pytorch
+export USE_CUDNN=1                  # For better CUDA performance
+export USE_MKLDNN=1                 # For faster CPU operations
+export BUILD_CAFFE2=1               # Disable caffe2 build
+export BUILD_CAFFE2_OPS=1
+export BUILD_TEST=0                 # Don't compile tests
+export BUILD_BINARY=1               # Don't compile cpp binaries
+export USE_DISTRIBUTED=0            # Disable distributed computing features
+export ATEN_NO_TEST=1
+export USE_ROCM=0
+
 
 # install
 python setup.py install
```

- **`$HOME/builder/magma/Makefile `**

Description: `CUDA_ARCH_LIST` is set to our GPU's cuda compute capability specifically. In addition note that the docker image name is different. 

```diff
diff --git a/magma/Makefile b/magma/Makefile
index 7a3960b..4ca421e 100644
--- a/magma/Makefile
+++ b/magma/Makefile
@@ -1,9 +1,9 @@
 SHELL=/usr/bin/env bash
 
-DESIRED_CUDA ?= 11.1
-PACKAGE_NAME ?= magma-cuda111
+DESIRED_CUDA ?= 10.1
+PACKAGE_NAME ?= magma-cuda101
 CUDA_POINTER_ATTR_PATCH ?=
-CUDA_ARCH_LIST ?= -gencode arch=compute_37,code=sm_37 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70
+CUDA_ARCH_LIST ?= -gencode arch=compute_30,code=sm_30
 
 DOCKER_RUN = set -eou pipefail; docker run --rm -i \
        -v $(shell git rev-parse --show-toplevel):/builder \
@@ -12,7 +12,7 @@ DOCKER_RUN = set -eou pipefail; docker run --rm -i \
        -e PACKAGE_NAME=${PACKAGE_NAME} \
        -e CUDA_POINTER_ATTR_PATCH=${CUDA_POINTER_ATTR_PATCH} \
        -e CUDA_ARCH_LIST="${CUDA_ARCH_LIST}" \
-       "pytorch/conda-cuda:latest" \
+       "pytorch/conda-builder:cuda10.1" \
        magma/build_magma.sh
 
 .PHONY: all
```


- **`$HOME/builder/common/install_cuda.sh `**

```diff
diff --git a/common/install_cuda.sh b/common/install_cuda.sh
index f5686f9..da99103 100644
--- a/common/install_cuda.sh
+++ b/common/install_cuda.sh
@@ -51,8 +51,8 @@ function install_101 {
     # install CUDA 10.1 CuDNN
     # cuDNN license: https://developer.nvidia.com/cudnn/license_agreement
     mkdir tmp_cudnn && cd tmp_cudnn
-    wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_7.6.3.30-1+cuda10.1_amd64.deb -O cudnn-dev.deb
-    wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.6.3.30-1+cuda10.1_amd64.deb -O cudnn.deb
+    wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7-dev_7.6.5.32-1+cuda10.1_amd64.deb -O cudnn-dev.deb
+    wget -q http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.6.5.32-1+cuda10.1_amd64.deb -O cudnn.deb
     ar -x cudnn-dev.deb && tar -xvf data.tar.xz
     ar -x cudnn.deb && tar -xvf data.tar.xz
     mkdir -p cuda/include && mkdir -p cuda/lib64
@@ -209,8 +209,8 @@ function prune_101 {
     export NVPRUNE="/usr/local/cuda-10.1/bin/nvprune"
     export CUDA_LIB_DIR="/usr/local/cuda-10.1/lib64"
 
-    export GENCODE="-gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_75,code=sm_75"
-    export GENCODE_CUDNN="-gencode arch=compute_35,code=sm_35 -gencode arch=compute_37,code=sm_37 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_75,code=sm_75"
+    export GENCODE="-gencode arch=compute_30,code=sm_30"
+    export GENCODE_CUDNN="-gencode arch=compute_30,code=sm_30"
 
     if [[ -n "$OVERRIDE_GENCODE" ]]; then
         export GENCODE=$OVERRIDE_GENCODE
```



## Compile the Compile Environment with Docker

```bash
$ cd $HOME/builder
$ conda/build_docker.sh
# and then exit the container
```



## Compile Magma

```bash
$ cd $HOME/builder/magma
$ make magma-cuda101
```



## Compile PyTorch

```bash
$ cd $HOME
$ docker run --rm \
    -v "$HOME/pytorch":/pytorch \
    -v "$HOME/builder":/builder \
    -u "$(id -u):$(id -g)" \
    -it pytorch/conda-builder:cuda10.1 /bin/bash

export PACKAGE_TYPE=conda
export DESIRED_PYTHON=3.8
export DESIRED_CUDA=10.1
export PYTORCH_BUILD_VERSION=1.8.1
export PYTORCH_BUILD_NUMBER=0     # leave this zero
export TORCH_CONDA_BUILD_FOLDER=pytorch-nightly

. ./builder/conda/build_pytorch.sh
```



## Tweak Torchvision

**`$HOME/vision/packaging/torchvision/meta.yaml `**

Description: jpeg constraint prevents installing opencv. https://github.com/pytorch/vision/commit/043343f1488b7ee9c1654f8d23734cc011e1b680

This was specific modification for 1.8.1 version to be able to install beside opencv.

```diff
diff --git a/packaging/torchvision/meta.yaml b/packaging/torchvision/meta.yaml
index 834648c0..f30dc324 100644
--- a/packaging/torchvision/meta.yaml
+++ b/packaging/torchvision/meta.yaml
@@ -9,7 +9,7 @@ requirements:
   build:
     - {{ compiler('c') }} # [win]
     - libpng
-    - jpeg <=9b
+    - jpeg
     # NOTE: The only ffmpeg version that we build is actually 4.2
     - ffmpeg >=4.2  # [not win]
 
@@ -25,7 +25,7 @@ requirements:
     - python
     - libpng
     - ffmpeg >=4.2  # [not win]
-    - jpeg <=9b
+    - jpeg
     - pillow >=4.1.1
     - defaults::numpy >=1.11
     {{ environ.get('CONDA_PYTORCH_CONSTRAINT') }}
@@ -53,7 +53,7 @@ test:
     - pytest
     - scipy
     - av >=8.0.1
-    - jpeg <=9b
+    - jpeg
     - ca-certificates
```

**`$HOME/vision/packaging/build_conda.sh `**

```diff
diff --git a/packaging/build_conda.sh b/packaging/build_conda.sh
index fa155359..2c29c172 100755
--- a/packaging/build_conda.sh
+++ b/packaging/build_conda.sh
@@ -5,10 +5,10 @@ script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
 . "$script_dir/pkg_helpers.bash"
 
 export BUILD_TYPE=conda
-setup_env 0.9.0
+setup_env 0.9.1
 export SOURCE_ROOT_DIR="$PWD"
 setup_conda_pytorch_constraint
 setup_conda_cudatoolkit_constraint
 setup_visual_studio_constraint
 setup_junit_results_folder
-conda build $CONDA_CHANNEL_FLAGS -c defaults -c conda-forge --no-anaconda-upload --python "$PYTHON_VERSION" packaging/torchvision
+conda build -c file:///builder/conda/out_py3.8_cuda10.1_cudnn7.6.5_0_20210422/linux-64 -c conda-forge --no-anaconda-upload --python "$PYTHON_VERSION" packaging/torchvision
```

**`$HOME/vision/packaging/pkg_helpers.bash `**

Description: Check the folder name `out_py3.8_cuda10.1_cudnn7.6.3_0_20210421` It may be different for you.

```diff
diff --git a/packaging/pkg_helpers.bash b/packaging/pkg_helpers.bash
index dfa0a9ae..41994d75 100644
--- a/packaging/pkg_helpers.bash
+++ b/packaging/pkg_helpers.bash
@@ -99,7 +99,7 @@ setup_cuda() {
       export FORCE_CUDA=1
       # Hard-coding gencode flags is temporary situation until
       # https://github.com/pytorch/pytorch/pull/23408 lands
-      export NVCC_FLAGS="-gencode=arch=compute_35,code=sm_35 -gencode=arch=compute_50,code=sm_50 -gencode=arch=compute_60,code=sm_60 -gencode=arch=compute_70,code=sm_70 -gencode=arch=compute_75,code=sm_75 -gencode=arch=compute_50,code=compute_50"
+      export NVCC_FLAGS="-gencode=arch=compute_30,code=sm_30"
       ;;
     cu100)
       if [[ "$OSTYPE" == "msys" ]]; then
@@ -260,7 +260,7 @@ setup_pip_pytorch_version() {
 setup_conda_pytorch_constraint() {
   if [[ -z "$PYTORCH_VERSION" ]]; then
     export CONDA_CHANNEL_FLAGS="-c pytorch-nightly -c pytorch"
-    export PYTORCH_VERSION="$(conda search --json 'pytorch[channel=pytorch-nightly]' | \
+    export PYTORCH_VERSION="$(conda search --json pytorch -c file:///builder/conda/out_py3.8_cuda10.1_cudnn7.6.5_0_20210422/linux-64 | \
                               python -c "import os, sys, json, re; cuver = os.environ.get('CU_VERSION'); \
                                cuver_1 = cuver.replace('cu', 'cuda') if cuver != 'cpu' else cuver; \
                                cuver_2 = (cuver[:-1] + '.' + cuver[-1]).replace('cu', 'cuda') if cuver != 'cpu' else cuver; \
```



## Compile Torchvision

```bash
$ docker run --rm \
    -v $HOME/vision:/vision \
    -v "$HOME/builder":/builder \
    -u "$(id -u):$(id -g)" \
    -it pytorch/conda-builder:cuda10.1 /bin/bash

export CU_VERSION=cu101
export PYTHON_VERSION=3.8

$ cd vision
$ bash packaging/build_conda.sh # DON'T FORGET THE COMMAND BELOW!!!
$ cp -r /opt/conda/conda-bld /vision/torchvision-0.9.1
# if you copied the generated package folder you can exit from the container
```



## Install Packages to Your Anaconda Environment

```bash
# Create a new terminal

# Create a new env
$ conda create -y --name pytorch
$ source activate pytorch

# Copy your local channels into your anaconda folder (personal preference)
# Check the folder names!!!!!
$ mkdir /anaconda3/extra   # My anaconda is located at /anaconda3 , not ~/anaconda3
$ cp -r $HOME/builder/magma/output /anaconda3/extra/magma-cuda101
$ cp -r $HOME/builder/conda/out_py3.8_cuda10.1_cudnn7.6.5_0_20210422 /anaconda3/extra/pytorch-1.8.1-cuda10.1
$ cp -r $HOME/vision/torchvision-0.9.1 /anaconda3/extra/torchvision-0.9.1

# Set local channels 
# My anaconda is located at /anaconda3 , not ~/anaconda3
MAGMA_CH="file:///anaconda3/extra/magma-cuda101/linux-64"
PYTORCH_CH="file:///anaconda3/extra/pytorch-1.8.1-cuda10.1/linux-64"
VISION_CH="file:///anaconda3/extra/torchvision-0.9.1/linux-64"

# List compiled packages and note the versions of the packages
# You should be able to see pytorch, magma, torchvision
$ conda search -c $MAGMA_CH -c $PYTORCH_CH -c $VISION_CH --override-channels

# Install compiled packages
$ conda install -c $PYTORCH_CH -c conda-forge pytorch=1.8.1=py3.8_cuda10.1_cudnn7.6.5_0
$ conda install -c $MAGMA_CH magma-cuda101=2.5.2
$ conda install -c $VISION_CH torchvision=0.9.1.dev20210422

# Pin pytorch & magma # Note: My anaconda is located at /anaconda3 , not ~/anaconda3
$ echo "pytorch ==1.8.1" >> /anaconda3/envs/pytorch/conda-meta/pinned
$ echo "magma-cuda101 ==2.5.2" >> /anaconda3/envs/pytorch/conda-meta/pinned
$ echo "torchvision ==0.9.1.dev20210422" >> /anaconda3/envs/pytorch/conda-meta/pinned

# Install torchsummary
$ conda install -c conda-forge pytorch-model-summary 

# Install other ML packages
$ conda install -c conda-forge ipykernel matplotlib Pillow pandas scipy scikit-image scikit-learn sympy opencv
# If the sat solver takes a lot of time, add torchvision to the constraints:
# $ conda install -c $VISION_CH -c conda-forge ipykernel matplotlib Pillow pandas scipy scikit-image scikit-learn sympy opencv torchvision=0.9.1.dev20210422

# Set-up ipykernel for jupyter notebook
$ python -m ipykernel install --user --name pytorch --display-name "PyTorch 1.8.1 Custom Build"
```



## Optional: Reduce Disk Usage

```bash
# Clean anaconda cache
$ conda clean --all

# Prune Docker Images
$ docker system prune -a --volumes # warning! deletes all images and volumes

# remove pytorch, builder, and vision folders manually
```