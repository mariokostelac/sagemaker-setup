#!/bin/bash

set -e

# OVERVIEW
# This script stops a SageMaker notebook once it's idle for more than 1 hour (default time)
# You can change the idle time for stop using the environment variable below.
# If you want the notebook the stop only if no browsers are open, remove the --ignore-connections flag
#
# Note that this script will fail if either condition is not met
#   1. Ensure the Notebook Instance has internet connectivity to fetch the example config
#   2. Ensure the Notebook Instance execution role permissions to SageMaker:StopNotebookInstance to stop the notebook
#       and SageMaker:DescribeNotebookInstance to describe the notebook.
#

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

AUTO_STOP_AFTER_SECONDS=$(aws sagemaker list-tags --resource-arn ${NOTEBOOK_INSTANCE_ARN} | jq '.Tags | map(select(.Key == "AUTO_STOP_AFTER_SECONDS")) | .[0].Value' | tr -d '"')
if [[ "${AUTO_STOP_AFTER_SECONDS}" == "null" ]]; then
    AUTO_STOP_AFTER_SECONDS=7200
fi

echo "Setting cron autostop.py to stop after ${AUTO_STOP_AFTER_SECONDS} seconds of idleness"
(crontab -l 2>/dev/null; echo "*/5 * * * * /bin/bash -c '/usr/bin/python3 $DIR/autostop.py --time ${AUTO_STOP_AFTER_SECONDS} | tee -a /home/ec2-user/SageMaker/auto-stop-idle.log'") | crontab -

echo "Making sure logs are sent to cloudwatch"
has_config=$(grep "auto-stop-idle" /etc/awslogs/awslogs.conf || echo "no")
if [[ "${has_config}" == "no" ]]; then
    echo "adding awslogs config for auto-stop-idle"
    cat >> /etc/awslogs/awslogs.conf <<EOF

[/home/ec2-user/SageMaker/auto-stop-idle.log]
file = /home/ec2-user/SageMaker/auto-stop-idle*
buffer_duration = 5000
log_stream_name = ${NOTEBOOK_INSTANCE_NAME}/auto-stop-idle
initial_position = end_of_file
log_group_name = /aws/sagemaker/NotebookInstances
EOF
else
    echo "awslogs already has config for auto-stop-idle"
fi

echo "Restaring awslogs service"
pkill -f "/usr/bin/aws logs push" || true
sleep 5
service awslogs start
