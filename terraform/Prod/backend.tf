terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "prod/tf-state/terraform.tfstate"
    region       = "us-east-2"
    use_lockfile = true
  }
}