#!/usr/bin/env bash

echo "Setting up ssh with ngrok..."
curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip
unzip ngrok.zip

./ngrok tcp 22 --log=stdout >> /tmp/ngrok.log &

sleep 2
TUNNEL_URL=$(grep -Eo 'url=.+' ngrok.log | cut -d= -f2)
if [[ -e $TUNNEL_URL ]]; then
    echo "Failed to set up ssh with ngrok"
fi

echo "SSH address ${TUNNEL_URL}"

cat > /home/ec2-user/SageMaker/SSH_INSTRUCTIONS << EOF
SSH enabled through ngrok!

address: ${TUNNEL_URL}
EOF
