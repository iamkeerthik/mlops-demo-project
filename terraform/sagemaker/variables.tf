variable "env" {
  type = string
}

variable "region" {
  type    = string
  default = "ap-south-1"
}


variable "tags" {
  type    = map(string)
  default = {}
}