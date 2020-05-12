#!/usr/bin/env bash

set -e

sudo PIP_PACKAGE_NAME="${PIP_PACKAGE_NAME}" EXTENSION_NAME="${EXTENSION_NAME}" -u ec2-user -i <<'EOF'
if [[ -z "${PIP_PACKAGE_NAME}" ]]; then
  echo "PIP_PACKAGE_NAME is empty"
  exit
fi

if [[ -z "${EXTENSION_NAME}" ]]; then
  echo "EXTENSION_NAME is empty"
  exit
fi

source /home/ec2-user/anaconda3/bin/activate JupyterSystemEnv
pip install ${PIP_PACKAGE_NAME}
jupyter nbextension enable ${EXTENSION_NAME} --py --sys-prefix
source /home/ec2-user/anaconda3/bin/deactivate
EOF
