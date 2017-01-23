export PATH=/opt/pkg/sbin:/opt/pkg/bin:~/Library/Android/sdk/platform-tools:~/Library/Android/sdk/tools:$PATH
export MANPATH=/opt/pkg/man:$MANPATH
export CLICOLOR=1
export ONA_GIT_COMMITER_INITIALS="JR"
[ -r ~/.bashrc ] && source ~/.bashrc

#Git Branch Label
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

#Start GPG Agent Daemon
[ -f ~/.gnupg/gpg-agent-info ] && source ~/.gnupg/gpg-agent-info
if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
    export GPG_AGENT_INFO
else
    eval $( gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf --write-env-file ~/.gnupg/gpg-agent-info )
fi

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
