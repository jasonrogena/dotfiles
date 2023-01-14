## Settings
export EDITOR=vim
# No limit to the size of the history file
HISTFILESIZE=-1
# In-memory history limit
HISTSIZE=1000000
# Ignore duplicate consecutive commands
HISTCONTROL=ignoredups
export PATH=$PATH:$HOME/.local/bin
. "$HOME/.cargo/env"
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

## Shell-specific general
### zsh
if [[ "$SHELL" == "/bin/zsh" ]]; then
  # Enable reverse history search
  bindkey -v
  bindkey '^R' history-incremental-search-backward

  # Enable firing up an editor to write multi-line commands
  autoload edit-command-line
  zle -N edit-command-line
  bindkey '^X^E' edit-command-line
fi

## Functions
adb_wifi() {
        adb devices
    echo "Enter the serial number for the device you want to switch to WiFi"

    read serialNo

    ipAddr=`adb -s ${serialNo} shell ifconfig wlan0 | sed -n 's/inet addr:\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*/\1/p'`
    if [ -z "${ipAddr}" ]; then
        ipAddr=`adb -s ${serialNo} shell netcfg | sed -n 's/wlan0[ ]*UP[ ]*\([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*\).*/\1/p'`
    fi

    if ! [ -z "${ipAddr}" ]; then
        echo "IP Addres is "${ipAddr}
        adb -s ${serialNo} tcpip 5555
        adb connect ${ipAddr}:5555
                echo "adb connect ${ipAddr}:5555" > ~/.adb_connect_history
    else
        echo "Could not connect to the device on WiFi. Check the connection"
    fi
}

# Obtained from https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/
# example: smartresize inputfile.png 1000 outputdir/
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}
