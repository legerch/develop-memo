# Custom bash aliases

Save from : PC-CHARLIE - Ubuntu 20.04.2 LTS - Kernel 5.4.0-80-generic - 29/07/2021 :

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

# Function used to create a copy of ~/.bash_aliases into a markdown file :
# ${1} : file to write (ex : file.md)
function save-custom-bash-aliases(){
    # Check that a destination file is available
    if [ -z "${1}" ]; then
        printf "USAGE : save-bash-aliases <file_destination>\n"
        return 1
    fi

    local fileDest="${1}"
    local fileSrc="${HOME}/.bash_aliases"
    local infoUnameNodename=$( uname -n )
    local infoUnameKernel=$( uname -r )
    local infoOsRelease=$( grep -oP '(?<=^PRETTY_NAME=).+' /etc/os-release | tr -d '"' )
    local infoDate=$( date +%d/%m/%Y )

    # Delete content
    > "${fileDest}"

    # Write into file
    ## Context informations
    printf "# Custom bash aliases\n\n" >> "${fileDest}"
    printf "Save from : ${infoUnameNodename} - ${infoOsRelease} - Kernel ${infoUnameKernel} - ${infoDate} :\n\n" >> "${fileDest}"

    ## Bash aliases script
    printf "\`\`\`shell\n" >> "${fileDest}"
    printf "%s\n" "$(<${fileSrc})" >> "${fileDest}"
    printf "\`\`\`\n" >> "${fileDest}"
}

# Function used as a memo to build Cobra OS :
# - Print command to use for Buildroot Cobra project
# - List all available configs from "/configs" directory
function memo-cobra-build(){
    local pathCfgFiles="${HOME}/Documents/CobraWorkspaces/Cobra-buildTarget-buildroot/RAYPLICKER-V2/bsp-external-rayplicker-v2/configs/"
    
    printf "make PROJECT_DEFCONFIG=imx8_armadeus_run2_debug PROJECT_USE_BR_CUSTOM_PATCHES=1 clean\n"
    printf "Available configs files:\n"
    for i in `ls ${pathCfgFiles} | grep "\defconfig"`; do
        printf "\t${i}\n"
    done
}

##
# Host specific aliases
##

# To perform host updates
alias maj='sudo apt update && sudo apt full-upgrade'

# To uninstall a package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/151941/how-can-you-completely-remove-a-package)
alias apt-uninstall="sudo apt purge --autoremove"

# Get 'sync' command status
alias sync-status='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# Valgrind commands
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias vg-helgrind='valgrind --tool=helgrind'

# Go to Qt worspace
alias qt-workspace='cd /home/charlie/Documents/workspaces/workspaceQT'

# Copy VsCode snippets to documentation folder
alias snippet-copy-c='cp ~/.config/Code/User/snippets/c.json ~/Documents/Borea/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/c.json'
alias snippet-copy-sh='cp ~/.config/Code/User/snippets/shellscript.json ~/Documents/Borea/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/shellscript.json'

# Use as a memo to load library into env variables
alias memo-lib-ld='printf "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../bin/\n"'

# Use to save custom bash aliases do documentation folder
alias bash-aliases-update-doc='save-custom-bash-aliases ~/Documents/Borea/DocumentationsCobra/Documentations/Developpement/Linux/linux/custom_bash_aliases.md'

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
alias cobra-build='cd ~/Documents/CobraWorkspaces/Cobra-buildTarget-buildroot/RAYPLICKER-V2/'

# Load cross-compiler for arm32 and aarch64
alias cobra-load-gcc-arm32='source ~/Documents/CobraWorkspaces/Cobra-applicationLayer/env_arm32.sh'
alias cobra-load-gcc-aarch64='source ~/Documents/CobraWorkspaces/Cobra-applicationLayer/env_aarch64.sh'

# Display streaming send by Cobra device (use Intel Graphics Card instead of NVidia)
alias cobra-gst-get-stream='LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc address=0.0.0.0 port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink'
```
