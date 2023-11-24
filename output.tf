output "public_ip" {
    value = aws_instance.my_ec2.public_ip
    description = "Displays public IP"
}

output "privater_ip" {
description = "Displays private IP"
value = aws_instance.my_ec2.private_ip
}
