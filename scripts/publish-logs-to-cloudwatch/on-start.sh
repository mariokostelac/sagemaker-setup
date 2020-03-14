#!/usr/bin/env bash

set -e

LOG_NAME=$1
FILENAME=$2
NOTEBOOK_INSTANCE_NAME=$(jq '.ResourceName' \
                      /opt/ml/metadata/resource-metadata.json --raw-output)

# make sure it exists before we create a rule
touch $FILENAME

echo "Changing awslogs configuration to send ${FILENAME}"
has_config=$(grep "${LOG_NAME}" /etc/awslogs/awslogs.conf || echo "no")
if [[ "${has_config}" == "no" ]]; then
    echo "adding awslogs config for ${LOG_NAME}"
    cat >> /etc/awslogs/awslogs.conf <<EOF

[${FILENAME}]
file = ${FILENAME}
buffer_duration = 5000
log_stream_name = ${NOTEBOOK_INSTANCE_NAME}/${LOG_NAME}
initial_position = end_of_file
log_group_name = /aws/sagemaker/NotebookInstances
EOF
else
    echo "awslogs already has config for ${LOG_NAME}"
fi

echo "Restaring awslogs service"
pkill -f "/usr/bin/aws logs push" || true
sleep 5
service awslogs start