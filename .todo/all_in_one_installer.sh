#!/bin/bash

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