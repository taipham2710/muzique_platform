#!/bin/bash

set -e

AWS_REGION="us-east-1"                                            # <--- Vùng AWS nơi ECR và ECS cluster đang chạy
ECR_URL="123456789012.dkr.ecr.us-east-1.amazonaws.com/my-service" # <--- URL của ECR repository
IMAGE_TAG="latest"                                                     # <--- Tag của image, có thể là latest hoặc version cụ thể
CONTAINER_NAME="my-service"                                            # <--- Tên container trong task definition
CLUSTER_NAME="my-ecs-cluster"                                          # <--- Tên ECS cluster dùng
SERVICE_NAME="my-ecs-service"                                          # <--- Tên ECS service deploy
TASK_FAMILY="my-task-family"                                           # <--- Tên family của ECS task definition

# Đăng nhập ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL

# Build & Push image
docker build -t $ECR_URL:$IMAGE_TAG .
docker push $ECR_URL:$IMAGE_TAG

# Lấy task definition hiện tại
aws ecs describe-task-definition --task-definition $TASK_FAMILY > task-def.json

# Update image trong task definition
cat task-def.json \
| jq --arg IMAGE "$ECR_URL:$IMAGE_TAG" --arg NAME "$CONTAINER_NAME" \
  '.taskDefinition.containerDefinitions |= map(if .name == $NAME then .image = $IMAGE else . end)
   | {family: .taskDefinition.family, containerDefinitions, executionRoleArn: .taskDefinition.executionRoleArn, taskRoleArn: .taskDefinition.taskRoleArn, networkMode: .taskDefinition.networkMode, requiresCompatibilities: .taskDefinition.requiresCompatibilities, cpu: .taskDefinition.cpu, memory: .taskDefinition.memory}' \
> new-task-def.json

# Đăng ký revision mới
aws ecs register-task-definition --cli-input-json file://new-task-def.json > register-task.json

NEW_REVISION=$(cat register-task.json | jq -r '.taskDefinition.revision')

# Update ECS service
aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --task-definition $TASK_FAMILY:$NEW_REVISION

echo "Đã deploy thành công revision $NEW_REVISION cho service $SERVICE_NAME"