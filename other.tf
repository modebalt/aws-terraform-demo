resource "aws_sqs_queue" "lambda_example_queue" {
  name = "lambda-example-queue"
}
resource "aws_sns_topic" "sns" {
  name = "messages"
}