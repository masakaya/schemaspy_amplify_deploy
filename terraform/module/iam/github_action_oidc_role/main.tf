locals {
  # NOTE: jsonencode() is required to avoid "The true and false result expressions must have consistent types."
  condition_block = jsonencode({
    "StringLike" : {
      "${var.github_oidc_domain}:aud" : ["sts.amazonaws.com"],
      "${var.github_oidc_domain}:sub" : [
        for repo_pattern in var.repo : "repo:${repo_pattern}:*"
      ]
    }
  })
}

# IAM Role
resource "aws_iam_role" "github_actoins" {
  name               =  var.role_name
  description        = "GitHub Actions"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : [aws_iam_openid_connect_provider.github.arn]
        },
        "Condition" : jsondecode(local.condition_block),
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions1" {
  role       = aws_iam_role.github_actoins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy" "sts" {
  name   = "stspolicy"
  role   = aws_iam_role.github_actoins.name
  policy = data.aws_iam_policy_document.sts.json
}

data "aws_iam_policy_document" "sts" {
  statement {
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

# IdP
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://${var.github_oidc_domain}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}
