variable "aws_region" {
  type        = string
  default     = "ap-southeast-1"
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
  default     = ["frontend", "auth-service", "user-service", "task-service"]
  description = "Danh sách services ECS/ECR"
}