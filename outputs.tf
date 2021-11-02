output "artifactory_server_ip" {
  value = aws_eip.artifactory_static_ip.public_ip
}

output "jfrog_instance_id" {
  value = aws_instance.artifactory_server.id
}

output "jfrog_sg_id" {
  value = aws_security_group.artifactory_server.id
}

output "public-zone-id" {
  value = aws_route53_record.artifactory.id
}

/*
output "certificate_pem" {
  value = lookup(acme_certificate.certificate, "certificate_pem")
}

output "issuer_pem" {
  value = lookup(acme_certificate.certificate, "issuer_pem")
}

output "private_key_pem" {
  # careful here!! nonsensitive
  value = nonsensitive(lookup(acme_certificate.certificate, "private_key_pem"))
}
*/