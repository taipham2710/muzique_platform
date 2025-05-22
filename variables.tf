variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  default     = "default"
  description = "AWS CLI profile"
}

variable "domain_name" {
  type        = string
  description = "Domain chính cho hệ thống"
}

variable "services" {
  type        = list(string)
  default     = ["frontend", "muzique-auth-service", "muzique-user-service", "muzique-task-service"]
  description = "Danh sách services ECS/ECR"
}

variable "ec2_key_name" {
  type        = string
  description = "Tên key pair EC2 để SSH"
}