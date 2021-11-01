#output "artifactory_server_ip" {
#  value = aws_eip.jfrog_static_ip.public_ip
#}

output "jfrog_instance_id" {
  value = aws_instance.artifactory_server.id
}

output "jfrog_sg_id" {
  value = aws_security_group.artifactory_server.id
}

output "tchaikovski-public-zone-id" {
  value = "Z05468452AW2YM7B8G3IP"
}
