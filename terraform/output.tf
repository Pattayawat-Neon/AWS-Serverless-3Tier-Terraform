output "api_url" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

output "s3_website_url" {
  value = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}
