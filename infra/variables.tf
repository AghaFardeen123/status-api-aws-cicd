variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Name of an existing EC2 key pair in your AWS account"
}

variable "admin_cidr" {
  type        = string
  description = "Your IP in CIDR form, for SSH access (e.g. 203.0.113.4/32)"
}

variable "app_name" {
  type    = string
  default = "status-api"
}

variable "domain_name" {
  type        = string
  description = "Domain that will point to the instance, used for SSL cert issuance"
}

variable "certbot_email" {
  type        = string
  description = "Email used for Let's Encrypt certificate registration"
}
