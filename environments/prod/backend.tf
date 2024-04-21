terraform {
  backend "s3" {
    bucket                  = "udemy-tera"
    key                     = "prod/terraform.tfstate"
    region                  = "ap-northeast-1"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "tera"
  }
}
