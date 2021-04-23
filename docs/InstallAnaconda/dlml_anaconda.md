# Anaconda + Jupyter Notebook

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

- After installing, run jupyter notebook once then close. Copy the `UbuntuTweaks/etc/nbconfig` into the folder `~/.jupyter/`

- Close all terminals and open a fresh one then type `jupyter_notebook` (which is an alias we put in .bashrc). Open a notebook with `Python (myenv)` kernel and run these commands:

```python
import torch
import tensorflow
import numpy
import matplotlib
print ("Tensorflow", tensorflow.__version__)
print ("PyTorch", torch.__version__)
```

## Autopep8 Fix

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

## Jupyter Extensions are not showing up

Run the following command:

```bash
$ which jupyter-notebook
```

This should output nothing or give a output indicating your anaconda installation. If not, you need to uninstall pip installation of your jupyter-notebook. Run these to uninstall to do so:

```bash
$ pip uninstall jupyter jupyter-client jupyter-console jupyter-contrib-core jupyter-contrib-nbextensions jupyter-core jupyter-highlight-selected-word jupyter-latex-envs jupyter-nbextensions-configurator jupyterlab-pygments jupyterlab-widgets

$ python3 -m pip uninstall -y jupyter jupyter_core jupyter-client jupyter-console jupyterlab_pygments notebook qtconsole nbconvert nbformat
```