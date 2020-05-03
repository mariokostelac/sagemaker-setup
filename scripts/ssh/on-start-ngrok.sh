#!/usr/bin/env bash

echo "Setting up ssh with ngrok..."

echo "Downloading ngrok..."
curl https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip > ngrok.zip
unzip ngrok.zip

echo "Creating config file /home/ec2-user/SageMaker/.ngrok/config.yml..."
mkdir -p /home/ec2-user/SageMaker/.ngrok
if [[ ! -e /home/ec2-user/SageMaker/.ngrok/config.yml ]]; then
    cat > /home/ec2-user/SageMaker/.ngrok/config.yml << EOF
authtoken: $NGROK_AUTH_TOKEN
tunnels:
    ssh:
        proto: tcp
        addr: 22
EOF
fi

echo "Creating /usr/bin/start-ngrok-ssh..."
cat > /usr/bin/start-ngrok-ssh <<'EOF'
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

cat > /home/ec2-user/SageMaker/SSH_INSTRUCTIONS <<EOD
SSH enabled through ngrok!

address: ${TUNNEL_URL}
EOD
EOF

chmod +x /usr/bin/start-ngrok-ssh
start-ngrok-ssh
