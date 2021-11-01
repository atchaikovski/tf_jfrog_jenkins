
variable "region" {
  description = "AWS Region to deploy Server in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "c3.large"
}

variable "allowed_ports" {
  description = "List of Ports to open"
  type        = list
  default     = ["80", "443", "22", "8000", "8081", "8082"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}

variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map
  default = {
    Owner       = "Alex Tchaikovski"
    Project     = "Jenkins + JFrog"
    Purpose     = "Artifactory"
  }
}

variable "domain_tchaikovski_link" {
  default = "tchaikovski.link"
}

variable "host_name" {
  type = string
  default = "jfrog"
}