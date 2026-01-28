variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS Session Token"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.small"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "vockey"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}
