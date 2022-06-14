#  use this override.tf to put in confidential data


#  Populate values based on your AWS values
variable "awsstuff" {
  type = object({
    aws_account_id    = string
    aws_access_key_id = string
    aws_secret_key    = string
  })
  default = {
    aws_account_id    = "12345678" #Enter your account ID
    aws_access_key_id = "acccesssssssssss" # Enter your access key id
    aws_secret_key    = "secrettttttttttttttttttttt" # Enter your secret key
  }
}



#  Populate values based on your ND cofigiration
variable "creds" {
  type = map(any)
  default = {
    username = "CLUS-userXX"      # XX is your user ID
    password = "CLUS-userXX-123!" # XX is your user ID
    url      = "https://198.19.202.12/"

  }
}



variable "tenant_stuff" {
  type = object({
    tenant_name  = string
    display_name = string
    description  = string
  })
  default = {
    tenant_name  = "Cisco_Live_TENANT_XX" # change XX to your assigned user name 
    display_name = "Ciso_Live_TENANT_XX" # change XX to your assigned user name 
    description  = " Terraform Created Tenant for user XX" # change XX to your assigned user name 
  }
}
