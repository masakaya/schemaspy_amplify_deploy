module github_oidc_action_role {
  source = "../module/iam/github_action_oidc_role"
  role_name = "github-actions"
  repo = [ "masakaya/schemaspy_amplify_deploy" ]
}
