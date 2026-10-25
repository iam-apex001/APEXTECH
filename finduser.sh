#!/bin/bash
pkill -9 apt
pkill -9 apt-get
rm -f finduserlog_bc.txt
rm -f finduserlog_curl.txt
rm -f finduserlog_tput.txt
rm -f finduserlog_upgrade.txt
clear

red="\e[1;31m"
green="\e[1;32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
nc="\e[0m"
redbg="\e[41m"
greenbg="\e[42m"

#upgrade packages
#echo -e "${magenta}[*] upgrading packages... (result in finduserlog_upgrade.txt)"
#if apt upgrade -y > finduserlog_upgrade.txt 2>&1; then
#    echo -e "${green}[*]=> pkg upgrade successfully${nc}"
#else
#    echo -e "${red}[*]=> pkg upgrade failed${nc}"
#fi

#install tput 
echo -e "${magenta}[*] installing tput... (result in finduserlog_tput.txt)"
if apt-get install -y ncurses-utils > finduserlog_tput.txt 2>&1; then
    echo -e "${green}[*]=> tput installed successfully${nc}"
else
    echo -e "${red}[*]=> tput installation failed${nc}"
fi

#install curl
echo -e "${magenta}[*] installing curl... (result in finduserlog_curl.txt)"
if apt-get install -y curl > finduserlog_curl.txt 2>&1; then
    echo -e "${green}[*]=> curl installed successfully${nc}"
else
    echo -e "${red}[*]=> curl installation failed${nc}"
fi

center() {
    local text="$1"
    local width=$(tput cols 2>/dev/null)
    [ -z "$width" ] && width=80
    local text_len=${#text}
    local pad=$(( (width - text_len) / 2 ))
    [ "$pad" -lt 0 ] && pad=0
    printf "%${pad}s%s%$(( width - text_len - pad > 0 ? width - text_len - pad : 0 ))s\n" "" "$text" ""
}

echo -e "${green}"
center "▄▀█ █▀█ █▀▀ ▀▄▀   ▀█▀ █▀▀ █▀▀ █░█"
center "█▀█ █▀░ ██▄ ▄▀▄   ░█░ ██▄ █▄▄ █▀█"
echo -e "${nc}"
echo -e "${cyan}"
center "[*] Program type : Username Checker"
echo -e "${nc}"

echo -e "${red}"
read -p "[*].Enter username : " UN
echo -e "${nc}"


if [ -z "$UN" ]; then
    echo -e "${red}[*] No username entered, exiting.${nc}"
    exit 1
fi

urls=(
    "https://github.com/$UN"
    "https://x.com/$UN"
    "https://www.instagram.com/$UN/"
    "https://www.tiktok.com/@$UN"
    "https://www.reddit.com/user/$UN/"
    "https://www.youtube.com/@$UN"
    "https://www.twitch.tv/$UN"
    "https://www.pinterest.com/$UN"
    "https://t.me/$UN"
    "https://medium.com/@$UN"
    "https://www.linkedin.com/in/$UN"
    "https://gitlab.com/$UN"
    "https://codepen.io/$UN"
    "https://dev.to/$UN"
    "https://huggingface.co/$UN"
    "https://steamcommunity.com/id/$UN"
    "https://soundcloud.com/$UN"
    "https://www.behance.net/$UN"
    "https://dribbble.com/$UN"
    "https://www.facebook.com/$UN"
)

echo -e "${green}"
width=$(tput cols 2>/dev/null)
[ -z "$width" ] && width=80
line_width=$(( width * 90 / 100 ))
line=$(printf '%.0s_' $(seq 1 $line_width))
center "$line"
echo ""
center "Retrieved Information :"
echo ""
for url in "${urls[@]}"; do
    code=$(curl -L -s -o /dev/null -w "%{http_code}" \
        --max-time 10 \
        -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
        "$url")

    if [ "$code" -eq 200 ]; then
        echo -e "[*]-> ${green}[FOUND]${nc} $url"
    elif [ "$code" -eq 403 ]; then
        echo -e "[*]-> ${yellow}[BLOCKED]${nc} $url"
    elif [ "$code" -eq 429 ]; then
        echo -e "[*]-> ${yellow}[RATE LIMITED]${nc} $url"
    elif [ "$code" -eq 404 ]; then
        echo -e "[*]-> ${yellow}[NOT FOUND]${nc} $url"
    else
        echo -e "[*]-> ${yellow}[$code]${nc} $url"
    fi
done

echo ""
center "$line"
echo -e "${nc}"
