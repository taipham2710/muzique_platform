variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Tên EC2 key pair để SSH"
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "user_data_path" {
  type        = string
  description = "Đường dẫn file user data"
}