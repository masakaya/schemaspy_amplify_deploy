variable "github_oidc_domain" {
   type= string
   default = "token.actions.githubusercontent.com"
   description = "Github oidc domein"
}

variable "role_name" {
  type        = string
  description = "The name of the role"
}

variable "repo" {
  type        = list(string)
  description = <<EOT
GitHub repository to allow Assume for this role.
EOT
}
