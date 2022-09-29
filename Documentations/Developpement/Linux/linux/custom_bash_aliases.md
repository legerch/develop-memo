# Custom bash aliases

Save from : charlie-B660M - Ubuntu 22.04.1 LTS - Kernel 5.15.0-48-generic - 29/09/2022 :

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

# Function used to retrieve all arduino-cli informations to proceed to update
function update-arduino-cli-binary-get-infos-latest()
{
    # Find current architecture
    local hostArch=$(uname -m)
    case ${hostArch} in
    armv5*) hostArch="armv5" ;;
    armv6*) hostArch="ARMv6" ;;
    armv7*) hostArch="ARMv7" ;;
    aarch64) hostArch="ARM64" ;;
    arm64) hostArch="ARM64" ;;
    x86) hostArch="32bit" ;;
    x86_64) hostArch="64bit" ;;
    i686) hostArch="32bit" ;;
    i386) hostArch="32bit" ;;
    esac

    # Use the GitHub releases webpage to find the latest version for this project
    local projectOwner="arduino"
    local projectName="arduino-cli"

    local versionRegex="[0-9][A-Za-z0-9\.-]*"
    local latestVersionUrl="https://github.com/${projectOwner}/${projectName}/releases/latest"

    m_arduinoCliLatestVersionTag=$(curl -SsL ${latestVersionUrl} | grep -o "<title>Release ${versionRegex} · ${projectOwner}/${projectName}" | grep -o "${versionRegex}")
    m_arduinoCliLatestVersionArchive="${projectName}_${m_arduinoCliLatestVersionTag}_Linux_${hostArch}.tar.gz"
    m_arduinoCliLatestVersionUrl="https://downloads.arduino.cc/${projectName}/${m_arduinoCliLatestVersionArchive}"
}

# Function used to download latest binary of arduino-cli
function update-arduino-cli-binary-get-binary()
{
    local locationDirTmp="/tmp/"
    local locationOutTmp="${locationDirTmp}/${m_arduinoCliLatestVersionArchive}"

    local binFile="arduino-cli"
    local locationDirFinal="/usr/local/bin"
    local locationOutFinal="${locationDirFinal}/${binFile}"

    printf "Download ${m_arduinoCliLatestVersionUrl}...\n"
    curl -sL ${m_arduinoCliLatestVersionUrl} -o "${locationOutTmp}"
    tar -xf ${locationOutTmp} -C ${locationDirTmp}

    printf "Install ${binFile} at \"${locationDirFinal}\"\n"
    sudo cp "${locationDirTmp}/${binFile}" "${locationOutFinal}"
    sudo chmod +x "${locationOutFinal}"

    printf "${binFile} ${m_arduinoCliLatestVersionTag} have been installed to ${locationOutFinal}\n"
}

# Function used to update arduino-cli binary
function update-arduino-cli-binary()
{
    local doUpdateArduinoCli=0

    # Check current version
    arduino-cli version

    # Check than mandatory tools are available to proceed to update
    which curl &> /dev/null
    local curlStatus=$?
    if [ ${curlStatus} -eq 0 ]; then
        
        # Ask user before proceed to FW update
        read -p "Do you want to update arduino-cli binary ? (yes/no) " userInput

        case "${userInput}" in 
            yes)
                doUpdateArduinoCli=1
                ;;

            *)
                doUpdateArduinoCli=0
                ;;
        esac

        # Display update status perform
        if [ ${doUpdateArduinoCli} -eq 1 ]; then
            printf "arduino-cli will be updated...\n"
            
            update-arduino-cli-binary-get-infos-latest
            update-arduino-cli-binary-get-binary

        else
            printf "No arduino-cli binary update have been performed\n"
        fi
        
    else
        printf "You need curl as download tool. Please install it first before continuing\n"
    fi
}

# Function used to get wifi password of specific network
# ${1} : SSID to retrieve
function print-passwd-wifi-specific()
{
    local ssid="${1}"

    if [ -z "${ssid}" ]; then
        printf "Cannot retrieve passwd, no arguments was supplied\n"
    else
        local ssidInfos="/etc/NetworkManager/system-connections/${ssid}.nmconnection"
        if [ -f "${ssidInfos}" ]; then
            local passwd="$(sudo cat ${ssidInfos} | grep "psk=" | cut -d "=" -f 2)"
            printf "Wifi password for [${ssid}] is [${passwd}]\n"
        else
            printf "Cannot retrieve passwd, ssid [${ssid}] is unknown\n"
        fi
    fi
}

# Function used to set LAMP properties
function set-lamp-properties()
{
    local cmd="${1}"
    local message="${2}"

    sudo systemctl "${cmd}" apache2 && sudo systemctl "${cmd}" mysql && printf "${message}\n"
}

##
# Host specific aliases
##

# To perform host updates
alias maj-apt='sudo apt update && sudo apt full-upgrade'
alias maj-snap='sudo snap refresh'
alias maj-flatpak='flatpak update'
alias maj-firmware='update-host-fw'
alias maj-arduino-cli-bin='update-arduino-cli-binary'

# To uninstall a package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/151941/how-can-you-completely-remove-a-package)
alias apt-uninstall="sudo apt purge --autoremove"

# PPA related commands for easier install/uninstall
alias ppa-add-repo="sudo add-apt-repository"
alias ppa-remove-repo="sudo ppa-purge" # Use "ppa-purge" command instead of "add-apt-repository --remove" in order to perform a real clean

# In order to "disallow" some commands (It is use for my embedded target and I don't want to perform them on my host machine)
alias poweroff='printf "I m not gonna do that !\n"'
alias reboot='printf "I m not gonna do that !\n"'

# Aliases used for LAMP (Linux, Apache, MySQL,PHP) management
alias lamp-autostart-enable='set-lamp-properties "enable" "LAMP auto-start enabled !"'
alias lamp-autostart-disable='set-lamp-properties "disable" "LAMP auto-start disabled !"'
alias lamp-start='set-lamp-properties "start" "LAMP started !"'
alias lamp-stop='set-lamp-properties "stop" "LAMP stopped !"'
alias lamp-restart='set-lamp-properties "restart" "LAMP restarted !"'

# Aliases used for password network properties
alias show-passwd-wifi-current='nmcli device wifi show-password'
alias show-passwd-wifi-specific='print-passwd-wifi-specific'

# Get 'sync' command status
alias sync-status='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# Valgrind commands
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes'
alias vg-helgrind='valgrind --tool=helgrind'
alias memo-vg-memcheck='printf "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes\n"'

# Go to worspaces
alias workspace-apache='cd /var/www/'
alias workspace-qt='cd /home/charlie/Documents/workspaces/workspace-qt'
alias workspace-vscode='cd /home/charlie/Documents/workspaces/workspace-vscode'

# Go to AppImage folder
alias workspace-appimage='cd /home/charlie/Téléchargements/app-image'

# Copy VsCode snippets to documentation folder
alias snippet-c-export='cp ~/.config/Code/User/snippets/c.json ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/c.json && printf "Done !\n"'
alias snippet-c-import='cp ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/c.json ~/.config/Code/User/snippets/c.json && printf "Done !\n"'
alias snippet-c-edit='code ~/.config/Code/User/snippets/c.json'
alias snippet-sh-export='cp ~/.config/Code/User/snippets/shellscript.json ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/shellscript.json && printf "Done !\n"'
alias snippet-sh-import='cp ~/Documents/workspaces/workspace-vscode/DocumentationsCobra/Documentations/Developpement/IDE/VsCode/ressources/shellscript.json ~/.config/Code/User/snippets/shellscript.json && printf "Done !\n"'
alias snippet-sh-edit='code ~/.config/Code/User/snippets/shellscript.json'

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
alias bash-aliases-edit-vi='vi ~/.bash_aliases'
alias bash-aliases-edit-vscode='code ~/.bash_aliases'
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
alias doc-benchmanager-lib='generate-project-documentation /home/charlie/Documents/workspaces/workspace-qt/BancCalibration-application/BancCalibration-library Doxyfile'
alias doc-benchmanager-arduino='generate-project-documentation /home/charlie/Documents/workspaces/workspace-vscode/BancCalibration-arduino Doxyfile'

##
# Arduino specific aliases
##
alias arduino-uart='sudo minicom -D /dev/ttyACM0 -b 115200'

##
# Cobra specific aliases
##

# Launch minicom session of Cobra (via UART)
alias cobra-uart='sudo minicom -D /dev/ttyUSB0 -b 115200'

# Launch SSH session of Cobra
alias cobra-ssh-root='ssh root@172.27.77.5'

# Generate new ssh key with Cobra device
alias cobra-keygen='ssh-keygen -f "/home/charlie/.ssh/known_hosts" -R "172.27.77.5"'

# Go to Cobra workspace
alias cobra-libs='cd ~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/03-libs'
alias cobra-apps='cd ~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/04-apps'
alias cobra-build='cd ~/Documents/workspaces/workspace-cobra/Cobra-BuildTarget-Buildroot/RAYPLICKER-V2/'
alias cobra-bsp='cd ~/Documents/workspaces/workspace-cobra/bsp/'
alias cobra-kernels='cd ~/Documents/workspaces/workspace-cobra/kernels/'
alias cobra-releases='cd ~/Téléchargements/ReleasesCobra/'

# Cobra SDK properties
alias cobra-sdk-gdb-armadeus='/home/charlie/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/05-bsp/02-armadeus-imx8-bsp/01-sdk/aarch64-buildroot_borea-linux-gnu_sdk-buildroot/bin/aarch64-buildroot_borea-linux-gnu-gdb'

# Display streaming send by Cobra device (use Intel Graphics Card instead of NVidia)
alias cobra-gst-get-stream='LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! queue ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink'
```
