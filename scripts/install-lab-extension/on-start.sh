#!/usr/bin/env bash

set -e

sudo EXTENSION_NAME="${EXTENSION_NAME}" -u ec2-user -i <<'EOF'

if [[ -z "${EXTENSION_NAME}" ]]; then
  echo "EXTENSION_NAME is empty"
  exit
fi

source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
jupyterlab extension install ${EXTENSION_NAME}
source /home/ec2-user/anaconda3/bin/deactivate
EOF
