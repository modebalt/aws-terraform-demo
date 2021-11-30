resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.api_lampda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}
resource "aws_lambda_event_source_mapping" "sqs" {
  event_source_arn = aws_sqs_queue.lambda_example_queue.arn
  function_name    = module.sqs_lambda.arn
}
