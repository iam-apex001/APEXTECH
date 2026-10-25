#!/data/data/com.termux/files/usr/bin/bash

# Here are 10 easy bash commands to start with:
# 1.  pwd - Shows where you are -
# 2.  ls - Lists files in the folder -
# 3.  mkdir - Create a new folder, e.g. mkdir myfolder -
# 4.  touch - Create a new empty file, e.g. touch file.txt -
# 5.  cat - View file content, e.g. cat file.txt -

# 6.  rm - Delete, e.g. rm file.txt -
# 7. clear - Clears the screen -


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
echo -e "${magenta}[+] installing tput... (result in minidistro_tput.txt)"
if apt-get install -y ncurses-utils > minidistro_tput.txt 2>&1; then
    echo -e "${green}[+]=> tput installed successfully${nc}"
else
    echo -e "${red}[+]=> tput installation failed${nc}"
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
center "[+] Program type : mini distro"
echo -e "${nc}"

echo -e "${cyan}"

center "[+] 𝚈𝚘𝚞'𝚛𝚎 𝚠𝚎𝚕𝚌𝚘𝚖𝚎 𝚝𝚘 𝚖𝚢 𝚖𝚒𝚗𝚒 𝚍𝚒𝚜𝚝𝚛𝚘 𝚠𝚑𝚊𝚝 𝚠𝚘𝚞𝚕𝚍 𝚢𝚘𝚞 𝚕𝚒𝚔𝚎 𝚝𝚘 𝚍𝚘? [𝚘𝚗𝚕𝚢 10 𝚌𝚘𝚖𝚖𝚊𝚗𝚍𝚜 𝚊𝚛𝚎 𝚊𝚟𝚊𝚒𝚕𝚊𝚋𝚕𝚎]"

echo "[+] Enter P to print working directory"
echo "[+] Enter L to list files"
echo "[+] Enter M to make new directory"
echo "[+] Enter T to make a new file"
echo "[+] Enter S to show a file content"
echo "[+] Enter R to remove a file"
echo "[+] Enter RD to remove a directory"
echo "[+] Enter CL to clear the terminal"
echo "[+] Enter Q to exit the program"
echo "[+] Enter H to print this command list"

echo -e "${nc}"

while true; do 
    read -p "[+] " input

    if [ "$input" == "P" ] || [ "$input" == "p" ]; then
        echo -e "${cyan}[+] Your current working directory is : $(pwd)${nc}"
        echo ""
        
    elif [ "$input" == "Q" ] || [ "$input" == "q" ]; then
        clear
        exit 0
    elif [ "$input" == "L" ] || [ "$input" == "l" ]; then 
        ls
        echo -e "${green}[+]File listed successfully${nc}"
        echo ""
    elif [ "$input" == "M" ] || [ "$input" == "m" ]; then 
        echo -e "${cyan}[+] Enter directory name:${nc}"
        read -p  "[+] => " dname
        mkdir "$dname"
        echo -e "${green} Directory created!${nc}"
        ls
        
    elif [ "$input" == "T" ] || [ "$input" == "t" ]; then 
        echo -e "${cyan}[+] Enter file name:${nc}"
        read -p "[+] => " fname
        touch "$fname"
        echo -e "${green} File created successfully! ${nc}"
        ls
    
    elif [ "$input" == "S" ] || [ "$input" == "s" ]; then 
        echo -e "${cyan}[+] Enter file name:${nc}"
        read -p "[+] => " cfname
        if [ -f "$cfname" ]; then
            cat "$cfname"
            echo ""
            echo -e "${green}[+] Done ✅${nc}"
        else 
            echo -e "${red}File does not exist!${nc}"
        fi
    elif [ "$input" == "RD" ] || [ "$input" == "rd" ] || [ "$input" == "Rd" ] || [ "$input" == "rD" ]; then
        echo -e "${cyan}[+] Enter folder name:${nc}"
        read -p "[+] => " rfname
        if [ -d "$rfname" ]; then
            echo -e "${red}[+] Are you sure you want to remove this folder? (Y or N)${nc}"
            read -p "[+] => " ans
            if [ "$ans" == "Y" ] || [ "$ans" == "y" ]; then
                rm -r "$rfname"
                echo ""
                echo -e "${green}[+] Done ✅${nc}"
            else
                echo -e "${red}[+] operation canceled ❌${nc}"
            fi
        else 
            echo -e "${red}[+] Folder does not exist!${nc}"
        fi
    
    elif [ "$input" == "H" ] || [ "$input" == "h" ]; then
    echo -e "${cyan}"
        echo "[+] Enter P to print working directory"
        echo "[+] Enter L to list files"
        echo "[+] Enter M to make new directory"
        echo "[+] Enter T to make a new file"
        echo "[+] Enter S to show a file content"
        echo "[+] Enter R to remove a file"
        echo "[+] Enter RD to remove a directory"
        echo "[+] Enter CL to clear the terminal"
        echo "[+] Enter Q to exit the program"
        echo "[+] Enter H to print this command list"
        echo -e "${nc}"
    elif [ "$input" == "R" ] || [ "$input" == "r" ]; then
        echo -e "${cyan}[+] Enter file name: ${nc}"
        read -p "[+] => " rfname
        if [ -f "$rfname" ]; then
            rm "$rfname"
            echo -e "${green} File removed!${nc}"
            ls
            echo ""
        else 
            echo -e "${cyan}[+] File does not exist${nc}"
            echo ""
        fi
    elif [ "$input" == "CL" ] || [ "$input" == "cl" ] || [ "$input" == "Cl" ] || [ "$input" == "cL" ]; then
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
        center "[+] Program type : mini distro"
        echo -e "${nc}"
        
        echo -e "${cyan}"
        echo "[+] Enter P to print working directory"
        echo "[+] Enter L to list files"
        echo "[+] Enter M to make new directory"
        echo "[+] Enter T to make a new file"
        echo "[+] Enter S to show a file content"
        echo "[+] Enter R to remove a file"
        echo "[+] Enter RD to remove a directory"
        echo "[+] Enter CL to clear the terminal"
        echo "[+] Enter Q to exit the program"
        echo "[+] Enter H to print this command list"
        echo -e "${nc}"
        
    elif [ "$input" == "" ]; then
        echo "[+] Enter command"
    else 
        echo -e "${red}[+] Reference error : Command not found${nc}"
        echo -e "${cyan}"
        echo "[+] Enter P to print working directory"
        echo "[+] Enter L to list files"
        echo "[+] Enter M to make new directory"
        echo "[+] Enter T to make a new file"
        echo "[+] Enter S to show a file content"
        echo "[+] Enter R to remove a file"
        echo "[+] Enter RD to remove a directory"
        echo "[+] Enter CL to clear the terminal"
        echo "[+] Enter Q to exit the program"
        echo "[+] Enter H to print this command list"
        echo -e "${nc}"

    fi
done