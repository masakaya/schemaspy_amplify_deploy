terraform {
  # 初回実行時はコメントアウトして、bucket、role作成後に解除する
  backend "s3" {
    bucket   = "amplify-terraform-backend"
    key      = "common"
    region   = "ap-northeast-1"
    # MyAccount
    role_arn = "arn:aws:iam::121936954111:role/terraform-backend-access"
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      Environment = "Production"
      Owner       = "masashi.kayahara"
      Project     = "ProjectName"
    }
  }
  # 初回実行時はコメントアウトして、bucket、role作成後に解除する
  assume_role {
    role_arn = "arn:aws:iam::121936954111:role/TerraformExecutionRole"
  }
}

data "aws_caller_identity" "current" {}
