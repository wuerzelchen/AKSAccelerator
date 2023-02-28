# variable for acr name
variable "acr_name" {
  type = string
}

variable "aad_rbac_enabled" {
  type    = bool
  default = true
}

variable "aad_admin_group_object_ids" {
  description = "object ids of the AAD groups to be added as cluster admin"
  type        = list(string)
}
