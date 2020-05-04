#!/usr/bin/env bash
set -e
cd /better-sagemaker

export NGROK_AUTH_TOKEN="<token>"
./scripts/ssh/on-start-ngrok.sh
