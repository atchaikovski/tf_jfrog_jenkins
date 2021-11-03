region                     = "us-east-1"
instance_type              = "t2.medium"
enable_detailed_monitoring = true

common_tags = {
  Owner       = "Alex Tchaikovski"
  Project     = "Jenkins+JFrog"
  Purpose     = "Learning"
}

host_name = "jfrog"