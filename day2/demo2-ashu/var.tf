variable "az_subs" {
    type = string
    sensitive = true
  
}

variable "resg_name" {
    type = string
  
}

variable "resg_location" {
    type = string
  
}

variable "azvnet_name" {
    type = string
  
}

variable "azvnet_addr" {
    type = string
  
}

variable "azvm_name" {
  type = string
}

variable "azvm_user" {
    type = string
    sensitive = true
  
}

variable "azvm_ssh_key" {
    type = string
    sensitive = true
  
}

