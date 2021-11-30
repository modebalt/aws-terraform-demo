variable "function_name" {
  type        = string
  description = "Lambda function name"
}
variable "path_to_source_code" {
  type        = string
  description = "Path to source code"
}
variable "path_to_zipped_code" {
  type        = string
  description = "Path to zipped code"
}
variable "security_group_ids" {
  type        = list(string)
  description = "List of security groups"
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets"
}
variable "env_variables" {
  type        = map(string)
  description = "Map of environment variables"
}
variable "handler" {
  type        = string
  description = "Function handler"
}
variable "role_arn" {
  type = string
  description = "Lambda execution role arn"
}