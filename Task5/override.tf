variable "awsstuff" {
  type = map(any)
  default = {
    aws_account_id         = "1234567890"
    is_aws_account_trusted = false
    aws_access_key_id      = "ACCCESSSSSSSSSSSS"
    aws_secret_key         = "SECRETTTTKEYYYYYYYYYY"
  }
}
