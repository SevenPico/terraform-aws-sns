variable "pub_principals" {
  type    = map(any)
  default = {}
}

variable "sub_principals" {
  type    = map(any)
  default = {}
}

variable "kms_master_key_id" {
  type = string
  default = ""
}
