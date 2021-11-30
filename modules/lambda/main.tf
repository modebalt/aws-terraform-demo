resource "aws_lambda_function" "default" {
  function_name    = var.function_name
  filename         = var.path_to_zipped_code
  source_code_hash = data.archive_file.api_lambda_package.output_base64sha256
  handler          = var.handler
  publish          = "true"
  role             = var.role_arn
  runtime          = "go1.x"
  memory_size      = 128
  timeout          = 10
  vpc_config {
    subnet_ids         = var.subnet_ids # TODO make vpc config dynamic or check if list is not empty
    security_group_ids = var.security_group_ids
  }
  environment {
    variables = var.env_variables
  }

  depends_on = [
    aws_cloudwatch_log_group.api_lambda,
  ]
}

data "archive_file" "api_lambda_package" {
  type        = "zip"
  source_file = "${var.path_to_source_code}/main"
  output_path = var.path_to_zipped_code
  depends_on = [
    null_resource.go
  ]
}

resource "aws_cloudwatch_log_group" "api_lambda" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}

resource "null_resource" "go" {
  provisioner "local-exec" {
    command = "cd ${var.path_to_source_code} && GOOS=linux CGO_ENABLED=0 go build main.go"
  }
  triggers = {
    file = sha1(file("${var.path_to_source_code}/main.go"))
  }
}