variable "region_name" {
    default = "uksouth"
}

variable "env_tag" {
    default = "Dev"
}

variable "vnet_cidr" {
    default = "192.168.0.0/16"
}

variable "subnet_names" {
    default = ["web-1","web-2","app-1","app-2","db-1","db-2"]
}

variable "subscription_id" {
    default =  "af70c76d-f0af-4160-8348-76de8ce3a43a"
}

variable "vm_username" {
    default = "azureuser"
}

variable "vm_userpassword" {
    default = "Azureuser*12"
}

variable "build_id" {
    default = "1"
}

