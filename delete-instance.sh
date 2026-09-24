#!/bin/bash

INSTANCES=("mongodb" "redis" "nginx" "nodejs" "mysql" "frontend" "payment")

for instance in "${INSTANCES[@]}"
do
    echo "Finding instance: $instance"

    INSTANCE_ID=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=$instance" \
                  "Name=instance-state-name,Values=pending,running,stopping,stopped" \
        --query "Reservations[*].Instances[*].InstanceId" \
        --output text)

    if [ -z "$INSTANCE_ID" ]; then
        echo "No instance found for $instance"
    else
        echo "Terminating $instance ($INSTANCE_ID)"

        aws ec2 terminate-instances \
            --instance-ids "$INSTANCE_ID"
    fi
done

echo "Termination request completed"