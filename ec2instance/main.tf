provider "aws" {
 region="ap-south-1"
access_key = "AKIAW3DR5PN46IVCTWFF"
  secret_key = "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"
}
resource "aws_instance" "myec2" {
ami= "ami-0d81306eddc614a45"
instance_type= "t2.small"
vpc_security_group_ids=[aws_security_group.ownsg.id]
key_name = "tf-key-pair"
tags={
 Name="terraform-example"
}
}
resource "aws_security_group" "ownsg" {
 name="own-sg"
ingress {
 from_port=80
 to_port=80
protocol="tcp"
cidr_blocks=["0.0.0.0/0"]
}
ingress {
 from_port=22
 to_port=22
protocol="tcp"
cidr_blocks=["0.0.0.0/0"]
}
egress {
 from_port=0
 to_port=0
protocol="-1"
cidr_blocks=["0.0.0.0/0"]
}


}
resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}
