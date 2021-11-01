resource "aws_route53_record" "artifactory" {
  zone_id = data.aws_route53_zone.link.zone_id
  name    = var.host_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.artifactory_static_ip.public_ip]
}