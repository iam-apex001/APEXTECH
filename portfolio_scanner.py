#!/usr/bin/env python3
import os
import re
import shutil
import subprocess
import sys


files = [
    "goinstallation_log.txt",
    "subfinderlog.txt",
    "httpxlog.txt",
    "basicscan.txt",
    "sourcescan.txt",
    "cleanscan.txt",
    "jsonscan.txt",
    "activescan.txt",
]

for f in files:
    if os.path.exists(f):
        os.remove(f)
        
subprocess.run(["clear"])
print("[+] Log and scan files deleted")

GREEN = "\033[92m"
DIMG = "\033[32m"
RESET = "\033[0m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
RED = "\033[91m"
DIMR = "\033[31m"

cols = shutil.get_terminal_size((80, 24)).columns

APEX = """ █████╗ ██████╗ ███████╗██╗  ██╗
██╔══██╗██╔══██╗██╔════╝╚██╗██╔╝
███████║██████╔╝█████╗   ╚███╔╝ 
██╔══██║██╔═══╝ ██╔══╝   ██╔██╗ 
██║  ██║██║     ███████╗██╔╝ ██╗
╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝"""

TECH = """████████╗███████╗ ██████╗██╗  ██╗
╚══██╔══╝██╔════╝██╔════╝██║  ██║
   ██║   █████╗  ██║     ███████║
   ██║   ██╔══╝  ██║     ██╔══██║
   ██║   ███████╗╚██████╗██║  ██║
   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝"""

GO_CHECK_SCRIPT = """
if ! command -v go &> /dev/null; then
    echo "[+] Go is not installed. Installing..."
    if command -v pkg &> /dev/null; then
        pkg update -y && pkg install -y golang > goinstallation_log.txt 2>&1
    else
        sudo apt update && sudo apt-get install -y golang-go > goinstallation_log.txt 2>&1
    fi
    if command -v go &> /dev/null; then
        echo "[+] Go installed successfully..."
    else
        echo "[+] Go installation failed. Check goinstallation_log.txt"
        exit 1
    fi
else
    echo "[+] Go is already installed: $(go version)"
fi
"""

SUBFINDER_PKG = "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
HTTPX_PKG = "github.com/projectdiscovery/httpx/cmd/httpx@latest"


# ---------- helpers ----------
def center_block(block: str) -> str:
    """Center a multi-line block as one unit, preserving internal alignment."""
    lines = block.splitlines()
    width = max(len(line) for line in lines)
    pad = max((cols - width) // 2, 0)
    return "\n".join(" " * pad + line for line in lines)


def center_line(text: str) -> str:
    pad = max((cols - len(text)) // 2, 0)
    return " " * pad + text


def divider(char="="):
    width = shutil.get_terminal_size().columns
    line = char * (width * 90 // 100)
    print(GREEN + line.center(width) + RESET)


def show_banner():
    print(RED + "[+] All installations log are stored in txt files!" + RESET)
    print()
    print(GREEN + center_block(APEX))
    print(center_block(TECH) + RESET)
    print()
    print(CYAN + center_line("[ root@apex ~ ]$ access granted_") + RESET)
    print(CYAN + center_line("[+] Program type : Domain & Subdomain scanner") + RESET)
    print("\n")
    print(RED + "[+] Domain must have a host.")
    print(GREEN + "[+] example example.com" + RESET)
    print("\n")


def check_go():
    subprocess.run(["bash", "-c", GO_CHECK_SCRIPT])
    if shutil.which("go") is None:
        print(RED + "[+] Go is required. Exiting..." + RESET)
        sys.exit(1)


def install_tool(name, package, logfile):
    """Install a Go tool only if it is not already on PATH."""
    if shutil.which(name) is not None:
        print(GREEN + f"[+] {name} is already installed" + RESET)
        return

    print(GREEN + f"[+] Installing {name}..." + RESET)
    with open(logfile, "w") as log:
        result = subprocess.run(
            ["go", "install", "-v", package],
            stdout=log,
            stderr=subprocess.STDOUT,
        )

    if result.returncode != 0 or shutil.which(name) is None:
        print(RED + f"[+] Failed to install {name}. Check {logfile}" + RESET)
        sys.exit(1)
    print(GREEN + f"[+] {name} installed successfully" + RESET)


def show_results(content, outfile):
    print()
    divider()
    print()
    print(content if content.strip() else "[+] No results found.")
    print()
    divider()
    print(GREEN + f"[+] Results saved to {outfile}" + RESET)


# ---------- scanning ----------
def run_scan(label, cmd, outfile):
    print(GREEN + f"[+] Scanning in {label} mode..." + RESET)
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(RED + "[+] Scan failed:" + RESET)
        print(RED + result.stderr + RESET)
        return

    with open(outfile, "w") as f:
        f.write(result.stdout)
    show_results(result.stdout, outfile)


def run_active_scan(domain, outfile):
    install_tool("httpx", HTTPX_PKG, "httpxlog.txt")
    print(GREEN + "[+] Finding subdomains, then checking which are live..." + RESET)

    sub = subprocess.run(
        ["subfinder", "-d", domain, "-silent"], capture_output=True, text=True
    )
    if sub.returncode != 0 or not sub.stdout.strip():
        print(RED + "[+] No subdomains found or subfinder failed." + RESET)
        print(RED + sub.stderr + RESET)
        return

    live = subprocess.run(
        ["httpx", "-silent"], input=sub.stdout, capture_output=True, text=True
    )
    if live.returncode != 0:
        print(RED + "[+] httpx failed:" + RESET)
        print(RED + live.stderr + RESET)
        return

    with open(outfile, "w") as f:
        f.write(live.stdout)
    show_results(live.stdout, outfile)


def run(domain):
    menu = """[+] Enter B to run basic scan!
[+] Enter A to use all sources (more slower)
[+] Enter J to get Json output
[+] Enter C for clean output
[+] Enter F to find active subdomains"""
    print()
    print(CYAN + menu + RESET)
    choice = input(CYAN + "[+]~$ " + RESET).strip().upper()

    base = ["subfinder", "-d", domain]

    if choice == "B":
        run_scan("basic", base, "basicscan.txt")
    elif choice == "A":
        run_scan("all sources", base + ["-all"], "sourcescan.txt")
    elif choice == "J":
        run_scan("JSON", base + ["-json"], "jsonscan.txt")
    elif choice == "C":
        run_scan("clean", base + ["-silent"], "cleanscan.txt")
    elif choice == "F":
        run_active_scan(domain, "activescan.txt")
    else:
        print(RED + "[+] Invalid input" + RESET)


# ---------- main ----------
def main():
    show_banner()
    check_go()

    os.environ["PATH"] += os.pathsep + os.path.expanduser("~/go/bin")
    install_tool("subfinder", SUBFINDER_PKG, "subfinderlog.txt")

    domain = input(RED + "[+] enter Domain to scan : " + RESET).strip().lower()
    domain = domain.removeprefix("https://").removeprefix("http://").rstrip("/")

    pattern = r"^([a-z0-9-]+\.)+[a-z]{2,}$"
    if not re.match(pattern, domain):
        print(RED + "[+] Invalid format. Use something like example.com" + RESET)
        print(RED + "[+] exiting.." + RESET)
        sys.exit(1)

    run(domain)


if __name__ == "__main__":
    main()
