variable "services" {
  type        = list(string)
  description = "Danh sách tên service"
}
variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Số ngày giữ log"
}