# Compile PyTorch and Create Custom Conda Package



## Download Repositories

```bash
# Download PyTorch
$ cd $HOME
$ git clone --recursive https://github.com/pytorch/builder.git
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
index 082a266..00a0d0c 100755
--- a/conda/build_docker.sh
+++ b/conda/build_docker.sh
@@ -3,7 +3,7 @@
 export DOCKER_BUILDKIT=1
 TOPDIR=$(git rev-parse --show-toplevel)
 
-CUDA_VERSION=${CUDA_VERSION:-10.2}
+CUDA_VERSION=10.2
 
 case ${CUDA_VERSION} in
   cpu)
```

- **`$HOME/builder/conda/Dockerfile `**

Description: Precompiled docker image is too big. Removed unnecessary Cuda installations. Also mnist part was raising an error so I removed it.

```diff
diff --git a/conda/Dockerfile b/conda/Dockerfile
index 0c1919a..f920cb4 100644
--- a/conda/Dockerfile
+++ b/conda/Dockerfile
@@ -1,6 +1,6 @@
 ARG CUDA_VERSION=10.2
 ARG BASE_TARGET=cuda${CUDA_VERSION}
-FROM nvidia/cuda:9.2-devel-centos7 as base
+FROM nvidia/cuda:10.2-devel-centos7 as base
 
 ENV LC_ALL en_US.UTF-8
 ENV LANG en_US.UTF-8
@@ -41,42 +41,14 @@ FROM base as cuda
 RUN rm -rf /usr/local/cuda-*
 ADD ./common/install_cuda.sh install_cuda.sh
 
-FROM cuda as cuda9.2
-RUN bash ./install_cuda.sh 9.2
-ENV DESIRED_CUDA=9.2
-
-FROM cuda as cuda10.1
-RUN bash ./install_cuda.sh 10.1
-ENV DESIRED_CUDA=10.1
 
 FROM cuda as cuda10.2
 RUN bash ./install_cuda.sh 10.2
 ENV DESIRED_CUDA=10.2
 
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
 
 FROM base as all_cuda
-COPY --from=cuda9.2   /usr/local/cuda-9.2  /usr/local/cuda-9.2
-COPY --from=cuda10.1  /usr/local/cuda-10.1 /usr/local/cuda-10.1
 COPY --from=cuda10.2  /usr/local/cuda-10.2 /usr/local/cuda-10.2
-COPY --from=cuda11.0  /usr/local/cuda-11.0 /usr/local/cuda-11.0
-COPY --from=cuda11.1  /usr/local/cuda-11.1 /usr/local/cuda-11.1
-COPY --from=cuda11.2  /usr/local/cuda-11.2 /usr/local/cuda-11.2
 
 # Install LLVM
 COPY --from=pytorch/llvm:9.0.1 /opt/llvm /opt/llvm
@@ -86,7 +58,6 @@ COPY --from=patchelf /patchelf            /usr/local/bin/patchelf
 COPY --from=conda    /opt/conda           /opt/conda
 ADD  ./java/jni.h    /usr/local/include/jni.h
 ENV  PATH /opt/conda/bin:$PATH
-COPY --from=mnist  /usr/local/mnist /usr/local/mnist
 RUN rm -rf /usr/local/cuda
 RUN chmod o+rw /usr/local
 RUN touch /.condarc && \
```

- **`$HOME/builder/conda/pytorch-nightly/build.sh `**

Description: Parameters are taken from https://github.com/pytorch/pytorch/blob/master/setup.py

```diff
diff --git a/conda/pytorch-nightly/build.sh b/conda/pytorch-nightly/build.sh
index adcb55a..c6961bf 100755
--- a/conda/pytorch-nightly/build.sh
+++ b/conda/pytorch-nightly/build.sh
@@ -79,6 +79,17 @@ DEPS_LIST=()
 #     DEPS_LIST+=("/usr/local/cuda/lib64/libnvrtc-builtins.so")
 # fi
 
+export TORCH_CUDA_ARCH_LIST=3.0     # Set CUDA compute capability (My GPU's was 3.0)
+export USE_CUDA=1                   # For adding GPU capability to pytorch
+export USE_CUDNN=1                  # For better CUDA performance
+export USE_MKLDNN=1                 # For faster CPU operations
+export BUILD_CAFFE2=0               # Disable caffe2 build
+export BUILD_CAFFE2_OPS=0
+export BUILD_TEST=0                 # Don't compile tests
+export BUILD_BINARY=0               # Don't compile cpp binaries
+export USE_DISTRIBUTED=0            # Disable distributed computing features
+export ATEN_NO_TEST=1
+export USE_ROCM=0
 
 # install
 python setup.py install
```

- **`$HOME/builder/magma/Makefile `**

Description: `CUDA_ARCH_LIST` is set to our GPU's cuda compute capability specifically. In addition note that the docker image name is different. 

```diff
diff --git a/magma/Makefile b/magma/Makefile
index 7a3960b..7b11c56 100644
--- a/magma/Makefile
+++ b/magma/Makefile
@@ -3,7 +3,7 @@ SHELL=/usr/bin/env bash
 DESIRED_CUDA ?= 11.1
 PACKAGE_NAME ?= magma-cuda111
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
+       "pytorch/conda-builder:cuda10.2" \
        magma/build_magma.sh
 
 .PHONY: all
```

- **`$HOME/builder/conda/build_pytorch.sh `**

Description: While making PyTorch a new conda environment is being created. To use compiled Magma as a required package local folder needs to be set as local conda channel.

```diff
diff --git a/conda/build_pytorch.sh b/conda/build_pytorch.sh
index 15883ba..efab736 100755
--- a/conda/build_pytorch.sh
+++ b/conda/build_pytorch.sh
@@ -356,6 +356,7 @@ for py_ver in "${DESIRED_PYTHON[@]}"; do
          PYTORCH_BUILD_STRING="$build_string" \
          PYTORCH_MAGMA_CUDA_VERSION="$cuda_nodot" \
          conda build -c "$ANACONDA_USER" ${ADDITIONAL_CHANNELS} \
+                     -c file:///builder/magma/output/linux-64/ \
                      --no-anaconda-upload \
                      --python "$py_ver" \
                      --output-folder "$output_folder" \
```



## Compile the Compile Environment with Docker

```bash
# Enable docker experimental for --squash parameter passed to docker build
$ echo $'{\n    "experimental": true\n}' | sudo tee /etc/docker/daemon.json
$ sudo service docker restart

$ cd $HOME/builder
$ conda/build_docker.sh
$ docker rmi $(docker images -f "dangling=true" -q)
```



## Compile Magma

```bash
$ cd $HOME/builder/magma
$ make magma-cuda102
```



## Compile PyTorch

```bash
$ cd $HOME
$ docker run --rm \
    -v "$HOME/pytorch":/pytorch \
    -v "$HOME/builder":/builder \
    -u "$(id -u):$(id -g)" \
    -it pytorch/conda-builder:cuda10.2 /bin/bash

export PACKAGE_TYPE=conda
export DESIRED_PYTHON=3.8
export DESIRED_CUDA=10.2
export PYTORCH_BUILD_VERSION=1.8.1
export PYTORCH_BUILD_NUMBER=0     # leave this zero
export TORCH_CONDA_BUILD_FOLDER=pytorch-nightly

. ./builder/conda/build_pytorch.sh
```



## Install Packages to Your Anaconda Environment

```bash
$ conda create -y --name pytorch
$ source activate pytorch

# Set local channels
MAGMA_CH="file://"$HOME"/builder/magma/output/linux-64"
PYTORCH_CH="file://"$HOME"/builder/conda/out_py3.8_cuda10.2_cudnn7.6.5_0_20210420/linux-64"

# List compiled packages
$ conda search -c $MAGMA_CH -c $PYTORCH_CH --override-channels

# Install pytorch
$ conda install -c $PYTORCH_CH -c conda-forge pytorch=1.8.1=py3.8_cuda10.2_cudnn7.6.5_0

# Install magma
$ conda install -c $MAGMA_CH magma-cuda102=2.5.2

# Pin pytorch & magma # Note: My anaconda is located at /anaconda3 , not ~/anaconda3
$ echo "pytorch ==1.8.1" >> /anaconda3/envs/pytorch/conda-meta/pinned
$ echo "magma-cuda102 ==2.5.2" >> /anaconda3/envs/pytorch/conda-meta/pinned

# Install torchvision & torchaudio
$ conda install -c pytorch torchvision=0.9.1=py38_cu102 torchaudio 

# Install torchsummary
$ conda install -c conda-forge pytorch-model-summary 

# Install other ML packages
$ conda install -c conda-forge ipykernel matplotlib Pillow pandas scipy scikit-image scikit-learn sympy
$ python -m ipykernel install --user --name pytorch --display-name "PyTorch 1.8.1 Custom Build"
```



## Optional: Reduce Disk Usage

```bash
# Clean anaconda cache
$ conda clean --all

# Prune Docker Images
$ docker system prune -a --volumes # warning! deletes all images and volumes
```