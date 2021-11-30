resource "aws_security_group" "lambda" { #TODO create separate sgs lambda only allow outgoing, vpc endpoint only allow ingress from lambda sg
  name        = "Lambda_sg"
  description = "Lambda security group"
  vpc_id      = aws_default_vpc.default.id
  ingress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "for all incoming traffic"
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  ]
  egress = [
    {
      description      = "for all outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = aws_default_vpc.default.id
  service_name        = "com.amazonaws.eu-west-1.sqs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.lambda.id]
  subnet_ids          = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  private_dns_enabled = true
}
resource "aws_vpc_endpoint" "sns" {
  vpc_id              = aws_default_vpc.default.id
  service_name        = "com.amazonaws.eu-west-1.sns"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.lambda.id]
  subnet_ids          = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  private_dns_enabled = true
}