resource "aws_amplify_app" "frontend" {
  name         = "daily-finance-frontend-${var.env}"
  repository   = var.github_repo
  access_token = var.github_token

  build_spec = <<EOF
version: 1
frontend:
  phases:
    preBuild:
      commands:
        - echo "Setting API URL"
    build:
      commands:
        - echo "window.API_URL = '${API_URL}';" > frontend/javascript/config.js
  artifacts:
    baseDirectory: frontend
    files:
      - '**/*'
  cache:
    paths: []
EOF

  environment_variables = {
    API_URL = aws_apigatewayv2_api.api.api_endpoint
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = "main"
  stage       = var.env == "prod" ? "PRODUCTION" : "DEVELOPMENT"

  enable_auto_build = true
}