#!/bin/bash

#########################################################################################################
############################## Installer Script Parameters ##############################################
#########################################################################################################


WHIPTAIL_TITLE="All in One Installer (Salih M.)"
WHIPTAIL_ROWS=$(($(tput lines)-4))
WHIPTAIL_COLS=$(($(tput cols)-4))
WHIPTAIL_SIZE=$(($(tput lines)-12))
WARN_IF_UNKNOWN_COMPATIBILITY=true


#########################################################################################################
############################## Installer Script Functions ###############################################
#########################################################################################################


function check_install_script()
{
    # Check compatibility
    COMPATIBLE_OS_LIST=$1
    NOT_COMPATIBLE_OS_LIST=$2
    OS_NAME=$(lsb_release -si)
    OS_VER=$(lsb_release -sr)
    OS_STR="$OS_NAME$OS_VER"

    for os_item in $NOT_COMPATIBLE_OS_LIST; do
        if [[ "$OS_STR" == "$os_item" ]]; then
            echo "This script is NOT compatible with [$os_item]. Terminating..."
            sleep 2
            show_mainmenu
        fi
    done

    for os_item in $COMPATIBLE_OS_LIST; do
        if [[ "$OS_STR" == "$os_item" ]]; then
            IS_COMPATIBLE="true"
        fi
    done

    if [[ "$IS_COMPATIBLE" != "true" ]]
    then
        echo "This script has unknown compatibility with ["$OS_STR"]"
        read -p "Do you want to continue? [y/n]: " -r
        if [[ ! $REPLY =~ ^[Yy]$ ]]
        then
            echo "Terminating..."
            sleep 2
            show_mainmenu
        fi
    fi

    # Check Errors
    set -e
    trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
    trap 'echo "\"${last_command}\" command failed with exit code $?."' ERR
}

function show_mainmenu(){
    while true
    do
        SELECTION=$(whiptail \
        --clear \
        --title "$WHIPTAIL_TITLE" \
        --menu "Select to install:" $WHIPTAIL_ROWS $WHIPTAIL_COLS $WHIPTAIL_SIZE \
        --ok-button "Install" \
        --cancel-button "Exit" \
        "${WHIPTAIL_LIST[@]}" \
        3>&1 1>&2 2>&3)

        if [ $? != 0 ]
        then
            echo "Terminated with exit button"
            exit
        fi

        echo "===== Script started ================================================"
        echo "Selected script: $SELECTION"
        ( eval "$SELECTION" )
        set +e # disable error checking
        trap - DEBUG ERR # cleaner traps
        echo "===== Script finished succesfully ==================================="
        sleep 2
    done
}


#########################################################################################################
############################## Install Script Functions #################################################
#########################################################################################################

WHIPTAIL_LIST=() # Start an empty list

#########################################################################################################

WHIPTAIL_LIST+=("install_tmux" "Tmux is a terminal multiplexer for Unix-like operating systems")
function install_tmux()
{
    check_install_script "Ubuntu18.04 Ubuntu16.04" ""

    # install
    sudo apt update
    sudo apt install tmux

    # modify configuration
    echo >$HOME/.tmux.conf
    cat >$HOME/.tmux.conf << EOF
set-option -g default-command "exec /bin/bash"
set-option -g allow-rename off
set -g default-terminal "screen-256color"
set -g status off
set -g mouse on
EOF
}

#########################################################################################################

WHIPTAIL_LIST+=("install_ros_kinetic" "ROS (Robot Operating System) provides libraries and tools to help software developers create robot applications")
function install_ros_kinetic()
{
    check_install_script "Ubuntu16.04" "Ubuntu18.04"

    # References:
    # https://wiki.gentoo.org/wiki/GCC_optimization

    # install
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt update
    sudo apt install ros-kinetic-desktop-full
    source /opt/ros/kinetic/setup.bash

    # install build-tools
    sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools

    # rosdep
    sudo rosdep init
    rosdep update

    # create workspace
    mkdir -p ~/catkin_ws/src
    cd ~/catkin_ws
    catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release

    # additions to .bashrc
    cat >>$HOME/.bashrc << EOF

#======================= ROS =======================
alias ros="source /opt/ros/kinetic/setup.bash; source ~/catkin_ws/devel/setup.bash"

# -ftree-vectorize
alias catkin_release='catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-march=native -mtune=native" -DCMAKE_CXX_FLAGS="-march=native -mtune=native"'
alias catkin_debug='catkin build --cmake-args -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="-march=native -mtune=native" -DCMAKE_CXX_FLAGS="-march=native -mtune=native"'
alias catkin_clean='catkin clean'
alias catkin_solve_dependencies='rosdep install --from-paths src --ignore-src -r'

export ROS_MASTER_URI=http://127.0.0.1:11311/
export ROS_IP=127.0.0.1
#===================================================
EOF

    whiptail --title "install_ros_melodic" \
    --msgbox "To use ros, open a terminal and write \"ros\", which is a alias added into .bashrc.\nAnd then you can use ros command" \
    $WHIPTAIL_ROWS $WHIPTAIL_COLS 3>&1 1>&2 2>&3
}

#########################################################################################################

WHIPTAIL_LIST+=("install_ros_melodic" "ROS (Robot Operating System) provides libraries and tools to help software developers create robot applications")
function install_ros_melodic()
{
    check_install_script "Ubuntu18.04" "Ubuntu16.04"

    # References:
    # https://wiki.gentoo.org/wiki/GCC_optimization

    # install
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt update
    sudo apt install ros-melodic-desktop-full
    source /opt/ros/melodic/setup.bash

    # install build-tools
    sudo apt install python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools

    # rosdep
    sudo rosdep init
    rosdep update

    # create workspace
    mkdir -p ~/catkin_ws/src
    cd ~/catkin_ws
    catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release

    # additions to .bashrc
    cat >>$HOME/.bashrc << EOF

#======================= ROS =======================
alias ros="source /opt/ros/melodic/setup.bash; source ~/catkin_ws/devel/setup.bash"

# -ftree-vectorize
alias catkin_release='catkin build --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_FLAGS="-march=native -mtune=native" -DCMAKE_CXX_FLAGS="-march=native -mtune=native"'
alias catkin_debug='catkin build --cmake-args -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="-march=native -mtune=native" -DCMAKE_CXX_FLAGS="-march=native -mtune=native"'
alias catkin_clean='catkin clean'
alias catkin_solve_dependencies='rosdep install --from-paths src --ignore-src -r'

export ROS_MASTER_URI=http://127.0.0.1:11311/
export ROS_IP=127.0.0.1
#===================================================
EOF

    whiptail --title "install_ros_melodic" \
    --msgbox "To use ros, open a terminal and write \"ros\", which is a alias added into .bashrc.\nAnd then you can use ros command" \
    $WHIPTAIL_ROWS $WHIPTAIL_COLS 3>&1 1>&2 2>&3
}

#########################################################################################################

WHIPTAIL_LIST+=("install_nvidia_drivers" "Install Nvidia GPU drivers with using ubuntu-drivers package")
function install_nvidia_drivers()
{
    check_install_script "Ubuntu18.04 Ubuntu16.04" ""

    # install
    sudo add-apt-repository ppa:graphics-drivers
    sudo apt update
    sudo ubuntu-drivers autoinstall
}

#########################################################################################################

WHIPTAIL_LIST+=("install_sublimetext3" "Sublime Text is a proprietary cross-platform source code editor with a Python application programming interface")
function install_sublimetext3()
{
    check_install_script "Ubuntu18.04 Ubuntu16.04" ""

    # install
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update
    sudo apt install sublime-text

    # modify configuration
    mkdir -p $HOME/.config/sublime-text-3/Packages/User
    cat >$HOME/.config/sublime-text-3/Packages/User/Preferences.sublime-settings << EOF
{
    "draw_white_space": "all",
    "translate_tabs_to_spaces": true
}
EOF
}

#########################################################################################################

WHIPTAIL_LIST+=("install_anaconda3" "Tensorflow + Keras + Theano + Jupyter Notebook etc. for deep learning computations")
function install_anaconda3()
{
    whiptail --title "install_anaconda3" \
    --msgbox "This script will install anaconda3 into a created bind mount folder in order to make anaconda3 folder moveable.\n\nIf you want to move your anaconda3 folder to another place, which consist of editing /etc/fstab then reboot, do not forget to mount bind to the same path after copying." \
    $WHIPTAIL_ROWS $WHIPTAIL_COLS 3>&1 1>&2 2>&3

    TENSORFLOW_PKG=$(whiptail \
    --nocancel \
    --title "install_anaconda3" \
    --menu "Select an installation:" $WHIPTAIL_ROWS $WHIPTAIL_COLS $WHIPTAIL_SIZE \
    "tensorflow" "Tensorflow with CPU" \
    "tensorflow-gpu" "Tensorflow with CUDA GPU" \
    3>&1 1>&2 2>&3)

    INSTALL_TARGET=$(whiptail \
    --nocancel \
    --title "install_anaconda3" \
    --inputbox "Input anaconda3 installation target:" $WHIPTAIL_ROWS $WHIPTAIL_COLS "$HOME/anaconda3" \
    3>&1 1>&2 2>&3)

    BIND_TARGET=$(whiptail \
    --nocancel \
    --title "install_anaconda3" \
    --inputbox "Input anaconda3 bind mount target:" $WHIPTAIL_ROWS $WHIPTAIL_COLS "/anaconda3" \
    3>&1 1>&2 2>&3)

    VIRT_ENV_NAME=$(whiptail \
    --nocancel \
    --title "install_anaconda3" \
    --inputbox "Input a name for conda virtual environment (without space and special characters):" $WHIPTAIL_ROWS $WHIPTAIL_COLS $TENSORFLOW_PKG \
    3>&1 1>&2 2>&3)

    sudo mkdir -p $INSTALL_TARGET
    sudo chown $USER:$USER $INSTALL_TARGET
    sudo mkdir -p $BIND_TARGET
    
    sudo mount --bind $INSTALL_TARGET $BIND_TARGET

    wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
    bash Anaconda3-2020.02-Linux-x86_64.sh -b -u -p $BIND_TARGET
    rm Anaconda3-2020.02-Linux-x86_64.sh
    echo "alias ana=\"export PATH=\${PATH}:$BIND_TARGET/bin\"" >> ~/.bashrc

    export PATH=${PATH}:$BIND_TARGET/bin
    conda create -y --name "$VIRT_ENV_NAME"
    source activate "$VIRT_ENV_NAME"

    conda install -c anaconda $TENSORFLOW_PKG \
                                 keras \
                                 theano \
                                 python

    conda install -c conda-forge jupyter \
                                    jupyter_contrib_nbextensions \
                                    sklearn-contrib-lightning \
                                    ipykernel \
                                    matplotlib \
                                    scipy \
                                    Pillow \
                                    pandas \
                                    scikit-image \
                                    scikit-learn \
                                    pydot \
                                    graphviz \
                                    pytorch \
                                    python \
                                    opencv \
                                    octave_kernel \
                                    sympy=1.5.1

    python -m ipykernel install --user --name "$VIRT_ENV_NAME" --display-name "$VIRT_ENV_NAME"

    whiptail --title "install_anaconda3" \
    --msgbox "To complete installation add this line to /etc/fstab:\n\n$INSTALL_TARGET $BIND_TARGET none defaults,bind 0 0" \
    $WHIPTAIL_ROWS $WHIPTAIL_COLS 3>&1 1>&2 2>&3

    whiptail --title "install_anaconda3" \
    --msgbox "To use anaconda3, open a terminal and write \"ana\", which is a alias added into .bashrc.\nAnd then you can use conda, jupter-notebook etc." \
    $WHIPTAIL_ROWS $WHIPTAIL_COLS 3>&1 1>&2 2>&3
}


#########################################################################################################
############################## Start the Installer ######################################################
#########################################################################################################


show_mainmenu
