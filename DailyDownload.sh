#!/bin/bash
set -e

miner=7
echo "download config processing ..."
# Download Config (Need to re-download once a week)
cd /opt/ton-miner && curl -L -O https://newton-blockchain.github.io/global.config.json
chmod 777 global.config.json
# restart service
for i in $(seq 0 $miner);
do
systemctl restart miner_gpu$i.service
done
echo "download config finish ..."