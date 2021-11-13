#!/bin/bash
set -e

apt-get install opencl-headers ocl-icd-libopencl1 ocl-icd-opencl-dev -y
cd /home/user
wget https://github.com/tontechio/pow-miner-gpu/releases/download/20211112-3/minertools-opencl-ubuntu-18.04-x86-64.tar.gz
mkdir /opt/ton-miner/
tar xzf /home/user/minertools-opencl-ubuntu-18.04-x86-64.tar.gz -C /opt/ton-miner/

cd /opt/ton-miner && curl -L -O https://newton-blockchain.github.io/global.config.json
chmod 777 global.config.json

/opt/ton-miner/tonlib-opencl-cli  -v 3  -C /opt/ton-miner/global.config.json  -e 'pminer start kf8kO6K6Qh6YM4ddjRYYlvVAK7IgyW8Zet-4ZvNrVsmQ4EOF EQACwiacIj-gfKXapcZmnOoX9G54t1rhAZUkq1L92VpmtVjO 0 32 0'  [-l logfile]
