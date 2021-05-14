# Custom bash aliases

Save from PC-CHARLIE - Ubuntu 18.04 - Kernel 5.4.0-73-generic - 14/05/2021 :

```shell
##
# Host specific functions
##

# Function to set terminal title
function set-title(){
  if [[ -z "$ORIG" ]]; then
    ORIG="$PS1"
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1="${ORIG}${TITLE}"
}

##
# Host specific aliases
##

# To perform host updates
alias maj='sudo apt update && sudo apt full-upgrade'

# Get 'sync' command status
alias sync-status='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# Valgrind commands
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias vg-helgrind='valgrind --tool=helgrind'

# Go to Qt worspace
alias qt-workspace='cd /home/charlie/Documents/workspaces/workspaceQT'

##
# Cobra specific aliases
##

# Launch minicom session of Cobra (via UART)
alias cobra-uart='sudo minicom -D /dev/ttyUSB0 -b 115200'

# Launch SSH session of Cobra
alias cobra-ssh-ciele='ssh ciele@192.168.0.5'
alias cobra-ssh-root='ssh root@192.168.0.5'

# Generate new ssh key with Cobra device
alias cobra-keygen='ssh-keygen -f "/home/charlie/.ssh/known_hosts" -R "192.168.0.5"'

# Go to Cobra workspace
alias cobra-libs='cd ~/Documents/CobraWorkspaces/Cobra-applicationLayer/06-app_layer/03-libs'
alias cobra-apps='cd ~/Documents/CobraWorkspaces/Cobra-applicationLayer/06-app_layer/04-apps'
alias cobra-build-ciele='cd ~/Documents/CobraWorkspaces/Cobra-buildTarget-boardCiele'
alias cobra-build-armadeus='cd ~/Documents/CobraWorkspaces/Cobra-buildTarget-boardArmadeus/RAYPLICKER-V2/bsp-rayplicker-v2-1.0/software'

# Load cross-compiler for arm32 and aarch64
alias cobra-load-gcc-arm32='source ~/Documents/CobraWorkspaces/Cobra-applicationLayer/env_arm32.sh'
alias cobra-load-gcc-aarch64='source ~/Documents/CobraWorkspaces/Cobra-applicationLayer/env_aarch64.sh'

# Display streaming send by Cobra device (use Intel Graphics Card instead of NVidia)
alias cobra-gst-get-stream='LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc address=0.0.0.0 port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink'
```