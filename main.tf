locals {
  start = [22, 80, 443, 8040] # from_ports
  end   = [22, 80, 443, 8092] # to_ports
}

resource "aws_security_group" "artifactory_server" {
  name = "Artifactory Security Group"

  vpc_id = data.aws_vpc.default.id

  dynamic "ingress" {

    for_each = local.start
    content {
      from_port   = ingress.value
      to_port     = element(local.end, index(local.start,ingress.value))
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} SecurityGroup" })

}

# creating EC2 instance with Artifactory
resource "aws_instance" "artifactory_server" {
  ami                         = "ami-0affd4508a5d2481b"
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.artifactory_server.id]
  monitoring                  = var.enable_detailed_monitoring
  key_name                    = "aws_adhoc"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20           
  }
  associate_public_ip_address = true
  
    provisioner "file" {
      source      = "${path.module}/passwd-s3fs"
      destination = "passwd-s3fs"
 
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.artifactory_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

    provisioner "file" {
      source      = "${path.module}/packages.sh"
      destination = "packages.sh"
      
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.artifactory_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 
    } 

   provisioner "remote-exec" {
      connection {
         type        = "ssh"
         user        = "centos"
         host        = "${element(aws_instance.artifactory_server.*.public_ip, 0)}"
         private_key = "${file("~/.ssh/aws_adhoc.pem")}"      
      } 

    inline = [
      "sudo chmod 0600 passwd-s3fs",
      "sudo mv passwd-s3fs /etc/passwd-s3fs",
      "sudo chown root:root /etc/passwd-s3fs",
      "chmod +x packages.sh",
      "./packages.sh"
    ]
  }

  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server" })

}

resource "aws_eip" "artifactory_static_ip" {
  instance = aws_instance.artifactory_server.id
  tags = merge(var.common_tags, { Name = "${var.common_tags["Purpose"]} Server IP" })
}