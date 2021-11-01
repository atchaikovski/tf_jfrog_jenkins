region                     = "us-east-1"
instance_type              = "c3.large"
enable_detailed_monitoring = true

#allowed_ports = ["80", "443", "8000-8100"]

common_tags = {
  Owner       = "Alex Tchaikovski"
  Project     = "Jenkins + JFrog"
  Purpose     = "Artifactory"
}

host_name = "jfrog"