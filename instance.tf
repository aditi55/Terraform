resource "aws_instance" "my_ec2" {
ami = var.ami
instance_type = var.instance-type
subnet_id = aws_subnet.my_subnet.id
vpc_security_group_ids = [aws_security_group.my-SG.id]
associate_public_ip_address = true
iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
tags = {
Name ="my-ec2-instance"
}
}

//Create VPC
 resource "aws_vpc" "my_vpc" {
cidr_block = var.vpc-cidr
tags = {
Name ="Terrafrom-VPC"
}
}

//Create subnet resource
resource "aws_subnet" "my_subnet" {
vpc_id = aws_vpc.my_vpc.id
cidr_block = var.vpc-subnet-cidr
availability_zone = var.availability-zone
map_public_ip_on_launch = true
tags = {
Name = "Terraform-VPC-subnet"
}
}

//Create aws_internet_gateway
resource "aws_internet_gateway" "my_IG" {
vpc_id = aws_vpc.my_vpc.id
tags = {
    Name = "Terraform-internet-gateway"
}
}

//Create Route Table
resource "aws_route_table" "my_route_table" {
vpc_id= aws_vpc.my_vpc.id
route {
cidr_block= "10.0.1.0/24"
gateway_id = aws_internet_gateway.my_IG.id 
}
tags = {
Name="Terraform-rt"
}
}

//Subnet association
resource "aws_route_table_association" "a" {
subnet_id = aws_subnet.my_subnet.id
route_table_id = aws_route_table.my_route_table.id 
}


//Security Group
resource "aws_security_group" "my-SG" {
name ="vpc-security-group"
vpc_id = aws_vpc.my_vpc.id
ingress {
    description      = "Inbound traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.my_vpc.cidr_block]
    ipv6_cidr_blocks = [aws_vpc.my_vpc.ipv6_cidr_block]
  }

  egress {
    description = "Allow HTTPS outbound traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terraform-vpc-sg"
  }
}

resource "aws_ebs_volume" "my_EBS_volume" {
availability_zone = var.availability-zone
size= 1
throughput = 200
encrypted = true
tags = {
Name = "Terraform-EBS"
}
}

resource "aws_volume_attachment" "ebs_attach" {
device_name = "dev/sdh"
volume_id = aws_ebs_volume.my_EBS_volume.id
instance_id = aws_instance.my_ec2.id
}
//SSM ACTIVATION
# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
name = "EC2_SSM_Role"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Effect = "Allow"
Principal = {
Service = "ec2.amazonaws.com"
Action = "sts:AssumeRole"
}},
]})
}

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedinstanceCore"
role = aws_iam_role.ec2_role.name
}

# Create an instance profile for the EC2 instance and associate the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
name = "EC2_SSM_Instance_Profile"
role = aws_iam_role.ec2_role.name
}