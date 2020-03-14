#!/usr/bin/env bash
set -e
SHA=${1:-master}
echo "Installing version ${SHA}"

# create a friendly directory in persisted path
mkdir -p /home/ec2-user/lifecycle-scripts/auto-stop-idle
cd /home/ec2-user/lifecycle-scripts/auto-stop-idle

wget -O autostop.py https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/${SHA}/scripts/auto-stop-idle/autostop.py
chmod +x autostop.py

wget -O on-start https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/${SHA}/scripts/auto-stop-idle/on-start.sh
chmod +x on-start.sh

# install the watcher
./on-start.sh