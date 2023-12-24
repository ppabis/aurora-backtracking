#!/bin/bash
# This script will open a shell to the Aurora cluster
export AURORA_HOST=$(aws ssm get-parameter --name /testaurora/endpoint --output text --query "Parameter.Value")
# Type the password when prompted
mysql -h $AURORA_HOST -u user -p