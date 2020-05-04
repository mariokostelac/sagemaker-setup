#!/usr/bin/env bash

echo "Setting up ssh with bastion..."

INTERNAL_VPC_ADDR=$(ip -4 addr show eth2 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | tr . -)
INTERNAL_HOSTNAME="ip-${INTERNAL_VPC_ADDR}.ec2.internal"

# copy-ssh-keys script
mkdir -p /home/ec2-user/.ssh && chown ec2-user:ec2-user /home/ec2-user/.ssh
mkdir -p /home/ec2-user/SageMaker/ssh && chown -R ec2-user:ec2-user /home/ec2-user/SageMaker/ssh
cat > /usr/bin/copy-ssh-keys <<'EOF'
#!/usr/bin/env bash

set -e

touch /home/ec2-user/SageMaker/ssh/authorized_keys
chown ec2-user:ec2-user /home/ec2-user/SageMaker/ssh/authorized_keys

cnt=$(cat /home/ec2-user/SageMaker/ssh/authorized_keys | wc -l)
echo "Copying ${cnt} SSH keys..."
cp /home/ec2-user/SageMaker/ssh/authorized_keys /home/ec2-user/.ssh/authorized_keys
EOF


cat > /home/ec2-user/SageMaker/SSH_INSTRUCTIONS <<EOD
SSH enabled through ngrok!

Use ssh ec2-user@${INTERNAL_HOSTNAME} to SSH here!
EOD
chmod +x /usr/bin/copy-ssh-keys
chown ec2-user:ec2-user /usr/bin/copy-ssh-keys

copy-ssh-keys
