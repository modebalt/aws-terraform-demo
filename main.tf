provider "aws" {
  region = "eu-west-1"
}
module "api_lampda" {
  source              = "./modules/lambda"
  handler             = "main"
  function_name       = "lambda_api_example"
  path_to_source_code = "${path.cwd}/code/api"
  path_to_zipped_code = "${path.cwd}/code/api/compiled.zip"
  env_variables = {
    "SQS_QUEUE_URL" = aws_sqs_queue.lambda_example_queue.id
  }
  security_group_ids = [aws_security_group.lambda.id]
  subnet_ids         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  role_arn           = aws_iam_role.lambda_execution_role.arn
}
module "sqs_lambda" {
  source              = "./modules/lambda"
  handler             = "main"
  function_name       = "lambda_sqs_example"
  path_to_source_code = "${path.cwd}/code/sqs"
  path_to_zipped_code = "${path.cwd}/code/sqs/compiled.zip"
  env_variables = {
    "SNS_TOPIC_ARN" = aws_sns_topic.sns.arn
  }
  security_group_ids = [aws_security_group.lambda.id]
  subnet_ids         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  role_arn           = aws_iam_role.lambda_execution_role.arn #TODO create separate roles per lambda
}
