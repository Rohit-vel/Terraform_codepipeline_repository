variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Terraform pipeline only support us-east-1"
}


variable "ami_id" {
  type        = string
  description = "This ID is supported only in US_EAST_1 region"
}


variable "instance_type" {
  type = string
}

variable "repository_name" {
  type        = string
  description = "This is codecommit repository"
}


variable "codedeploy_role_policy_arn" {
  type        = string
  description = "This is policy arn of CodeDeploy Role"
}

variable "applicatiin_name" {
  type        = string
  description = "This is application of code deploy"
}

variable "deployment_group" {
  type        = string
  description = "This is delpoyment group of deployment application"
}

