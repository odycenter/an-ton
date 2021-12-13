#!/bin/bash
set -e
echo "Ton Mining Tools processing ..."
# Mining pool && wallet
giver_address="kf8kO6K6Qh6YM4ddjRYYlvVAK7IgyW8Zet-4ZvNrVsmQ4EOF"
# giver_address="Uf_hLYWdlWIvlceh2YMYku3P6OFGECQGiyz_US6c-Wc3hwkF"
my_address="EQACwiacIj-gfKXapcZmnOoX9G54t1rhAZUkq1L92VpmtVjO"
global_config="/opt/ton-miner/global.config.json"
ton_miner="/opt/ton-miner/tonlib-cuda-cli"
miner=7
# Update system path
apt-get update && apt-get upgrade
# Set mining folder
if [[ ! -f "/opt/ton-miner/" ]]; then
    sudo mkdir -p /opt/ton-miner/
fi
cd /opt/ton-miner
# Install Nvidia cuda
if [[ ! -e "/opt/ton-miner/cuda-ubuntu1804.pin" ]]; then
    apt-get install gnupg gnupg2 software-properties-common wget
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin --no-check-certificate
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
    sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
    apt-get install sudo vim curl systemd git ntp  nvidia-settings cuda-drivers-495 cuda-runtime-11-5 cuda-demo-suite-11-5 cuda-11-5 cuda
fi
# Download mining package
if [[ ! -e "/opt/ton-miner/minertools-cuda-ubuntu-18.04-x86-64.tar.gz" ]]; then
    wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211112-3/minertools-cuda-ubuntu-18.04-x86-64.tar.gz --no-check-certificate
    # Unzip mining package
    tar xzf /opt/ton-miner/minertools-cuda-ubuntu-18.04-x86-64.tar.gz -C /opt/ton-miner/
fi
# Download Config (Need to re-download once a week)
if [[ ! -e "/opt/ton-miner/global.config.json" ]]; then
    curl -L -O https://newton-blockchain.github.io/global.config.json
    chmod 777 global.config.json
fi
# Show mining log when start
sed -i -e '$i \tail -f /var/log/syslog \n' /etc/rc.local
# Crontab download global.config.json
if [[ -e "/opt/ton-miner/DailyDownload.sh" ]]; then
    rm -rf DailyDownload.sh
fi
wget https://raw.githubusercontent.com/odycenter/an-ton/main/DailyDownload.sh --no-check-certificate
chmod 777 DailyDownload.sh
echo "# Crontab download global.config.json" >> /etc/crontab
echo "* 15    * * *    root    bash /opt/ton-miner/DailyDownload.sh" >> /etc/crontab
# Write running parameter
for i in $(seq 0 $miner);
do
if [[ -e "/etc/systemd/system/miner_gpu$i.service" ]]; then
    rm -rf /etc/systemd/system/miner_gpu$i.service
fi
echo "[Unit]
Description=TON miner
After=network.target

[Service]
RestartSec=5
Restart=always
WorkingDirectory=/opt/ton-miner
ExecStart="$ton_miner" -v 3 -C "$global_config" -e 'pminer start "$giver_address" "$my_address" "$i" 32 0'  [-l logfile]

[Install]
WantedBy=multi-user.target
Alias=miner_gpu"$i".service" >> /etc/systemd/system/miner_gpu$i.service
chmod 777 /etc/systemd/system/miner_gpu$i.service
sudo systemctl enable miner_gpu$i.service
done
echo "Ton Mining Tools finish ..."
# Reboot
shutdown -r now
