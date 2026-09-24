# Configure Amazon S3 as the remote Terraform state backend
terraform {
  backend "s3" {
    # S3 bucket where Terraform will store the state
    bucket = "ketan-terraform-state-1790140692"

    # Path of the Terraform state file inside the S3 bucket
    key = "01-local-state/terraform.tfstate"

    # AWS region where the S3 bucket exists
    region = "eu-north-1"

    # Enable S3-native state locking
    use_lockfile = true
  }
}