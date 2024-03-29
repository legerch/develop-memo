# Custom bash aliases

Save from : charlie-B660M - Ubuntu 22.04.4 LTS - Kernel 6.5.0-26-generic - 27/03/2024 :

```shell
##
# Host specific functions
##

# Function to set terminal title
function default-ps1-set-title()
{
    if [[ -z "$ORIG" ]]; then
        ORIG="$PS1"
    fi
    TITLE="\[\e]2;$*\a\]"
    PS1="${ORIG}${TITLE}"
}

function set-title()
{
    TERM_TITLE="$@"
}

function user-answer-is-yes()
{
    local isYes=0

    read -p "${1} (y/n) ? " answer
    case ${answer:0:1} in
        Y|y|YES|Yes|yes)
            isYes=1
        ;;

        *)
            isYes=0
        ;;
    esac

    echo "${isYes}"
}

function verify-min-bash-version()
{
    local targetVersion="${1}"
    local currentVersion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}.${BASH_VERSINFO[2]}"
    local isValid=0

    if [[ "${currentVersion}" > "${targetVersion}" || "${currentVersion}" == "${targetVersion}" ]]; then
        isValid=1
    fi

    echo "${isValid}"
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
    # Verify bash version superior to 4.2.0 (to use a negative index)
    local canRun=$(verify-min-bash-version "4.2.0")
    if [ ${canRun} -ne 1 ]; then 
        printf "Unable to perform command, require bash version 4.2.0\n"
        return 1
    fi

    # Retrieve list of configurations files (use "find" with "-print0" because don't parse 'ls': https://mywiki.wooledge.org/ParsingLs)
    local pathCfgFiles="${HOME}/Documents/workspaces/workspace-cobra/Cobra-BuildTarget-Buildroot/RAYPLICKER-V2/bsp-external-rayplicker-v2/configs/"
    
    local listCfg=($(find ${pathCfgFiles} -type f -name "*defconfig" -print0 | xargs -0 basename -a | sed 's/_defconfig//'))
    local lastCfg=${listCfg[-1]}

    # Print informations
    printf "make PROJECT_DEFCONFIG=${lastCfg} PROJECT_USE_BR_CUSTOM_PATCHES=1 clean\n"
    printf "Available configs files:\n"
    for i in "${listCfg[@]}"; do
        printf "\t${i}\n"
    done
}

# Function used to copy Cobra firmware to localhost :
# ${1} : Path to localhost directory
# ${2} : Firmare version with hyphen separator
function copy-cobra-fw-release-to-localhost()
{
    local dstFw="${1}"

    local fwNameHyphen="${2}"
    local fwNameUnderscore=${fwNameHyphen//[-]/_}

    local pathFw="${HOME}/Documents/workspaces/workspace-cobra/cobra-releases/${fwNameHyphen}/${fwNameUnderscore}-imx8_armadeus_run2_release/image/rayplicker-v2-${fwNameUnderscore}"

    if [ -f "${pathFw}" ]; then
        cp "${pathFw}" "${dstFw}"
        printf "Firmware \"${pathFw}\" has been copied to \"${dstFw}\"\n"
    else
        printf "Firmware \"${pathFw}\" can't be found\n"
    fi
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
    doUpdateFw=$(user-answer-is-yes "Do you want to update host firmware")
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
    if [ ${curlStatus} -ne 0 ]; then
        printf "You need curl as download tool. Please install it first before continuing\n"
        return 1
    fi

    # Ask user before proceed to FW update
    doUpdateArduinoCli=$(user-answer-is-yes "Do you want to update arduino-cli binary")
    if [ ${doUpdateArduinoCli} -eq 1 ]; then
        printf "arduino-cli will be updated...\n"
        
        update-arduino-cli-binary-get-infos-latest
        update-arduino-cli-binary-get-binary

    else
        printf "No arduino-cli binary update have been performed\n"
    fi
}

# Function used to download tarball from github repositories
function github-dl-tarball()
{
    local owner="${1}"
    local repo="${2}"
    local version="${3}"

    local doDlTarball=0

    # Check than mandatory tools are available to download tarball
    which curl &> /dev/null
    local curlStatus=$?
    if [ ${curlStatus} -ne 0 ]; then
        printf "You need curl as download tool. Please install it first before continuing\n"
        return 1
    fi

    # Ask user before proceed to download
    local url="https://github.com/${owner}/${repo}/archive/${version}.tar.gz"
    printf "Tarball URL is: ${url}\n\n"

    printf "Expected format is: github-dl-tarball <owner> <repo> <version_or_sha1>\n"
    doDlTarball=$(user-answer-is-yes "Proceed")

    # Perform download in current directory
    if [ ${doDlTarball} -eq 1 ]; then
        curl -L ${url} -o "${repo}-${version}.tar.gz"
    else
        printf "No file has been downloaded\n"
    fi
}

# Function used to generate wifi QrCode
# Note 1 : "qrencode" package must be available (used to generate QrCode).
# Note 2 : Bash 4 minimum is needed (used to easily manage lower/upper case)
#
# Wifi QrCode format :
# - https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11
# - https://feeding.cloud.geek.nz/posts/encoding-wifi-access-point-passwords-qr-code/
# - https://pocketables.com/2022/01/how-to-format-that-wifi-qr-code-in-plain-text.html
#
function generate-wifi-qrcode()
{
    local argSsid="${1}"
    local argSecurity="${2^^}"
    local argPasswd="${3}"
    
    local security=""

    # Found out security type
    if [[ "${argSecurity}" == *"WPA"* ]]; then
        security="WPA"
    else
        security="WEP"
    fi

    # Generate plain text to encode
    local wifiTxt="WIFI:S:${argSsid};T:${security};P:${argPasswd};;"

    # Print QrCode
    printf "\n"
    qrencode -m 2 -t utf8 <<< "${wifiTxt}"
    printf "\n"

}

# Function used to get wifi password of specific network.
# A QrCode will be generated if "qrencode" package available, otherwise
# wifi infos are only displayed.
#
# ${1} : SSID to retrieve
#
function print-passwd-wifi-specific()
{
    local ssid="${1}"
    if [ -z "${ssid}" ]; then
        printf "Cannot retrieve passwd, no arguments was supplied\n"
        return 1
    fi

    local ssidInfos="/etc/NetworkManager/system-connections/${ssid}.nmconnection"
    if [ -f "${ssidInfos}" ]; then            
        local security="$(sudo cat ${ssidInfos} | grep "key-mgmt=" | cut -d "=" -f 2)"
        local passwd="$(sudo cat ${ssidInfos} | grep "psk=" | cut -d "=" -f 2)"
        
        printf "\nSSID: ${ssid}\nSecurity: ${security}\nPassword: ${passwd}\n"

        which qrencode &> /dev/null
        local qrStatus=$?
        if [ ${qrStatus} -eq 0 ]; then
            generate-wifi-qrcode "${ssid}" "${security}" "${passwd}"
        fi

    else
        printf "Cannot retrieve passwd, ssid [${ssid}] is unknown\n"
    fi
}

# Function used to set LAMP properties
function set-lamp-properties()
{
    local cmd="${1}"
    local message="${2}"

    sudo systemctl "${cmd}" apache2 && sudo systemctl "${cmd}" mysql && printf "${message}\n"
}

# Function used to rename all files extensions
# Doc: https://manpages.ubuntu.com/manpages/jammy/en/man1/file-rename.1p.html
function rename-file-extension()
{
    local oldExt="${1}"
    local newExt="${2}"

    local doRenaming=0

    if [ -z "${oldExt}" ] || [ -z "${newExt}" ]; then
        printf "Usage: rename-file-extension oldExt newExt\n"
        printf "Note: Only files in current directory will be renamed\n"
        return 1
    fi

    printf "Files will be renamed as follow:\n"
    file-rename -v -n "s/.${oldExt}/.${newExt}/" *".${oldExt}"

    doRenaming=$(user-answer-is-yes "Proceed")
    if [ ${doRenaming} -eq 1 ]; then
        file-rename "s/.${oldExt}/.${newExt}/" *".${oldExt}"
        printf "Done. \n"
    else
        printf "Operation canceled. \n"
    fi
}

# Functions used to manage kernel perf property
# Doc: https://askubuntu.com/questions/1400874/what-does-perf-paranoia-level-four-do
function perf-level-get()
{
    sysctl kernel.perf_event_paranoid
}

function perf-level-set()
{
    local level="${1}"
    local doSetPerfLevel=0

    printf "This command will be executed:\n"
    printf "sudo sysctl kernel.perf_event_paranoid=${level}\n"
    
    doSetPerfLevel=$(user-answer-is-yes "Proceed")
    if [ ${doSetPerfLevel} -eq 1 ]; then
        sudo sysctl kernel.perf_event_paranoid="${level}"
        printf "Done. \n"
    else
        printf "Operation canceled. \n"
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
alias maj-arduino-cli-bin='update-arduino-cli-binary'

# To uninstall a package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/151941/how-can-you-completely-remove-a-package)
alias apt-uninstall="sudo apt purge --autoremove"
alias apt-list-installed="apt list --installed"
# To uninstall a snap package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/1130791/how-to-uninstall-a-package-installed-from-snapcraft)
alias snap-uninstall="sudo snap remove --purge"
alias snap-list-revs="snap list --all"
alias snap-revert="sudo snap revert"

# PPA related commands for easier install/uninstall
# Blog helper: https://blog.desdelinux.net/fr/ppa-purge-como-remover-un-repositorio-ppa-en-forma-segura/
alias ppa-add-repo="sudo add-apt-repository"
alias ppa-remove-repo="sudo ppa-purge" # Use "ppa-purge" command instead of "add-apt-repository --remove" in order to perform a real clean
alias ppa-list="grep -i ppa.launchpad.net /etc/apt/sources.list.d/*.list"

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

# Aliases used to scan available networks
alias scan-wifi-basic='nmcli dev wifi'
alias scan-wifi-details='nmcli -m multiline -f ALL dev wifi'
alias scan-wifi-iw-memo='printf "sudo iw dev <interface> scan\n"'

# Get 'sync' command status
alias sync-status='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# Valgrind commands
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --track-fds=yes'
alias vg-helgrind='valgrind --tool=helgrind'
alias memo-vg-memcheck='printf "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --track-fds=yes\n"'

# CMake command
alias memo-cmake='printf "mkdir build\ncd build/\ncmake ..\ncmake --build . --config Release\n./Release/main.exe\n\ncmake --build . --target clean\n"'

# Go to worspaces
alias workspace-apache='cd /var/www/'
alias workspace-qt='cd /home/charlie/Documents/workspaces/workspace-qt'
alias workspace-vscode='cd /home/charlie/Documents/workspaces/workspace-vscode'

# Go to AppImage folder
alias workspace-appimage='cd /home/charlie/Téléchargements/app-image'

# Copy VsCode snippets to documentation folder
alias snippet-c-export='cp ~/.config/Code/User/snippets/c.json ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/IDE/VsCode/ressources/c.json && printf "Done !\n"'
alias snippet-c-import='cp ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/IDE/VsCode/ressources/c.json ~/.config/Code/User/snippets/c.json && printf "Done !\n"'
alias snippet-c-edit='code ~/.config/Code/User/snippets/c.json'
alias snippet-cpp-export='cp ~/.config/Code/User/snippets/cpp.json ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/IDE/VsCode/ressources/cpp.json && printf "Done !\n"'
alias snippet-cpp-import='cp ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/IDE/VsCode/ressources/cpp.json ~/.config/Code/User/snippets/cpp.json && printf "Done !\n"'
alias snippet-cpp-edit='code ~/.config/Code/User/snippets/cpp.json'
alias snippet-sh-export='cp ~/.config/Code/User/snippets/shellscript.json ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/IDE/VsCode/ressources/shellscript.json && printf "Done !\n"'
alias snippet-sh-import='cp ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/IDE/VsCode/ressources/shellscript.json ~/.config/Code/User/snippets/shellscript.json && printf "Done !\n"'
alias snippet-sh-edit='code ~/.config/Code/User/snippets/shellscript.json'

# Used as a memo to load library into env variables
alias memo-lib-ld='printf "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../../helper_tools/bin:../../custom_error/bin:../bin\n"'
# Memo used to remember how to convert PNG image to RAW framebuffer format
alias memo-png-to-fb='printf "1. PNG to FB\nfbv -0 ./my-picture.png  > /dev/null 2>&1\ndd if=/dev/fb0 of=my-picture.fb\n\n2. FB to PNG\ndd if=my-picture.fb of=/dev/fb0\ndd if=my-picture.fb of=/dev/fb0 bs=32768 count=1\n"'
# Memo used to remain how to remove last line of a file
alias memo-remove-last-line='printf "sed -i \"$ d\" file.txt\n"'
# Use to save custom bash aliases do documentation folder
alias bash-aliases-update-doc='save-custom-bash-aliases ~/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/Linux/linux/custom_bash_aliases.md && printf "Done !\n"'

# Use to manage "bash_aliases" file
alias bash-aliases-edit-vi='vi ~/.bash_aliases'
alias bash-aliases-edit-vscode='code ~/.bash_aliases'
alias bash-aliases-reload='source ~/.bash_aliases && printf "Done !\n"'

# Use to manage environment file
alias env-edit-vi='sudo vi /etc/environment'

# Create alias for gitui program, which doesn't yet have a proper system installation, so we use binaries (https://github.com/extrawurst/gitui)
alias gituibin='~/Téléchargements/Fichiers\ Setup/gitui-linux-musl/gitui'

# Create alias for application used to create an AppImage, which are released under binaries
alias linuxdeploy.AppImage='~/Téléchargements/apps/linuxdeploy/linuxdeploy-x86_64.AppImage'
alias appimagetool.AppImage='~/Téléchargements/apps/appimagekit/appimagetool-x86_64.AppImage'

# Create alias to python tools
alias py-b4='~/.local/bin/b4'

# Create aliases used to generate documentation of multiple projects
alias doc-cobra-libs='generate-project-documentation /home/charlie/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/03-libs Doxyfile'
alias doc-cobra-apps='generate-project-documentation /home/charlie/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/04-apps Doxyfile'
alias doc-rpcompute='generate-project-documentation /home/charlie/Documents/workspaces/workspace-qt/Cobra-AppCommunication/RP_Lib/deps/RP_Compute Doxyfile'
alias doc-rplib='generate-project-documentation /home/charlie/Documents/workspaces/workspace-qt/Cobra-AppCommunication/RP_Lib Doxyfile'
alias doc-benchmanager-lib='generate-project-documentation /home/charlie/Documents/workspaces/workspace-qt/BancCalibration-application/BancCalibration-library Doxyfile'
alias doc-benchmanager-arduino='generate-project-documentation /home/charlie/Documents/workspaces/workspace-vscode/BancCalibration-arduino Doxyfile'

##
# Applications build ourself
#
# Yavta : https://git.ideasonboard.org/yavta.git
# Raw2RgbPnm : https://git.retiisi.org.uk/?p=~sailus/raw2rgbpnm.git
##
alias custom-yavta='/home/charlie/Documents/workspaces/workspace-vscode/yavta/yavta'
alias custom-raw2rgbpnm='/home/charlie/Documents/workspaces/workspace-vscode/raw2rgbpnm/raw2rgbpnm'

alias memo-yavta='printf "raw10: yavta -f SGRBG16 -s 648x648 -c8 -F/tmp/frame-#.bin /dev/video0\nraw8: yavta -f SGRBG8 -s 640x640 -c8 -F/tmp/frame-#.bin /dev/video0\nyuyv: yavta -f YUYV -s 640x640 -c8 -F/tmp/frame-#.bin /dev/video0\n"'
alias memo-raw2rgbpnm='printf "raw10: raw2rgbpnm -s 648x648 -f SGRBG10 frame-000000.bin frame-000000.ppm\nraw8: raw2rgbpnm -s 640x640 -f SGRBG8 frame-000000.bin frame-000000.ppm\nyuyv: raw2rgbpnm -s 640x640 -f YUYV frame-000000.bin frame-000000.ppm\n"'

##
# Pi specific aliases
##
alias pi-ssh='ssh pi@raspberrypi'

##
# Arduino specific aliases
##
alias arduino-uart='sudo minicom -w -D /dev/ttyACM0 -b 115200'

##
# Cobra specific aliases
##

# Launch minicom session of Cobra (via UART)
alias cobra-uart='sudo minicom -w -D /dev/ttyUSB0 -b 115200'

# Launch SSH session of Cobra
alias cobra-ssh-root='ssh root@172.27.77.5'

# Generate new ssh key with Cobra device
alias cobra-keygen='ssh-keygen -f "/home/charlie/.ssh/known_hosts" -R "172.27.77.5"'

# To setup Cobra dev environment
alias cobra-setup='~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/07-host/setup-workstation.sh'

# Go to Cobra workspace
alias cobra-libs='cd ~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/03-libs'
alias cobra-apps='cd ~/Documents/workspaces/workspace-cobra/Cobra-applicationLayer/06-app_layer/04-apps'
alias cobra-build='cd ~/Documents/workspaces/workspace-cobra/Cobra-BuildTarget-Buildroot/RAYPLICKER-V2/'
alias cobra-bsp='cd ~/Documents/workspaces/workspace-cobra/bsp/'
alias cobra-kernels='cd ~/Documents/workspaces/workspace-cobra/kernels/'
alias cobra-releases='cd ~/Documents/workspaces/workspace-cobra/cobra-releases/'

# Display streaming send by Cobra device (use Intel Graphics Card instead of NVidia)
alias cobra-gst-get-stream='LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! queue ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink'

# Cobra firmware management
## Localhost
alias cobra-fw-localhost-index-update='cp /home/charlie/Documents/workspaces/workspace-qt/Cobra-AppCommunication/RP_CobraApplication/configurations/examples/server-localhost-cobra-fw-list.json /var/www/html/cobra-firmware/'
alias cobra-fw-localhost-add='copy-cobra-fw-release-to-localhost /var/www/html/cobra-firmware/cobra-fw-list/'
```
