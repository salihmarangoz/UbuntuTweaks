# For the latest version https://github.com/salihmarangoz/UbuntuTweaks

#=============================================== GLOBALS ====================================================

export BASHRC_EASY_FILES="$HOME/.bashrc.easy.files"
export BASHRC_CPU_THREADS="2" # cpu thread limiter for heavy tasks


#================================================= INSTALLER ================================================

THIS_FILENAME=`basename "$0"`
THIS_FILENAME_FULL="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/$THIS_FILENAME"
INSTALLER_FILENAME="bashrc_easy_installer.sh"
if [ "$THIS_FILENAME" = "$INSTALLER_FILENAME" ]; then
    echo "Installing BashrcEasy:"

    echo "- Copying BashrcEasy script to $HOME/.bashrc.easy"
    cp -f "$THIS_FILENAME_FULL" "$HOME/.bashrc.easy"

    if [ -z ${IS_EASYBASHRC_INSTALLED+x} ]; then
        echo "- BashrcEasy installation is not detected"
        echo "- Adding a line to .bashrc"
        echo "" >> $HOME/.bashrc
        echo 'source $HOME/.bashrc.easy' >> $HOME/.bashrc
        echo "- .bashrc file is updated. Please close this terminal and create a fresh one."
    fi
    echo "Done."
fi
export IS_EASYBASHRC_INSTALLED=1


#================================================= HELPER FUNCTIONS =========================================

function check_installation(){
    local CHECK_INSTALLATION=0
    for var in "$@"
    do
        if ! command -v $var &> /dev/null
        then
            echo "$var could not be found."
            local CHECK_INSTALLATION=1
        fi
    done
    return $CHECK_INSTALLATION
}


# EASYBASHRC:help_bashrc:Prints help message for easy bashrc
function help_bashrc(){
    echo ""
    echo "[*] Parameters:"
    echo "BASHRC_EASY_FILES: $BASHRC_EASY_FILES"
    echo "BASHRC_CPU_THREADS: $BASHRC_CPU_THREADS"
    echo ""
    local PARSEDBASHRC=$(cat ~/.bashrc.easy | grep "#EASY""BASHRC")
    local HELPSTRING="[*] Available commands:\n"
    while IFS= read -r line; do
        local COMMANDNAME=$(echo $line | cut -d':' -f2)
        local COMMANDDESCRIPTION=$(echo $line | cut -d':' -f3)
        local WHITESPACEFILLER="                                                   "
        local NEWHELPSTRING=$(printf '%.25s --> %s' "$COMMANDNAME$WHITESPACEFILLER" "$COMMANDDESCRIPTION")
        local HELPSTRING="$HELPSTRING$NEWHELPSTRING\n"
    done <<< "$PARSEDBASHRC"
    printf "$HELPSTRING\n"
}


#================================================= VARIOUS FIXES ============================================

# unlimited bash history
export HISTFILESIZE=-1
export HISTSIZE=-1
export HISTTIMEFORMAT="[%F %T] "
export HISTCONTROL=ignoredups


#EASYBASHRC:fix-skype:Kills Skype background processes without terminating the program
alias fix-skype='kill -HUP `ps -eo "pid:1,args:1" | grep -E "\-\-type=renderer.*skypeforlinux" | cut -d" " -f1`'


#================================================= EASY ALIASES =============================================


#SOURCE: https://github.com/BretFisher/jekyll-serve
#EASYBASHRC:jekyll_server:Starts jekyll docker used for rendering github.io webpages
function jekyll_server(){
    check_installation "docker"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install docker.io; sudo groupadd docker; sudo usermod -aG docker ${USER}"
       return 1
    fi
    sudo docker run -p 8080:4000 -v $(pwd):/site bretfisher/jekyll-serve
}


#SOURCE: https://github.com/Genymobile/scrcpy
#EASYBASHRC:android_remote_control:Android screenshare to the PC. Enable USB debugging on android, then connect with a USB.
function android_remote_control(){
    check_installation "docker" "adb"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install docker.io adb"
       return 1
    fi
    SELECTED_GRAPHICS="intel"           # "intel", "amd", or "nvidia"
    SCRCPY_PARAMS="--max-size 1800"
    adb kill-server
    xhost + local:docker
    sudo docker run --rm -i -t --privileged \
        -v /dev/bus/usb:/dev/bus/usb \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=$DISPLAY \
        pierlo1/scrcpy:$SELECTED_GRAPHICS /bin/sh -c "adb devices; read -p 'Allow USB debugging on the Android device then press any key to continue...'; scrcpy $SCRCPY_PARAMS"
}


#EASYBASHRC:no_network:Start $@ with no internet connection
function no_network(){
    check_installation "firejail"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install firejail"
       return 1
    fi
    firejail --noprofile --net=none $@
}


#EASYBASHRC:py:Shorter version of python3
alias py='python3' 


#EASYBASHRC:gitaddcommitpush:Adds all files in the current location, commits @1 and pushes to the origin
gitaddcommitpush(){ 
    check_installation "git"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install git"
       return 1
    fi
    git add . &&
    git commit -m "$1" &&
    git push origin
}


#EASYBASHRC:temp_chrome:Temporary google-chrome-browser. Can be reset with temp_chrome_reset
temp_chrome(){
    check_installation "google-chrome"
    EASY_CHROME="$BASHRC_EASY_FILES/chrome"
    EASY_CHROME_USERDATA="$EASY_CHROME/temp_userdata"
    touch "$EASY_CHROME/DELETE_temp_userdata_TO_RESET_CHROME"
    google-chrome --user-data-dir="$EASY_CHROME_USERDATA"
}


#EASYBASHRC:temp_chrome_reset:Describes instructions for resetting temp_chrome profile
temp_chrome_reset(){
    EASY_CHROME="$BASHRC_EASY_FILES/chrome"
    xdg-open "$EASY_CHROME"
}


#EASYBASHRC:enable_bluetooth:Enable bluetooth permanently
function enable_bluetooth(){
    sudo rfkill unblock bluetooth
    sudo systemctl enable bluetooth.service
    sudo systemctl start bluetooth.service
}


#EASYBASHRC:disable_bluetooth:Disable bluetooth permanently
function disable_bluetooth(){
    sudo systemctl disable bluetooth.service
    sudo systemctl stop bluetooth.service
}


#================================================= DATA PROCESSING ==========================================

#EASYBASHRC:dif:Colorful alternative to "diff", using git diff
function dif(){
    check_installation "git"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install git"
       return 1
    fi
    alias dif="git diff --no-index -- $1 $2"
}


#EASYBASHRC:scan_text:Select an area on the screen to run OCR and get text output
function scan_text(){
    check_installation "maim" "mogrify" "tesseract"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo add-apt-repository ppa:alex-p/tesseract-ocr-devel; sudo apt update; sudo apt install tesseract-ocr imagemagick maim"
       return 1
    fi
    #select tesseract_lang in eng rus equ ;do break;done # Quick language menu, add more if you need other languages.
    SCR_IMG=$(mktemp --tmpdir scan_textXXXXXXXX.png)
    OCR_TXT="${SCR_IMG%.*}"
    trap "rm $SCR_IMG" EXIT
    trap "rm $OCR_TXT.txt" EXIT
    maim -s $SCR_IMG -m 1
    mogrify -modulate 100,0 -resize 400% $SCR_IMG  #should increase detection rate
    tesseract $SCR_IMG $OCR_TXT &> /dev/null
    cat "$OCR_TXT.txt"
    rm "$SCR_IMG"
    rm "$OCR_TXT.txt"
}


#EASYBASHRC:scan_qrcode:Select an area on the screen to run zbarimg and get text output
function scan_qr(){
    check_installation "maim" "zbarimg"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install zbar-tools maim"
       return 1
    fi
    SCR_IMG=$(mktemp --tmpdir scan_qrXXXXXXXX.png)
    OCR_TXT="${SCR_IMG%.*}"
    trap "rm $SCR_IMG" EXIT
    maim -s $SCR_IMG -m 1
    zbarimg -q $SCR_IMG
    rm "$SCR_IMG"
}


#SOURCE: github.com/alexjc/neural-enhance
#EASYBASHRC:enhance_image:Neural image enhancer with 2x resolution increase
alias enhance_image='function ne() { docker run --rm -v "$(pwd)/`dirname ${@:$#}`":/ne/input -it alexjc/neural-enhance ${@:1:$#-1} "input/`basename ${@:$#}`"; }; ne'


#EASYBASHRC:compress_audio:Compress audio with MP3
function compress_audio(){
    check_installation "ffmpeg"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install ffmpeg"
       return 1
    fi
    for var in "$@"
    do
        INPUT_FILE="$var"
        OUTPUT_FILE="${INPUT_FILE%.*}.compressed.mp3"
        if [[ "$INPUT_FILE" == *".compressed."* ]]; then
            echo "$INPUT_FILE is already compressed! (according to the filename)"
            continue
        fi
        ffmpeg -i "$INPUT_FILE" -acodec libmp3lame -threads "$BASHRC_CPU_THREADS" "$OUTPUT_FILE"
    done
    alert "Audio compressing job finished"
}


#EASYBASHRC:compress_video:Compress videos with Vary the Constant Rate Factor to MP4
function compress_video(){
    check_installation "ffmpeg"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install ffmpeg"
       return 1
    fi
    for var in "$@"
    do
        INPUT_FILE="$var"
        OUTPUT_FILE="${INPUT_FILE%.*}.compressed.mp4"
        if [[ "$INPUT_FILE" == *".compressed."* ]]; then
            echo "$INPUT_FILE is already compressed! (according to the filename)"
            continue
        fi
        ffmpeg -i "$INPUT_FILE" -vcodec libx264 -crf 23 -threads "$BASHRC_CPU_THREADS" "$OUTPUT_FILE"
    done
    alert "Video compressing job finished"
}


#EASYBASHRC:archive_video:Compress videos to 720p resolution, mono audio channel, 15 fps
function archive_video(){
    check_installation "ffmpeg"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install ffmpeg"
       return 1
    fi
    for var in "$@"
    do
        INPUT_FILE="$var"
        OUTPUT_FILE="${INPUT_FILE%.*}.archived.mp4"
        if [[ "$INPUT_FILE" == *".archived."* ]]; then
            echo "$INPUT_FILE is already archived! (according to the filename)"
            continue
        fi
        ffmpeg -i "$INPUT_FILE" -r 15 -preset veryslow -s hd720 -map_channel 0.1.0 -async 1 -threads "$BASHRC_CPU_THREADS" "$OUTPUT_FILE"
    done
    alert "Video archiving job finished"
}


#EASYBASHRC:summarize_video:Summarizes the video by deleting duplicate frames
function summarize_video(){
    check_installation "ffmpeg"
    if [ $? -ne "0" ]; then
       echo "Please install it with: sudo apt install ffmpeg"
       return 1
    fi
    for var in "$@"
    do
        INPUT_FILE="$var"
        TMP_FILE=$(mktemp "XXXXXXXXXXXXXX$INPUT_FILE")
        OUTPUT_FILE="${INPUT_FILE%.*}.summarized.mp4"
        if [[ "$INPUT_FILE" == *".summarized."* ]]; then
            echo "$INPUT_FILE is already summarized! (according to the filename)"
            continue
        fi
        ffmpeg -y -i "$INPUT_FILE" -threads "$BASHRC_CPU_THREADS" -vf mpdecimate,setpts=N/FRAME_RATE/TB "$TMP_FILE"
        LAST_FRAME_POS=$(ffmpeg -i "$TMP_FILE" -threads "$BASHRC_CPU_THREADS" -map 0:v:0 -c copy -f null - 2>&1 | grep frame | cut -d' ' -f3)
        ffmpeg -i "$TMP_FILE" -threads "$BASHRC_CPU_THREADS" -vf trim=start_frame=0:end_frame=$LAST_FRAME_POS -an "$OUTPUT_FILE"
        rm "$TMP_FILE"
    done
    alert "Video summarizing job finished"
}


#EASYBASHRC:stabilize_video:Stabilizes/deshakes video by using vid.stab ffmpeg plugin
function stabilize_video(){
    BASHRC_EASY_FILES_FFMPEG="$BASHRC_EASY_FILES/ffmpeg"
    FFMPEG_EASY="$BASHRC_EASY_FILES_FFMPEG/ffmpeg"

    check_installation "$FFMPEG_EASY"
    if [ $? -ne "0" ]; then
        mkdir -p "$BASHRC_EASY_FILES_FFMPEG"
        wget "https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz" -O "$BASHRC_EASY_FILES/ffmpeg.tar.xz"
        tar xf "$BASHRC_EASY_FILES/ffmpeg.tar.xz" -C  "$BASHRC_EASY_FILES_FFMPEG" --strip-components=1
        rm "$BASHRC_EASY_FILES/ffmpeg.tar.xz"
    fi

    for var in "$@"
    do
        INPUT_FILE="$var"
        OUTPUT_FILE="${INPUT_FILE%.*}.stabilized.mp4"
        if [[ "$INPUT_FILE" == *".stabilized."* ]]; then
            echo "$INPUT_FILE is already stabilized! (according to the filename)"
            continue
        fi
        TRANSFORM_FILE=$(mktemp "XXXXXXXXXXXXXXtransform.trf")
        $FFMPEG_EASY -i "$INPUT_FILE" -threads "$BASHRC_CPU_THREADS" -vf vidstabdetect="$TRANSFORM_FILE" -f null -
        $FFMPEG_EASY -i "$INPUT_FILE" -threads "$BASHRC_CPU_THREADS" -vf vidstabtransform="$TRANSFORM_FILE",unsharp=5:5:0.8:3:3:0.4 "$OUTPUT_FILE"
        rm "$TRANSFORM_FILE"
    done
    alert "Video stabilizing job finished"
}