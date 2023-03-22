variable "instance_size" {
   type = string
   description = "Azure instance size"
   default = "Standard_B4ms"
}

variable "location" {
   type = string
   description = "Region"
   default = "Canada Central"
}

variable "owner" {
   type = string
   description = "Group Owner"
   default = "Group C"
}

variable "project" {
   type = string
   description = "project namer"
   default = "Capstone 3384-2"
}
