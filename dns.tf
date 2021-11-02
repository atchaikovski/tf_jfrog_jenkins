resource "aws_route53_record" "artifactory" {
  zone_id = data.aws_route53_zone.link.zone_id
  name    = var.host_name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.artifactory_static_ip.public_ip]
}

/*
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "alex@tchaikovski.net" 
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = data.aws_route53_zone.link.name
  subject_alternative_names = ["*.${data.aws_route53_zone.link.name}"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.link.zone_id
    }
  }

  depends_on = [acme_registration.registration]
}

resource "aws_s3_bucket_object" "jfrog_certificates_s3" {
  for_each = toset(["certificate_pem", "issuer_pem", "private_key_pem"])

  bucket  = "tchaikovski-link-letsencrypt-certificates" 
  key     = "ssl-certs/${each.key}" 
  content = lookup(acme_certificate.certificate, "${each.key}")
}
*/