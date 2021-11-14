#!/bin/bash
set -e
echo "Ton Mining Tools processing ..."
# Mining pool && wallet
giver_address="kf8kO6K6Qh6YM4ddjRYYlvVAK7IgyW8Zet-4ZvNrVsmQ4EOF"
my_address="EQACwiacIj-gfKXapcZmnOoX9G54t1rhAZUkq1L92VpmtVjO"
global_config="/opt/ton-miner/global.config.json"
ton_miner="/opt/ton-miner/tonlib-cuda-cli"
miner=7
# Update system path
apt-get update && apt-get upgrade
# Install necessary package
apt-get install sudo vim wget curl systemd git opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev
# Set mining folder
sudo mkdir -p /opt/ton-miner/
cd /opt/ton-miner/
# Download mining package
wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211112-3/minertools-opencl-ubuntu-18.04-x86-64.tar.gz
# Unzip mining package
tar xzf /opt/ton-miner/minertools-opencl-ubuntu-18.04-x86-64.tar.gz -C /opt/ton-miner/
# Download Config (Need to re-download once a week)
cd /opt/ton-miner && curl -L -O https://newton-blockchain.github.io/global.config.json
chmod 777 global.config.json
# Show mining log when start
sed -i -e '$i \tail -f /var/log/syslog &\n' /etc/rc.local
# Crontab download global.config.json
wget https://raw.githubusercontent.com/odycenter/an-ton/main/DailyDownload.sh
chmod 777 DailyDownload.sh
echo "# Crontab download global.config.json" >> /etc/crontab
echo "* 15    * * *    root    bash /opt/ton-miner/DailyDownload.sh" >> /etc/crontab
# Write running parameter
for i in $(seq 0 $miner);
do
# echo $ton_miner" -v 3 -C "$global_config" -e 'pminer start "$giver_address" "$my_address" "$i" 32 0'  [-l logfile]"
# echo $ton_miner" -v 3 -C "$global_config" -e 'pminer start "$giver_address" "$my_address" "$i" 32 0'  [-l logfile]" >> /etc/rc.local
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
done
echo "Ton Mining Tools finish ..."
# Reboot
shutdown -r now