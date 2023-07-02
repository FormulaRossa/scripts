apt-get update >/dev/null
echo "Success! Apt-get updated."

apt-get install -y git curl wget unzip python3-pip python3 >/dev/null
echo "Success! Important packages installed."

apt-get install -y figlet lolcat >/dev/null
figlet -w 150 "$(sed 's/.*/\u&/' </etc/hostname)" | /usr/games/lolcat -f >/etc/motd
chmod -x /etc/update-motd.d/* >/dev/null
echo "Success! MOTD set up."

curl -fsSL https://get.docker.com | sh >/dev/null
echo "Success! Docker installed."

sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >/dev/null
chmod +x /usr/local/bin/docker-compose >/dev/null
echo "Success! Docker Compose installed."

echo "----------------------------------------"
echo -e "\e[32mSuccess! All done. \e[0m"
