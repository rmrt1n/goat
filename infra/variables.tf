variable "region" {
  description = "aws region"
  type        = string
  default     = "ap-southeast-1"
}

variable "container_port" {
  description = "port used by container application"
  type        = number
  default     = 3000
}

variable "container_image_name" {
  description = "name of container image"
  type        = string
  default     = "goat-ecr"
}
