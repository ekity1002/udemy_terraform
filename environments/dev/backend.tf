terraform {
  backend "s3" {
    bucket                  = "udemy-tera"
    key                     = "dev/terraform.tfstate"
    region                  = "ap-northeast-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "tera"
  }
}
