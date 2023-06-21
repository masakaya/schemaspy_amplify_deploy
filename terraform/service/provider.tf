terraform {
  backend "s3" {
    bucket   = "amplify-terraform-backend"
    region   = "ap-northeast-1"
    key      = "service.terraform.tfstate"
    # MyAccount
    role_arn = "arn:aws:iam::121936954111:role/terraform-backend-access"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Production"
      Owner       = "masashi.kayahara"
      Project     = "amplify-sample"
    }
  }
  assume_role {
    role_arn = "arn:aws:iam::121936954111:role/TerraformExecutionRole"
  }
}
