provider "aws" {
    region = "us-east-1"

    endpoints {
    s3 = "https://s3.us-east-1.amazonaws.com"
  }
}