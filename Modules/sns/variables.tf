#Global variables
variable "region" {
  description = "AWS region where the SNS topic will be created"
  type        = string
}
variable "profile" {
  description = "AWS profile used to suscribe the emails to the SNS topic"
  type        = string
}

# SNS
variable "sns_topic_name" {
  description = "SNS topic name"
  type        = string
}
variable "sns_subscription_emails" {
  description = "Email list of suscribers (space separated)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Implements the common_tags scheme"
  type        = map(string)
}