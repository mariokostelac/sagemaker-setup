This script turns off your machine after some period of inactivity.

Full guide on setting it up is available [here](https://biasandvariance.com/sagemaker-stop-your-instances-when-idle/).

In short, create a lifecycle configuration and add this to a "Start Notebook" script.
```bash
#!/bin/bash
set -e

# PARAMETERS
IDLE_TIME=3600

echo "Fetching the autostop script"
wget -O autostop.py https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/master/scripts/auto-stop-idle/autostop.py

echo "Starting the SageMaker autostop script in cron"
(crontab -l 2>/dev/null; echo "*/5 * * * * /bin/bash -c '/usr/bin/python3 $DIR/autostop.py --time ${IDLE_TIME} | tee -a /home/ec2-user/SageMaker/auto-stop-idle.log'") | crontab -

echo "Changing cloudwatch configuration"
curl https://raw.githubusercontent.com/mariokostelac/sagemaker-setup/master/scripts/publish-logs-to-cloudwatch/on-start.sh | sudo bash -s auto-stop-idle /home/ec2-user/SageMaker/auto-stop-idle.log
```