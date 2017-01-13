export PATH=/opt/pkg/sbin:/opt/pkg/bin:~/Library/Android/sdk/platform-tools:~/Library/Android/sdk/tools:$PATH
export MANPATH=/opt/pkg/man:$MANPATH
export CLICOLOR=1
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
    echo "IP Addres is "${ipAddr}
    adb -s ${serialNo} tcpip 5555
    adb connect ${ipAddr}:5555
}
