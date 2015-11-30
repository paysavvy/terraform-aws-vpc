variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}
variable "aws_nat_ami" {
	default = "ami-030f4133"
}
variable "aws_ubuntu_ami" {
	default = "ami-d5c5d1e5"
}
variable "containers_ami" {
  default = "ami-c188b0f1"
}
variable "ecs_instance_role" {
  default = "arn:aws:iam::646783328994:role/ecsInstanceRole"
}
variable "ecs_service_role" {
  default = "arn:aws:iam::646783328994:role/ecsServiceRole"
}
variable "environment" {
  default = "staging"
}