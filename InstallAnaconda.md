# Install Anaconda and Libraries

   * [Install Anaconda and Libraries](#install-anaconda-and-libraries)
      * [Anaconda   Jupyter Notebook](#anaconda--jupyter-notebook)
         * [Autopep8 Fix](#autopep8-fix)
         * [Jupyter Extensions are not showing up](#jupyter-extensions-are-not-showing-up)
      * [Compile PyTorch for Old GPU's (Nvidia)](#compile-pytorch-for-old-gpus-nvidia)
         * [Configuration](#configuration)
         * [Install CUDA, cuBLAS, cuDNN](#install-cuda-cublas-cudnn)
         * [Set up Anaconda](#set-up-anaconda)
         * [Build PyTorch](#build-pytorch)
         * [Set up Anaconda (2)](#set-up-anaconda-2)
         * [PyTorch Extras](#pytorch-extras)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)

## Anaconda + Jupyter Notebook

- Features:
  - Uses binded folder for the installation so anaconda folder can be moved afterwards and being copied to other computers. (Personal note: It is really good to be able to use rsync on anaconda folder between different machines)
  - Python (ML/DL) Kernel
  - Octave Kernel
  - C++ Kernel
- Available Terminal Commands:
  - **`ana`**: Activates anaconda environment.
  - **`jupyter_notebook`**: Starts jupyter notebook.
  - **`jupyter_notebook_shared`**: Starts jupyter notebook with LAN access.

- Delete some folder before starting:
  - `~/.local/share/jupyter`
  - `~/.conda`

```bash
# You can set the parameters according to your system
ANACONDA_INSTALLER="Anaconda3-2020.11-Linux-x86_64.sh"  # Check latest version here: https://repo.anaconda.com/archive/
INSTALL_TARGET="$HOME/anaconda3" # set real install path for the anaconda
BIND_TARGET="/anaconda3"

##################################################

# Create folders and make bindings where necessarry
$ sudo mkdir -p "$INSTALL_TARGET"
$ sudo chown "$USER":"$USER" "$INSTALL_TARGET"
$ sudo mkdir -p "$BIND_TARGET"
$ sudo mount --bind "$INSTALL_TARGET" "$BIND_TARGET"

# Download and run Anaconda Installer
$ wget "https://repo.anaconda.com/archive/$ANACONDA_INSTALLER"
$ bash "$ANACONDA_INSTALLER" -b -u -p "$BIND_TARGET"

# Activate Anaconda Path
$ export PATH=${PATH}:$BIND_TARGET/bin

##################################################
########## base PACKAGES #########################
##################################################

$ source activate base
$ conda install -c  conda-forge \
                    jupyter \
                    jupyter_contrib_nbextensions \
                    ipykernel \
                    nodejs \
                    autopep8

##################################################
########## dlml PACKAGES #########################
##################################################
VIRT_ENV_NAME="dlml"
VIRT_ENV_DISPLAY_NAME="Python 3 ($VIRT_ENV_NAME)"

# Create virtual environment
$ conda create -y --name "$VIRT_ENV_NAME"
$ source activate "$VIRT_ENV_NAME"

# Install Data/ML/DL related libraries
$ conda install -c pytorch  pytorch torchvision torchaudio cpuonly # cpu only. see pytorch.org
$ conda install -c anaconda tensorflow 
$ conda install -c  conda-forge ipykernel matplotlib Pillow pandas scipy scikit-image scikit-learn sympy

# Install the IPython Kernel
$ python -m ipykernel install --user --name "$VIRT_ENV_NAME" --display-name "$VIRT_ENV_DISPLAY_NAME"

##################################################
########## octave PACKAGES #######################
##################################################

# Create virtual environment
$ conda create -y --name "octave"
$ source activate "octave"

# Install related libraries
$ sudo apt install octave*
$ conda install -c  conda-forge \
                    octave_kernel texinfo
$ python -m octave_kernel install --user

##################################################
########## cling PACKAGES ########################
##################################################

# Create virtual environment
$ conda create -y --name "cling"
$ source activate "cling"

# Install related libraries
$ conda install -c conda-forge xeus-cling
$ jupyter kernelspec install "$BIND_TARGET/envs/cling/share/jupyter/kernels/xcpp11" --sys-prefix
$ jupyter kernelspec install "$BIND_TARGET/envs/cling/share/jupyter/kernels/xcpp14" --sys-prefix
$ jupyter kernelspec install "$BIND_TARGET/envs/cling/share/jupyter/kernels/xcpp17" --sys-prefix

##################################################

# Make the bindng persistent (Run the command to see the output)
$ whiptail --msgbox "To complete installation add this line to /etc/fstab:\n\n$INSTALL_TARGET $BIND_TARGET none defaults,bind 0 0" 10 80

# .bashrc shortcuts
$ echo "alias ana=\"export PATH=\${PATH}:$BIND_TARGET/bin\"" >> ~/.bashrc
$ echo "alias jupyter_notebook=\"ana; jupyter-notebook\"" >> ~/.bashrc
$ echo "alias jupyter_notebook_shared=\"ana; jupyter-notebook --ip 0.0.0.0\"" >> ~/.bashrc

# delete the anaconda installer
$ rm "$ANACONDA_INSTALLER"
```

After installing, run jupyter notebook once then close. Copy the content below to `~/.jupyter/nbconfig/notebook.json`

```json
{
  "load_extensions": {
    "code_prettify/autopep8": true,
    "code_prettify/code_prettify": false,
    "scroll_down/main": true,
    "toc2/main": true,
    "comment-uncomment/main": true,
    "execute_time/ExecuteTime": true,
    "export_embedded/main": true,
    "select_keymap/main": true,
    "snippets_menu/main": true,
    "table_beautifier/main": false,
    "hinterland/hinterland": false,
    "python-markdown/main": false,
    "spellchecker/main": true,
    "jupyter-js-widgets/extension": true,
    "nbextensions_configurator/config_menu/main": true,
    "contrib_nbextensions_help_item/main": true,
    "toggle_all_line_numbers/main": true,
    "code_font_size/code_font_size": false,
    "notify/notify": false
  },
  "scrollDownIsEnabled": true,
  "select_keymap_local_storage": false,
  "stored_keymap": "sublime",
  "autopep8": {
    "kernel_config_map_json": "{\n    \"python\": {\n        \"library\": \"import json\\nimport sys\\nsys.path.append('/anaconda3/lib/python3.8/site-packages')\\nimport autopep8\",\n        \"prefix\": \"print(json.dumps(autopep8.fix_code(u\",\n        \"postfix\": \")))\"\n    }\n}\n"
  }
}
```

After installing close all terminals and open a fresh one then type `jupyter_notebook` (which is an alias we put in .bashrc). Open a notebook with `Python (myenv)` kernel and run these commands:

```python
import torch
import tensorflow
import numpy
import matplotlib
print ("Tensorflow", tensorflow.__version__)
print ("PyTorch", torch.__version__)
```

### Autopep8 Fix

I found a fix for autopep8 addon. If you installed Autopep8 with conda, pip etc., tried everything but still giving error like "autopep8 module not found" apply these steps...

- Find `autopep8.py` folder:

```bash
BIND_TARGET="/anaconda3"
$ find $BIND_TARGET -name autopep8.py
```

- This should give output similar like this.  Second result looks appropriate. Take that result without `/autopep8.py` postfix and update  `notebook.json` file.

```
/anaconda3/pkgs/autopep8-1.5.4-py_0/site-packages/autopep8.py
/anaconda3/lib/python3.8/site-packages/autopep8.py
```

- Open `notebook.json`

```bash
$ gedit ~/.jupyter/nbconfig/notebook.json
```

- If you installed anaconda using this document, the part of a file should be looking like below. You need to update the parameter of`sys.path.append`.

```
...
  "autopep8": {
    "kernel_config_map_json": "{\n    \"python\": {\n        \"library\": \"import json\\nimport sys\\nsys.path.append('/anaconda3/lib/python3.8/site-packages')\\nimport autopep8\",\n        \"prefix\": \"print(json.dumps(autopep8.fix_code(u\",\n        \"postfix\": \")))\"\n    }\n}\n"
  }
...
```

- As an alternative way, you can update configuration of Autopep8 using `Nbextensions configuration` page in Jupyter notebook. Update the last parameter to look like this

```
{
    "python": {
        "library": "import json\nimport sys\nsys.path.append('/anaconda3/lib/python3.8/site-packages')\nimport autopep8",
        "prefix": "print(json.dumps(autopep8.fix_code(u",
        "postfix": ")))"
    }
}
```

### Jupyter Extensions are not showing up

Run the following command:

```bash
$ which jupyter-notebook
```

This should output nothing or give a output indicating your anaconda installation. If not, you need to uninstall pip installation of your jupyter-notebook. Run these to uninstall to do so:

```bash
$ pip uninstall jupyter jupyter-client jupyter-console jupyter-contrib-core jupyter-contrib-nbextensions jupyter-core jupyter-highlight-selected-word jupyter-latex-envs jupyter-nbextensions-configurator jupyterlab-pygments jupyterlab-widgets

$ python3 -m pip uninstall -y jupyter jupyter_core jupyter-client jupyter-console jupyterlab_pygments notebook qtconsole nbconvert nbformat
```



## Compile PyTorch for Old GPU's (Nvidia)

**Assuming that anaconda and latest Nvidia driver is installed !!!**

### Configuration

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

### Install CUDA, cuBLAS, cuDNN

```bash
$ sudo add-apt-repository ppa:graphics-drivers
$ sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
$ sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
$ sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list'
$ sudo apt update
$ sudo apt install libomp-dev cuda-toolkit-10-0 cuda-cublas-dev-10-0
$ sudo apt install libcudnn7-dev=7.6.5.32-1+cuda10.0 libcudnn7=7.6.5.32-1+cuda10.0
```

### Set up Anaconda

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

### Build PyTorch

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

### Set up Anaconda (2)

```bash
# Enable anaconda linker back
$ cd ~/anaconda3/envs/pytorch-build/compiler_compat
$ mv ld-old ld

# Install some ML/linalg/plot libs
$ conda install -c  conda-forge ipykernel matplotlib Pillow pandas scipy scikit-image scikit-learn sympy

# Add kernel to ipykernel
$ python -m ipykernel install --user --name "$VIRT_ENV_NAME" --display-name "$VIRT_ENV_DISPLAY_NAME"
```

### PyTorch Extras

```bash
# Note: --no-deps may break dependencies and can cause problem in the feature but you shouldn't install another version of PyTorch in this environment, so use it
$ conda install torchvision=0.9.0=py38_cu101 -c pytorch --no-deps
$ conda install pytorch-model-summary -c conda-forge --no-deps
```


