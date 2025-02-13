# Custom bash aliases

> [!NOTE]
> See [bash aliases documentation](https://github.com/legerch/develop-memo/blob/master/Operating%20System/Linux/Common/linux-terminal.md) for more details

Saved from : Ubuntu 22.04.5 LTS - Kernel 6.8.0-52-generic - 13/02/2025 :

```shell
##########################
# Host specific functions
#       Terminal
##########################

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

##########################
# Host specific functions
#      Updates
##########################

# Function used to update host firmwares
function update-host-fw()
{
    local doUpdateFw=0

    # Refresh list of host devices
    fwupdmgr refresh

    # Check available firmware updates
    fwupdmgr get-updates

    # Ask user before proceed to FW update
    doUpdateFw=$(_user-answer-is-yes "Do you want to update host firmware")
    if [ ${doUpdateFw} -eq 1 ]; then
        printf "Host firmware will be updated...\n"
        fwupdmgr update
    else
        printf "No firmware update have been performed\n"
    fi
}

##########################
# Host specific functions
#      Bash aliases
##########################

# Function used to create a copy of a bash aliases file into a markdown file :
## ${1}: Bash aliases file to use
## ${2}: Markdown output file  
function save-custom-bash-aliases()
{
    # Verify argument validity
    local fileSrc="${1}"
    local fileDest="${2}"

    if [[ ! -f "${1}" || -z "${2}" ]]; then
        printf "USAGE: save-custom-bash-aliases <alias_input> <markdown_output>\n"
        return 1
    fi

    local infoUnameKernel=$( uname -r )
    local infoOsRelease=$( grep -oP '(?<=^PRETTY_NAME=).+' /etc/os-release | tr -d '"' )
    local infoDate=$( date +%d/%m/%Y )

    # Delete content
    > "${fileDest}"

    # Write into file
    ## Context informations
    printf "# Custom bash aliases\n\n" >> "${fileDest}"
    printf "> [!NOTE]\n" >> "${fileDest}"
    printf "%s\n\n" "> See [bash aliases documentation](https://github.com/legerch/develop-memo/blob/master/Operating%20System/Linux/Common/linux-terminal.md) for more details" >> "${fileDest}"
    printf "Saved from : ${infoOsRelease} - Kernel ${infoUnameKernel} - ${infoDate} :\n\n" >> "${fileDest}"

    ## Bash aliases script
    printf "\`\`\`shell\n" >> "${fileDest}"
    printf "%s\n" "$(<${fileSrc})" >> "${fileDest}"
    printf "\`\`\`\n" >> "${fileDest}"

    printf "Exporting ${fileSrc} to ${fileDest} done !\n"
}

function alias-print()
{
    local aliasContent=$(alias "${1}" 2>/dev/null)
    if [ -z "${aliasContent}" ]; then
        printf "USAGE : alias-print <alias>\n"
        return 1
    fi

    printf "${aliasContent}\n"
}

alias alias-list='alias'

function alias-search()
{
    if [ -z "${1}" ]; then
        echo "Usage: alias-search <search_alias>"
        return 1
    fi

    alias | grep -i "${1}"
}

##########################
# Host specific functions
#      Helpers
##########################

# Function used to generate doxygen documentation :
# ${1} : path to root project
# ${2} : Doxyfile name to use
# ${3} : Set to 1 to use custom doxygen path (optional, if not set, installed Doxygen will be used)
function generate-project-documentation()
{
    local docPath="${1}"
    local docFile="${2}"
    local docUseCustomBin="${3}"

    local docDoxygen="${docPath}/${docFile}"

    # Check that project doc file is valid
    if [ ! -f "${docDoxygen}" ]; then
        printf "USAGE: generate-project-documentation <project_path> <doxygen_file> <use_custom_doxygen_bin>\n"
        return 1
    fi

    # Set doxygen binary to use
    local binDoxygen="doxygen"  # Default to global
    if [ "${docUseCustomBin}" == "1" ]; then
        binDoxygen="${_BIN_DOXYGEN_CUSTOM}"
    fi

    # Go to project directory
    cd ${docPath}

    # Generate documentation
    ${binDoxygen} "${docFile}"

    # Return to previous directory
    cd ${OLDPWD}
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

    doRenaming=$(_user-answer-is-yes "Proceed")
    if [ ${doRenaming} -eq 1 ]; then
        file-rename "s/.${oldExt}/.${newExt}/" *".${oldExt}"
        printf "Done. \n"
    else
        printf "Operation canceled. \n"
    fi
}

# Use to read a QrCode from image
# It will try to display raw content
# Online alternative could be:
# https://www.onlinebarcodereader.com/
#
# ${1}: Path to img, if not exist, help is printed
function qrcode-read-from-img()
{
    if ! _check-tools zbarimg; then return 1; fi

    # Verify file validity
    if [ ! -f "${1}" ]; then
        printf "USAGE: qrcode-read-from-img <img-path>\n"
        return 1
    fi

    # Display QrCode content
    zbarimg --raw "${1}"
}

function html-add-stylesheet()
{
    local originFile="${1}"
    local titleFile="${2}"

    # Verify file validity
    if [ ! -f "${originFile}" ]; then
        printf "USAGE : html-add-stylesheet <html-file> <title-file>\n"
        return 1
    fi

    # Verify title validity
    if [ -z "${titleFile}" ]; then
        printf "USAGE : html-add-stylesheet <html-file> <title-file>\n"
        return 1
    fi
    
    local tmpFile="${originFile}.tmp"

    # Format headers (using "heredoc" feature, don't quote EOF to keep variable expansion feature)
    local headers=$(cat <<EOF
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${titleFile}</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/5.6.1/github-markdown-dark.min.css" integrity="sha512-mzPe5Bxap921sKCNI3lXEi5FxCue4M1Ei65ZVFi1UdCMnr4+BFOpBuWnfpJ8WLBxvyhf7z45Jsa5jWiseE57rg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <style>
            .markdown-body {
                box-sizing: border-box;
                min-width: 200px;
                max-width: 980px;
                margin: 0 auto;
                padding: 45px;
            }
        
            @media (max-width: 767px) {
                .markdown-body {
                    padding: 15px;
                }
            }
        </style>

    </head>
    <body class="markdown-body">

EOF
    )

    # Format end of file
    local endfile=$(cat <<EOF
    </body>
    </html>

EOF
    )

    # Create temporary file
    printf "${headers}" > "${tmpFile}"
    cat "${originFile}" >> "${tmpFile}"
    printf "${endfile}" >> "${tmpFile}"

    # Replace original file
    mv "${tmpFile}" "${originFile}"
    printf "Stylesheet added to ${originFile}\n"
}

# Function used to download tarball from github repositories
function repo-github-dl-tarball()
{
    local owner="${1}"
    local repo="${2}"
    local version="${3}"

    local doDlTarball=0

    # Check than mandatory tools are available to download tarball
    if ! _check-tools curl; then return 1; fi

    # Ask user before proceed to download
    local url="https://github.com/${owner}/${repo}/archive/${version}.tar.gz"
    printf "Tarball URL is: ${url}\n\n"

    printf "Expected format is: repo-github-dl-tarball <owner> <repo> <version_or_sha1>\n"
    doDlTarball=$(_user-answer-is-yes "Proceed")

    # Perform download in current directory
    if [ ${doDlTarball} -eq 1 ]; then
        curl -L ${url} -o "${repo}-${version}.tar.gz"
    else
        printf "No file has been downloaded\n"
    fi
}

##########################
# Host specific functions
#     Wlan related
##########################

# Function used to generate wifi QrCode
# Note 1 : "qrencode" package must be available (used to generate QrCode).
# Note 2 : Bash 4 minimum is needed (used to easily manage lower/upper case)
#
# Wifi QrCode format :
# - https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11
# - https://feeding.cloud.geek.nz/posts/encoding-wifi-access-point-passwords-qr-code/
# - https://pocketables.com/2022/01/how-to-format-that-wifi-qr-code-in-plain-text.html
# - https://thelinuxexperiment.com/share-your-wifi-info-via-qr-code/comment-page-1/
#
function wifi-qrcode-generate()
{
    local argSsid="${1}"
    local argSecurity="${2^^}"
    local argPasswd="${3}"
    
    local security=""

    # Verify that needed tools are installed
    if ! _check-tools qrencode; then return 1; fi

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
function wifi-display-ssid-infos-custom()
{
    local ssid="${1}"
    if [ -z "${ssid}" ]; then
        printf "USAGE : wifi-display-ssid-infos-custom <ssid>\n"
        return 1
    fi

    local ssidInfos="/etc/NetworkManager/system-connections/${ssid}.nmconnection"
    if [ -f "${ssidInfos}" ]; then            
        local security="$(sudo cat ${ssidInfos} | grep "key-mgmt=" | cut -d "=" -f 2)"
        local passwd="$(sudo cat ${ssidInfos} | grep "psk=" | cut -d "=" -f 2)"
        
        printf "\nSSID: ${ssid}\nSecurity: ${security}\nPassword: ${passwd}\n"
        wifi-qrcode-generate "${ssid}" "${security}" "${passwd}"

    else
        printf "Cannot retrieve passwd, ssid [${ssid}] is unknown\n"
    fi
}

##########################
# Host specific functions
#     Perf related
##########################

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
    
    doSetPerfLevel=$(_user-answer-is-yes "Proceed")
    if [ ${doSetPerfLevel} -eq 1 ]; then
        sudo sysctl kernel.perf_event_paranoid="${level}"
        printf "Done. \n"
    else
        printf "Operation canceled. \n"
    fi
}

##########################
# Host specific functions
#     Inotify related
##########################
function inotify-cfg-get
{
    sysctl fs.inotify
    _sysctl-validate-properties "fs.inotify.<field>"
}

##########################
# Scripts constants vars
##########################

_DIR_DL="${HOME}/Téléchargements/"
_DIR_PACKAGES_STANDALONE="${_DIR_DL}/standalone-packages/"
_DIR_PACKAGES_DEBIAN="${_DIR_DL}/debian-packages/"
_DIR_WORKSPACES="${HOME}/Documents/workspaces/"
_DIR_VSCODE_SNIPPETS="${HOME}/.config/Code/User/snippets/"
_DIR_REPO_DEV_MEMO="${HOME}/Documents/workspaces/workspace-cobra/Cobra-documentation/Documentations/develop-memo/"
_DIR_TIO_CFG="${HOME}/.config/tio/"

_FILE_BASH_ALIASES="${HOME}/.bash_aliases"
_FILE_BASH_ALIASES_COMPANY="${HOME}/.bash_aliases_company"

_FILE_TIO_CFG="${_DIR_TIO_CFG}/config"

_BIN_DOXYGEN_CUSTOM="${_DIR_PACKAGES_STANDALONE}/doxygen/doxygen-1.12.0/bin/doxygen"

##########################
# Scripts functions
#   Helpers
##########################

function _user-answer-is-yes()
{
    local isYes=0

    read -p "${1} (y/N) ? " answer
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

function _verify-min-bash-version()
{
    local targetVersion="${1}"
    local currentVersion="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}.${BASH_VERSINFO[2]}"
    local isValid=0

    if [[ "${currentVersion}" > "${targetVersion}" || "${currentVersion}" == "${targetVersion}" ]]; then
        isValid=1
    fi

    echo "${isValid}"
}

# Function used to verify that needed tools is installed
## Arg1: Tools name (example: curl)
## Usage: if ! _check-tools curl; then return 1; fi
function _check-tools()
{
    which "${1}" &> /dev/null
    local toolStatus=$?
    if [ ${toolStatus} -ne 0 ]; then
        
        local displayMess=${2:-1}   # Use variable ${2} if set, otherwise use default value "1"
        if [ ${displayMess} -eq 1 ]; then
            printf "You need \"${1}\" tool. Please install it first before continuing\n"
        fi
        return 1
    fi
}

function _sysctl-validate-properties()
{
    printf "\nTo edit sysctl properties permanently, edit file \"/etc/sysctl.conf\". Example:\n"
    printf "${1}=your_value\n\n"

    printf "Once file modified, we can apply those changes either by rebooting device or by running command: \"sysctl -p\"\n"
}

##########################
# Scripts functions
#   Repositories
##########################

# Function use to retrieve latest tag of a github project
## Arg1: Repo owner
## Arg2: Project name
function _repo-github-retrieve-latest-release-infos()
{
    # Check tools
    if ! _check-tools curl; then return 1; fi
    if ! _check-tools jq; then return 1; fi

    # Retrieve infos
    m_fileReleaseInfo="/tmp/info-latest-rel-${1}-${2}.json"
    curl -SsL "https://api.github.com/repos/${1}/${2}/releases/latest" -o "${m_fileReleaseInfo}"
    
    # Retrieve last tag"
    local latestTag=$(jq -r '.tag_name' ${m_fileReleaseInfo})
    printf "Latest available version is: ${latestTag}\n"
}

##########################
# Scripts functions
#   Arduino
##########################

# Function used to retrieve all arduino-cli informations to proceed to update
## Arg1: Path to JSON release informations
function _arduino-cli-binary-install()
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

    # Search URL of binary
    local url=$(jq -r --arg arch "Linux_${hostArch}" '.assets[] | select(.name | contains($arch)) | .browser_download_url' "${1}")
    local name=$(basename "${url}")
    local version=$(jq -r '.tag_name' "${1}")

    # Download binary
    local tmpFile="/tmp/${name}"
    
    printf "Download ${url} to ${tmpFile}...\n"
    curl -sL "${url}" -o "${tmpFile}"
    if [ $? -ne 0 ]; then
        printf "Failed to download file!\n"
        return 1;
    fi

    # Extract files
    local dirExtract="/tmp/arduino-cli-binaries"

    printf "Extract ${tmpFile} into ${dirExtract}...\n"
    mkdir -p "${dirExtract}"
    tar -xf "${tmpFile}" -C "${dirExtract}"
    if [ $? -ne 0 ]; then
        printf "Failed to extract binaries!\n"
        return 1;
    fi

    # Install arduino client
    local binName="arduino-cli"
    local binFileIn="${dirExtract}/${binName}"
    local binFileOut="/usr/local/bin/${binName}"

    printf "Install \"${binFileIn}\" at \"${binFileOut}\"\n"
    sudo cp "${binFileIn}" "${binFileOut}"
    sudo chmod +x "${binFileOut}"

    printf "${binName} ${version} have been installed to ${binFileOut}\n"
}

# Function used to update arduino-cli binary
function _arduino-cli-binary-update()
{
    local doUpdateArduinoCli=0

    # Check current version
    if _check-tools arduino-cli 0; then
        arduino-cli version
    fi
    _repo-github-retrieve-latest-release-infos "arduino" "arduino-cli"

    # Ask user before proceed to FW update
    doUpdateArduinoCli=$(_user-answer-is-yes "Do you want to update arduino-cli binary")
    if [ ${doUpdateArduinoCli} -eq 1 ]; then
        printf "arduino-cli will be updated...\n"
        _arduino-cli-binary-install "${m_fileReleaseInfo}"

    else
        printf "No arduino-cli binary update have been performed\n"
    fi
}

##########################
# Scripts functions
# LAMP (Linux, Apache, MySQL,PHP)
##########################

# Function used to set LAMP properties
function _lamp-set-properties()
{
    local cmd="${1}"
    local message="${2}"

    sudo systemctl "${cmd}" apache2 && sudo systemctl "${cmd}" mysql && printf "${message}\n"
}

##########################
# Host specific aliases
##########################

# To perform host updates
alias maj-apt='sudo apt update && sudo apt full-upgrade'
alias maj-snap='sudo snap refresh'
alias maj-flatpak='flatpak update'
alias maj-firmware='update-host-fw'
alias maj-arduino-cli-bin='_arduino-cli-binary-update'

# To uninstall a package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/151941/how-can-you-completely-remove-a-package)
alias apt-uninstall="sudo apt purge --autoremove"
alias apt-list-installed="apt list --installed"
# To uninstall a snap package and all dependencies not used elsewhere (source : https://askubuntu.com/questions/1130791/how-to-uninstall-a-package-installed-from-snapcraft)
alias snap-list-revs="snap list --all"
alias snap-package-info="snap info"
alias snap-package-revert="sudo snap revert"
alias snap-package-update="sudo snap refresh"
alias snap-package-uninstall="sudo snap remove --purge"
# To uninstall a flatpak package and all dependencies not used elsewhere (source: https://docs.flathub.org/docs/for-users/uninstallation/)
alias flatpak-list="flatpak list"
alias flatpak-uninstall="flatpak uninstall --delete-data"
alias flatpak-clean="flatpak uninstall --unused"

# PPA related commands for easier install/uninstall
# Blog helper: https://blog.desdelinux.net/fr/ppa-purge-como-remover-un-repositorio-ppa-en-forma-segura/
alias ppa-repo-add="sudo add-apt-repository"
alias ppa-repo-remove="sudo ppa-purge" # Use "ppa-purge" command instead of "add-apt-repository --remove" in order to perform a real clean
alias ppa-repo-list="ls -l /etc/apt/sources.list.d/"

# In order to "disallow" some commands (It is use for my embedded target and I don't want to perform them on my host machine)
alias poweroff='printf "I m not gonna do that !\n"'
alias reboot='printf "I m not gonna do that !\n"'

# Aliases used for LAMP (Linux, Apache, MySQL,PHP) management
alias lamp-autostart-enable='_lamp-set-properties "enable" "LAMP auto-start enabled !"'
alias lamp-autostart-disable='_lamp-set-properties "disable" "LAMP auto-start disabled !"'
alias lamp-start='_lamp-set-properties "start" "LAMP started !"'
alias lamp-stop='_lamp-set-properties "stop" "LAMP stopped !"'
alias lamp-restart='_lamp-set-properties "restart" "LAMP restarted !"'

# Aliases used for password network properties
alias wifi-display-ssid-infos-current='nmcli device wifi show-password'
alias wifi-display-ssid-infos-specific='wifi-display-ssid-infos-custom'

# Aliases used to scan available networks
alias wifi-scan-basic='nmcli dev wifi'
alias wifi-scan-details='nmcli -m multiline -f ALL dev wifi'
alias wifi-scan-raw-iw='sudo iw dev <interface> scan'

# Get 'sync' command status
alias sync-status='watch -d grep -e Dirty: -e Writeback: /proc/meminfo'

# Valgrind commands
## Useful links:
## - https://developers.redhat.com/articles/2025/01/22/monitor-gcc-compile-time
## - https://snapcraft.io/kcachegrind (utility used to read file generated by callgrind)
alias vg-callgrind='valgrind --tool=callgrind'
alias vg-helgrind='valgrind --tool=helgrind'
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --track-fds=yes'

# CMake command
alias memo-cmake='printf "mkdir build\ncd build/\ncmake ..\ncmake --build . --config Release\n./Release/main.exe\n\ncmake --build . --target clean\n"'

# Go to workspaces
alias workspace-apache='cd /var/www/'
alias workspace-qt='cd ${_DIR_WORKSPACES}/workspace-qt'
alias workspace-vscode='cd ${_DIR_WORKSPACES}/workspace-vscode'

# Go to AppImage folder
alias workspace-appimage='cd ${_DIR_DL}/app-image'

# Create alias for application used to create an AppImage, which are released under binaries
alias linuxdeploy.AppImage='${_DIR_DL}/apps/linuxdeploy/linuxdeploy-x86_64.AppImage'
alias appimagetool.AppImage='${_DIR_DL}/apps/appimagekit/appimagetool-x86_64.AppImage'

# Copy VsCode snippets to documentation folder
alias snippet-c-export='cp ${_DIR_VSCODE_SNIPPETS}/c.json ${_DIR_REPO_DEV_MEMO}/IDE/VsCode/ressources/c.json && printf "Done !\n"'
alias snippet-c-import='cp ${_DIR_REPO_DEV_MEMO}/IDE/VsCode/ressources/c.json ${_DIR_VSCODE_SNIPPETS}/c.json && printf "Done !\n"'
alias snippet-c-edit='code ${_DIR_VSCODE_SNIPPETS}/c.json'
alias snippet-cpp-export='cp ${_DIR_VSCODE_SNIPPETS}/cpp.json ${_DIR_REPO_DEV_MEMO}/IDE/VsCode/ressources/cpp.json && printf "Done !\n"'
alias snippet-cpp-import='cp ${_DIR_REPO_DEV_MEMO}/IDE/VsCode/ressources/cpp.json ${_DIR_VSCODE_SNIPPETS}/cpp.json && printf "Done !\n"'
alias snippet-cpp-edit='code ${_DIR_VSCODE_SNIPPETS}/cpp.json'
alias snippet-sh-export='cp ${_DIR_VSCODE_SNIPPETS}/shellscript.json ${_DIR_REPO_DEV_MEMO}/IDE/VsCode/ressources/shellscript.json && printf "Done !\n"'
alias snippet-sh-import='cp ${_DIR_REPO_DEV_MEMO}/IDE/VsCode/ressources/shellscript.json ${_DIR_VSCODE_SNIPPETS}/shellscript.json && printf "Done !\n"'
alias snippet-sh-edit='code ${_DIR_VSCODE_SNIPPETS}/shellscript.json'

# Used as a memo to load library into env variables
alias memo-lib-ld='printf "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../../helper_tools/bin:../../custom_error/bin:../bin\n"'
# Memo used to remember how to convert PNG image to RAW framebuffer format
alias memo-png-to-fb='printf "1. PNG to FB\nfbv -0 ./my-picture.png  > /dev/null 2>&1\ndd if=/dev/fb0 of=my-picture.fb\n\n2. FB to PNG\ndd if=my-picture.fb of=/dev/fb0\ndd if=my-picture.fb of=/dev/fb0 bs=32768 count=1\n"'
# Memo used to remain how to remove last line of a file
alias memo-remove-last-line='printf "sed -i \"$ d\" file.txt\n"'

# Use to manage "bash_aliases" file
alias bash-aliases-edit-vi='vi ${_FILE_BASH_ALIASES}'
alias bash-aliases-edit-vscode='code ${_FILE_BASH_ALIASES}'
alias bash-aliases-reload='source ${_FILE_BASH_ALIASES} && printf "Done !\n"'
alias bash-aliases-update-doc='save-custom-bash-aliases ${_FILE_BASH_ALIASES} "${_DIR_REPO_DEV_MEMO}/Operating System/Linux/Common/custom_bash_aliases.md"'

# Use to manage environment file
alias env-edit-vi='sudo vi /etc/environment'
alias syscfg-edit-vi='sudo vi /etc/sysctl.conf && memo-syscfg'
alias memo-syscfg='_sysctl-validate-properties "range.field.property"'

# Use to manage TIO related files
alias tio-edit='code -n ${_DIR_TIO_CFG}'
alias tio-edit-cfg-file='code ${_FILE_TIO_CFG}'

# Create alias to python tools
alias py-b4='${HOME}/.local/bin/b4'

##
# Applications build ourself
#
# Yavta : https://git.ideasonboard.org/yavta.git
# Raw2RgbPnm : https://git.retiisi.org.uk/?p=~sailus/raw2rgbpnm.git
##
alias custom-yavta='${_DIR_WORKSPACES}/workspace-vscode/yavta/yavta'
alias custom-raw2rgbpnm='${_DIR_WORKSPACES}/workspace-vscode/raw2rgbpnm/raw2rgbpnm'

alias memo-yavta='printf "raw10: yavta -f SGRBG16 -s 648x648 -c8 -F/tmp/frame-#.bin /dev/video0\nraw8: yavta -f SGRBG8 -s 640x640 -c8 -F/tmp/frame-#.bin /dev/video0\nyuyv: yavta -f YUYV -s 640x640 -c8 -F/tmp/frame-#.bin /dev/video0\n"'
alias memo-raw2rgbpnm='printf "raw10: raw2rgbpnm -s 648x648 -f SGRBG10 frame-000000.bin frame-000000.ppm\nraw8: raw2rgbpnm -s 640x640 -f SGRBG8 frame-000000.bin frame-000000.ppm\nyuyv: raw2rgbpnm -s 640x640 -f YUYV frame-000000.bin frame-000000.ppm\n"'

alias custom-qt-creator-13.0.2='${_DIR_PACKAGES_STANDALONE}/qtcreator-13.0.2/bin/qtcreator'
alias custom-caesium='${_DIR_PACKAGES_STANDALONE}/caesium/Caesium_Image_Compressor-x86_64_v2.6.0_ubu20_qt66.AppImage'
alias custom-doxygen='${_BIN_DOXYGEN_CUSTOM}'

##
# Pi specific aliases
##
alias pi-ssh='ssh pi@raspberrypi'

##
# Arduino specific aliases
##
alias arduino-uart='sudo minicom -w -D /dev/ttyACM0 -b 115200'

# Custom fixes
## Dual boot time issues: linux use RTC time but Windows OS use local time (more details at: https://itsfoss.com/wrong-time-dual-boot/)
## So we can set Linux to use local time: see the specified alias
## Or fix the problem on Windows (via registry key): https://ubuntuhandbook.org/index.php/2021/06/incorrect-time-windows-11-dual-boot-ubuntu/amp/
## Since Windows is not really "aware" that he is not alone on the market, some apps may still consider that bios time is in UTC and not in local, so I prefer to "fix" it linux side
alias fix-dual-boot-time="timedatectl set-local-rtc 1 && timedatectl"

##
# Alias definitions related to company
##
if [ -f ${HOME}/.bash_aliases_company ]; then
    . ${HOME}/.bash_aliases_company
fi
```
