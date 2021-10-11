variable "region" {
  description = "aws region"
  type = string
  default = "ap-southeast-1"
}

variable "container_port" {
  description = "port used by container application"
  type = number
  default = 3000
}

variable "container_image_name" {
  description = "name of container image"
  type = string
} 

variable "app_version" {
  description = "application version (uses github commit hash)"
  type = string
}
