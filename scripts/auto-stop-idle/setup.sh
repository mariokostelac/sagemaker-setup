#!/usr/bin/env bash
set -e
SHA=${1:-master}
echo "Installing version ${SHA}"

#mkdir -p /home/ec2-user/lifecycle-scripts/auto-stop-idle
#cd /home/ec2-user/lifecycle-scripts/auto-stop-idle
wget https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/${SHA}/scripts/auto-stop-idle/autostop.py
wget https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/${SHA}/scripts/auto-stop-idle/on-start.sh
chmod +x autostop.py
chmod +x on-start.sh

