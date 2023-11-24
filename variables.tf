variable "region" {
default = "us-west-2"
}
variable "availability-zone" {
default = "us-west-2a"
}
//SSM agent is pre-installed on Amazon Linux 2 and Amazon Linux AN
variable "ami" {
default = "ami-00ee4df451840fa9d"
}
variable "instance-type" {
default = "t2.micro"
}
variable  "key" {
default = "my-key"
}

variable "vpc-cidr" {
default = "10.10.0.0/16"
}
variable "vpc-subnet-cidr" {
default = "10.10.1.0/24"
}
