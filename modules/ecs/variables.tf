variable "cluster_name" {
  type    = string
  default = "muzique-cluster"
}
variable "services" {
  type = list(string)
}
variable "ecr_repos" {
  type = map(string)
}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_ids" {
  type = list(string)
}
variable "task_role_arn" {
  type = string
}
variable "execution_role_arn" {
  type = string
}
variable "target_group_arns" {
  type = map(string)
}
variable "cpu" {
  type    = string
  default = "256"
}
variable "memory" {
  type    = string
  default = "512"
}
variable "container_port" {
  type    = number
  default = 80
}
variable "aws_region" {
  type = string
}
variable "desired_count" {
  type    = number
  default = 2
}