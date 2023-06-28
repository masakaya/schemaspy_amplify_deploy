resource "aws_amplify_app" "this" {
  name       = "schemaspy"

  # build settings
  enable_branch_auto_build = false

  enable_basic_auth     = false
  environment_variables = {}

  custom_rule {
    source = "/<*>"
    status = "404-200"
    target = "/index.html"
  }

}

resource "aws_amplify_branch" "this" {
  app_id = aws_amplify_app.this.id
  branch_name = "main"
}


# resource "aws_iam_role" "amplify_service_role" {
#   name               = "AmplifySSRLoggingRole"
#   path               = "/service-role/"
#   assume_role_policy = data.aws_iam_policy_document.allow_delegate_access_from_amplify.json
# }

# data "aws_iam_policy_document" "allow_delegate_access_from_amplify" {
#   statement {
#     effect  = "Allow"
#     actions = ["sts:AssumeRole"]
#     principals {
#       type        = "Service"
#       identifiers = ["amplify.amazonaws.com"]
#     }
#   }
# }
