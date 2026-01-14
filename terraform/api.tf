resource "aws_apigatewayv2_api" "api" {
  name          = "daily-finance-api-${var.env}"
  protocol_type = "HTTP"
}

resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/apigateway/daily-finance-${var.env}"
  retention_in_days = 30
}
resource "aws_apigatewayv2_integration" "create" {
  api_id                 = aws_apigatewayv2_api.api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.create_transaction.invoke_arn
  payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "post_tx" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "POST /transactions"
  target    = "integrations/${aws_apigatewayv2_integration.create.id}"
}
resource "aws_apigatewayv2_integration" "list" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.list_transactions.invoke_arn
}

resource "aws_apigatewayv2_route" "get_tx" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /transactions"
  target    = "integrations/${aws_apigatewayv2_integration.list.id}"
}
resource "aws_apigatewayv2_integration" "delete" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.delete_transaction.invoke_arn
}

resource "aws_apigatewayv2_route" "delete_tx" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "DELETE /transactions/{sk}"
  target    = "integrations/${aws_apigatewayv2_integration.delete.id}"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn
    format          = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}
resource "aws_lambda_permission" "api" {
  for_each = {
    create = aws_lambda_function.create_transaction.function_name
    list   = aws_lambda_function.list_transactions.function_name
    delete = aws_lambda_function.delete_transaction.function_name
  }

  statement_id = "AllowInvoke-${each.key}-${var.env}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
