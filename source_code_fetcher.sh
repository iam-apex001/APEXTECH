

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

#install tput 
echo -e "${magenta}[+] installing tput... (result in source_code_tput.txt)"
if apt-get install -y ncurses-utils > source_code_tput.txt 2>&1; then
    echo -e "${green}[+]=> tput installed successfully${nc}"
else
    echo -e "${red}[+]=> tput installation failed${nc}"
fi

#install curl 
echo -e "${magenta}[+] installing curl... (result in source_code_curl.txt)"
if apt-get install -y curl > source_code_curl.txt 2>&1; then
    echo -e "${green}[+]=> curl installed successfully${nc}"
else
    echo -e "${red}[+]=> curl installation failed${nc}"
    echo -e "${red}[+] Editing..."
    exit 0
fi


center() {
    local width
    width=$(tput cols 2>/dev/null)
    [ -z "$width" ] && width=80

    while IFS= read -r line; do
        local len=${#line}
        local pad=$(( (width - len) / 2 ))
        [ "$pad" -lt 0 ] && pad=0
        printf "%${pad}s%s\n" "" "$line"
    done <<< "$1"
}

echo -e "${green}"
center " █████╗ ██████╗ ███████╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝
███████║██████╔╝█████╗   ╚███╔╝ 
██╔══██║██╔═══╝ ██╔══╝   ██╔██╗ 
██║  ██║██║     ███████╗██╔╝ ██╗
╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝"
center " ████████╗███████╗ ██████╗██╗  ██╗
╚══██╔══╝██╔════╝██╔════╝██║  ██║
   ██║   █████╗  ██║     ███████║
   ██║   ██╔══╝  ██║     ██╔══██║
   ██║   ███████╗╚██████╗██║  ██║
   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"
   
echo -e "${nc}"
echo -e "${cyan}"
center "[+] Program type : source code fetcher"
echo -e "${nc}"


echo ""
echo -e "${cyan}[+] Enter Url (e.g https://www.example.com both http and https are valid! and url must match this syntax)${nc}"
echo -e "${cyan}[+] Enter Q to exit ${nc}"
echo -e "${cyan}[+] Enter H to print this command line${nc}"
echo -e "${cyan}[+] Enter CL to clear the terminal${nc}"



while true; do
    read -p "[+] => " user_inp
    
    if [ "$user_inp" == "Q" ] || [ "$user_inp" == "q" ]; then
        echo -e "${red}[+] Exiting..."
        sleep 1
        exit 0    
    elif [[ $user_inp =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,} ]]; then
        echo -e "${green}[+] Verifying url..."
        sleep 1
        #check if url responds to call
        response=$(curl --head --silent --connect-timeout 10 --max-time 10 -w "%{http_code}" -o /dev/null "$user_inp")
        curl_exit=$?
        if [ $curl_exit -eq 28 ]; then
            echo -e "${red} TIMEOUT - $url did not respond in 10s${nc}"
        elif [ $curl_exit -eq 0 ] && [ "$response" -eq 200 ]; then
            echo -e "${green}[+] Url confirmed ✅"
            echo -e "${cyan}[+] Fetching...${nc}"
            sleep 1
            echo -e "${cyan}[+] Fetched successful ✅${nc}"
            read -p "[+] Enter desired file name (No extensions): " fname
            curl --silent $user_inp > $fname.txt
            echo -e "${green}[+] Source code saved in $fname.txt${nc}"
        else
            echo -e "${red}[+] DOWN - $user_inp returned $response (exit code $curl_exit)"
        fi
    elif [ "$user_inp" == "H" ] || [ "$user_inp" == "h" ]; then
        echo ""
        echo -e "${cyan}[+] Enter Url (e.g www.example.com)${nc}"
        echo -e "${cyan}[+] Enter Q to exit ${nc}"
        echo -e "${cyan}[+] Enter H to print this command line${nc}"
        echo -e "${cyan}[+] Enter CL to clear the terminal${nc}"
    elif [ "$user_inp" == "CL" ] || [ "$user_inp" == "cl" ] || [ "$user_inp" == "Cl" ] || [ "$user_inp" == "cL" ]; then
        clear
        echo -e "${green}"
        center " █████╗ ██████╗ ███████╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝
███████║██████╔╝█████╗   ╚███╔╝ 
██╔══██║██╔═══╝ ██╔══╝   ██╔██╗ 
██║  ██║██║     ███████╗██╔╝ ██╗
╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝"
        center " ████████╗███████╗ ██████╗██╗  ██╗
╚══██╔══╝██╔════╝██╔════╝██║  ██║
   ██║   █████╗  ██║     ███████║
   ██║   ██╔══╝  ██║     ██╔══██║
   ██║   ███████╗╚██████╗██║  ██║
   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"
           
        echo -e "${nc}"
        echo -e "${cyan}"
        echo -e "${nc}"
        
        
        echo ""
        echo -e "${cyan}[+] Enter Url (e.g www.example.com)${nc}"
        echo -e "${cyan}[+] Enter Q to exit ${nc}"
        echo -e "${cyan}[+] Enter H to print this command line${nc}"
        echo -e "${cyan}[+] Enter CL to clear the terminal${nc}"
    else 
       echo -e "${red}[+] Command not found! input a URL or The command listed ${nc}"    
   fi
done


#extras
