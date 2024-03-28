variable "subnet_id" {
    description = "The VPC subnet the instance will be created in"
    default = "subnet-<add_number>" #refer to the AWS console for your default subnet
}

variable "vpc_id" {
    type = string
    default = "vpc-<add_number>" #refer to the AWS console for your default VPC
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "key_name" {
    type = string
    default = "<add_name>" #refer to the AWS console for your key name
}
