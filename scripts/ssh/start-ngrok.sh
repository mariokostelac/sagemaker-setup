#!/usr/bin/env bash

set -e

echo "Starting ngrok..."
./ngrok start --all --log=stdout --config /home/ec2-user/SageMaker/.ngrok/config.yml > /var/log/ngrok.log &
sleep 10

TUNNEL_URL=$(grep -Eo 'url=.+' /var/log/ngrok.log | cut -d= -f2)
if [[ -z $TUNNEL_URL ]]; then
    echo "Failed to set up ssh with ngrok"
fi

echo "SSH address ${TUNNEL_URL}"

cat > /home/ec2-user/SageMaker/SSH_INSTRUCTIONS << EOF
SSH enabled through ngrok!

address: ${TUNNEL_URL}
EOF
