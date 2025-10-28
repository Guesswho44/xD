#!/bin/bash
# ================================================
#   PREMIUM VPS SETUP BY MERZEY SIDE
#   Auto Installer from GitHub Repo
#   Repo: https://github.com/Guesswho44/xD
# ================================================

# URL RAW repo GitHub kau
RAW_URL="https://raw.githubusercontent.com/Guesswho44/xD/main"

# Lokasi sistem
TARGET_BIN="/usr/bin"
RCLONE_DIR="/root/.config/rclone"
ETC_VPN="/etc/vpn"

# Warna
RED='\e[1;31m'; GREEN='\e[0;32m'; YELLOW='\e[1;33m'; CYAN='\e[0;36m'; NC='\e[0m'

clear
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}🚀 Starting Installation from GitHub...${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
sleep 2

# Install dependencies
echo -e "${YELLOW}📦 Installing required packages...${NC}"
apt update -y
apt install -y curl wget jq unzip netcat socat nginx dropbear stunnel4 python3 python3-pip git rclone dnsutils cron zip tar

# Buat folder penting
mkdir -p $RCLONE_DIR
mkdir -p $ETC_VPN /etc/xray /etc/stunnel /etc/openvpn /etc/systemd/system

# Senarai semua file yang nak dimuat turun
FILES=(
"ADD-USER" "BANNER" "CHECK-USER" "CLOUD" "DELETE-USER" "INSTALL" "MENU" "MORE-OPTION"
"RENEW-USER" "SHOW-USER" "SSH" "SSHWS" "STUNNEL5" "SYSTEM" "TRIAL-USER" "UDP-CUSTOM"
"autokill.sh" "badvpn-udpgw64" "cert.sh" "cf.sh" "clear-log.sh" "dns-server" "dropbear"
"kernel.sh" "log-install.txt" "member.sh" "menu.sh" "nginx.conf" "ohp" "ohpd" "ohps"
"password" "rc.local" "rclone.conf" "script-updatessh.sh" "squid3.conf" "sshd_confif"
"swapkvm.sh" "updatessh.sh" "vpn.sh" "vpn.zip" "vps.conf" "xp.sh"
)

# Muat turun semua file
echo -e "${CYAN}⬇️ Downloading files from GitHub repo...${NC}"
for file in "${FILES[@]}"; do
    URL="$RAW_URL/$file"
    wget -q -O "$TARGET_BIN/$file" "$URL"
    if [ -f "$TARGET_BIN/$file" ]; then
        chmod +x "$TARGET_BIN/$file"
        echo -e "${GREEN}✔ Installed: $file${NC}"
    else
        echo -e "${RED}⚠ Failed: $file${NC}"
    fi
done

# Copy config ke lokasi sebenar
[ -f "$TARGET_BIN/nginx.conf" ] && cp "$TARGET_BIN/nginx.conf" /etc/nginx/nginx.conf
[ -f "$TARGET_BIN/squid3.conf" ] && cp "$TARGET_BIN/squid3.conf" /etc/squid/squid.conf
[ -f "$TARGET_BIN/sshd_confif" ] && cp "$TARGET_BIN/sshd_confif" /etc/ssh/sshd_config
[ -f "$TARGET_BIN/rclone.conf" ] && cp "$TARGET_BIN/rclone.conf" "$RCLONE_DIR/rclone.conf"
[ -f "$TARGET_BIN/vps.conf" ] && cp "$TARGET_BIN/vps.conf" "$ETC_VPN/vps.conf"
[ -f "$TARGET_BIN/rc.local" ] && cp "$TARGET_BIN/rc.local" /etc/rc.local && chmod +x /etc/rc.local

# Enable rc.local
if [ -f "/etc/rc.local" ]; then
    systemctl enable rc-local 2>/dev/null
fi

# Buat alias menu
if ! grep -q "alias menu=" ~/.bashrc; then
    echo "alias menu='/usr/bin/MENU'" >> ~/.bashrc
fi

# Restart service penting
echo -e "${YELLOW}🔁 Restarting services...${NC}"
systemctl restart nginx 2>/dev/null
systemctl restart ssh 2>/dev/null
systemctl restart dropbear 2>/dev/null
systemctl restart stunnel4 2>/dev/null

# Paparan siap
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
echo -e "${YELLOW}Type: ${CYAN}menu${YELLOW} to open the panel.${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sleep 2
/usr/bin/MENU
