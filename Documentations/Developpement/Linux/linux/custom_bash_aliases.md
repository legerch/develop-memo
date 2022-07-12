# Custom bash aliases

Save from : charlie-B660M - Ubuntu 22.04 LTS - Kernel 5.15.0-40-generic - 29/06/2022 :

```shell
##
# Host specific functions
##

# Function to set terminal title
function set-title()
{
  if [[ -z "$ORIG" ]]; then
    ORIG="$PS1"
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1="${ORIG}${TITLE}"
}

# Function used to create a copy of ~/.bash_aliases into a markdown file :
# ${1} : file to write (ex : file.md)
function save-custom-bash-aliases()
{
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
function memo-cobra-build()
{
    local pathCfgFiles="${HOME}/Documents/workspaces/workspace-cobra/Cobra-BuildTarget-Buildroot/RAYPLICKER-V2/bsp-external-rayplicker-v2/configs/"
    
    printf "make PROJECT_DEFCONFIG=imx8_armadeus_run2_debug PROJECT_USE_BR_CUSTOM_PATCHES=1 clean\n"
    printf "Available configs files:\n"
    for i in `ls ${pathCfgFiles} | grep "\defconfig"`; do
        printf "\t${i}\n"
    done
}

# Function used to generate doxygen documentation :
# ${1} : path to root project
# ${2} : Doxyfile name to use
function generate-project-documentation()
{
    local docPath="${1}"
    local docFile="${2}"

    local docDoxygen="${docPath}/${docFile}"

    # Check that project doc file is valid
    if [ ! -f "${docDoxygen}" ]; then
        printf "USAGE : generate-project-documentation <project_path> <doxygen_file>\n"
        return 1
    fi

    # Go to project directory
    cd ${docPath}

    # Generate documentation
    doxygen ${docFile}

    # Return to previous directory
    cd ${OLDPWD}
}

# Function used to update host firmwares
function update-host-fw()
{
    local doUpdateFw=0

    # Refresh list of host devices
    fwupdmgr refresh

    # Check available firmware updates
    fwupdmgr get-updates

    # Ask user before proceed to FW update
    read -p "Do you want to update host firmware ? (yes/no) " userInput

    case "${userInput}" in 
        yes)
            doUpdateFw=1
            ;;

        *)
            doUpdateFw=0
            ;;
    esac

    if [ ${doUpdateFw} -eq 1 ]; then
        printf "Host firmware will be updated...\n"
        fwupdmgr update
    else
        printf "No firmware update have been performed\n"
    fi
}

##
# Host specific aliases
##

# To perform host updates
alias maj-apt='sudo apt update && sudo apt full-upgrade'
alias maj-snap='sudo snap refresh'
alias maj-flatpak='flatpak update'
alias maj-firmware='update-host-fw'

# In order to "disallow" some commands (It is use for my embedded target and I don't want to perform them on my host machine)
alias poweroff='printf "I m not gonna do that !\n"'
alias reboot='printf "I m not gonna do that !\n"'

# To uninstall a package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/151941/how-can-you-completely-remove-a-package)
alias apt-uninstall="sudo apt purge --autoremove"

# Get 'sync' command status
alias sync-status='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# Valgrind commands
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias vg-helgrind='valgrind --tool=helgrind'
alias memo-vg-memcheck='printf "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes\n"'

# Go to worspaces
alias workspace-qt='cd /home/charlie/Documents/workspaces/workspace-qt'
alias workspace-vscode='cd /home/charlie/Documents/workspaces/workspace-vscode'

# Go to AppImage folder
alias workspace-appimage='cd /home/charlie/Téléchargements/app-image'

# Copy VsCode snippets to documentation folder
alias snippet-c-export='cp ~/.config/Code/User/snippets/c.json ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/c.json'
alias snippet-c-import='cp ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/c.json ~/.config/Code/User/snippets/c.json'
alias snippet-sh-export='cp ~/.config/Code/User/snippets/shellscript.json ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/shellscript.json'
alias snippet-sh-import='cp ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/shellscript.json ~/.config/Code/User/snippets/shellscript.json'

# Used as a memo to load library into env variables
alias memo-lib-ld='printf "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../../helper_tools/bin:../../custom_error/bin:../bin\n"'
# Memo used to remain how to remove last line of a file
alias memo-remove-last-line='printf "sed -i \"$ d\" file.txt\n"'
# Memo used to know how to use raw2rgbpnm (https://git.retiisi.org.uk/?p=~sailus/raw2rgbpnm.git)
alias memo-raw2rgbpnm='printf "raw2rgbpnm -s 1288x968 -f SGRBG10 frame-000000.bin frame-000000.ppm\n"'
# Memo on how to use yavta (https://git.ideasonboard.org/?p=yavta.git;a=summary)
alias memo-yavta='printf "yavta -f SGRBG16 -s 648x648 -c8 -F/tmp/frame-#.bin /dev/video0\n"'

# Use to save custom bash aliases do documentation folder
alias bash-aliases-update-doc='save-custom-bash-aliases ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/Linux/linux/custom_bash_aliases.md && printf "Done !\n"'

# Use to manage "bash_aliases" file
alias bash-aliases-edit='vi ~/.bash_aliases'
alias bash-aliases-reload='source ~/.bash_aliases && printf "Done !\n"'

# Create alias for gitui program, which doesn't yet have a proper system installation, so we use binaries (https://github.com/extrawurst/gitui)
alias gituibin='~/Téléchargements/Fichiers\ Setup/gitui-linux-musl/gitui'

# Create alias for application used to create an AppImage, which are released under binaries
alias linuxdeploy.AppImage='~/Téléchargements/apps/linuxdeploy/linuxdeploy-x86_64.AppImage'
alias appimagetool.AppImage='~/Téléchargements/apps/appimagekit/appimagetool-x86_64.AppImage'

# Create aliases used to generate documentation of multiple projects
alias doc-cobra-libs='generate-project-documentation /home/charlie/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/03-libs Doxyfile'
alias doc-cobra-apps='generate-project-documentation /home/charlie/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/04-apps Doxyfile'
alias doc-rpcompute='generate-project-documentation /home/charlie/Documents/workspaces/workspace-qt/Cobra-AppCommunication/RP_Lib/deps/RP_Compute Doxyfile'
alias doc-rplib='generate-project-documentation /home/charlie/Documents/workspaces/workspace-qt/Cobra-AppCommunication/RP_Lib Doxyfile'

##
# Cobra specific aliases
##

# Launch minicom session of Cobra (via UART)
alias cobra-uart='sudo minicom -D /dev/ttyUSB0 -b 115200'

# Launch SSH session of Cobra
alias cobra-ssh-root='ssh root@192.168.0.5'

# Generate new ssh key with Cobra device
alias cobra-keygen='ssh-keygen -f "/home/charlie/.ssh/known_hosts" -R "192.168.0.5"'

# Go to Cobra workspace
alias cobra-libs='cd ~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/03-libs'
alias cobra-apps='cd ~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/04-apps'
alias cobra-build='cd ~/Documents/workspaces/workspace-cobra/Cobra-BuildTarget-Buildroot/RAYPLICKER-V2/'
alias cobra-bsp='cd ~/Documents/workspaces/workspace-cobra/bsp/'
alias cobra-kernels='cd ~/Documents/workspaces/workspace-cobra/kernels/'
alias cobra-releases='cd ~/Téléchargements/ReleasesCobra/'

# Display streaming send by Cobra device (use Intel Graphics Card instead of NVidia)
alias cobra-gst-get-stream='LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! queue ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink'
```
