output "invoke_arn" {
  value = aws_lambda_function.default.invoke_arn
  description = "Lambda function invoke arn"
}
output "function_name" {
  value = aws_lambda_function.default.function_name
  description = "Lambda function name"
}
output "arn" {
  value = aws_lambda_function.default.arn
  description = "Lambda function arn"
}
