#!/bin/bash
set -e

echo "Ton Mining Tools processing ..."
# Update system path
apt-get update && apt-get upgrade
# Install necessary package
apt-get install sudo vim wget curl git sudo opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev
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
# Write running parameter
echo "/opt/ton-miner/tonlib-opencl-cli  -v 3  -C /opt/ton-miner/global.config.json  -e 'pminer start kf8kO6K6Qh6YM4ddjRYYlvVAK7IgyW8Zet-4ZvNrVsmQ4EOF EQACwiacIj-gfKXapcZmnOoX9G54t1rhAZUkq1L92VpmtVjO [0 1 2 3 4 5 6 7] 32 0'  [-l logfile]" >> /etc/rc.local

echo "Ton Mining Tools finish ..."
# Reboot
shutdown -r now