data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_vpc" "default" {}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
#  ami_id = "ami-01cc34ab2709337aa"
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_route53_zone" "link" {
  name         = "tchaikovski.link."
  private_zone = false
}
