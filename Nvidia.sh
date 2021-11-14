#!/bin/bash
set -e

echo "Ton Mining Tools processing ..."
# Update system path
apt-get update && apt-get upgrade
# Set mining folder
sudo mkdir -p /opt/ton-miner
cd /opt/ton-miner
# Install Nvidia cuda
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
apt-get install nvidia-settings cuda-drivers-495 cuda-runtime-11-5 cuda-demo-suite-11-5 cuda-11-5 cuda
# Download mining package
wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211112-3/minertools-cuda-ubuntu-18.04-x86-64.tar.gz
# Unzip mining package
tar xzf /opt/ton-miner/minertools-cuda-ubuntu-18.04-x86-64.tar.gz -C /opt/ton-miner/
# Download Config (Need to re-download once a week)
curl -L -O https://newton-blockchain.github.io/global.config.json
chmod 777 global.config.json
# Write running parameter
echo "/opt/ton-miner/tonlib-cuda-cli  -v 3  -C /opt/ton-miner/global.config.json  -e 'pminer start kf8kO6K6Qh6YM4ddjRYYlvVAK7IgyW8Zet-4ZvNrVsmQ4EOF EQACwiacIj-gfKXapcZmnOoX9G54t1rhAZUkq1L92VpmtVjO [0 1 2 3 4 5 6 7] 32 0'  [-l logfile]" >> /etc/rc.local

echo "Ton Mining Tools finish ..."
# Reboot
shutdown -r now