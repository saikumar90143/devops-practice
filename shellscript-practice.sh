#!/bin/bash

AMI_ID=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
  --query "sort_by(Images,&CreationDate)[-1].ImageId" \
  --output text)

echo "$AMI_ID"
SECURITY_GROUP="sg-0755959e26b7a9f6f"
ZONE_ID="Z00153201P4149L9IX6W4"
DOMAIN="elitereviews.in"

INSTANCES=("mongodb" "redis" "nginx" "nodejs" "mysql" "frontend" "payment")

for instance in "${INSTANCES[@]}"
do
  echo "Creating instance: $instance"
 INSTANCEID=$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t3.micro \
    --security-group-ids $SECURITY_GROUP \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]"\
    --query 'Instances[0].InstanceId' \
    --output text)

    if [ $instance != "frontend" ]
    then
       IP_ADDRESS=$(aws ec2 describe-instances \
        --instance-ids $INSTANCEID \
        --query 'Reservations[0].Instances[0].PrivateIpAddress' \
        --output text)

        else
        IP_ADDRESS=$(aws ec2 describe-instances \
        --instance-ids $INSTANCEID \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        --output text)
    fi
    echo "Instance $instance created with ID: $INSTANCEID and IP Address: $IP_ADDRESS"
done        