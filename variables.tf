variable "warning" {
  type        = string
  description = "WARNING: the application password will be persisted to state. Type any value to continue."
}

variable "sp_name" {
  type = string
  description = "A name for the service principal. Will also be the name of the azure ad app (aka enterprise application)."
}

variable "sp_days" {
  type = number
  description = "the number of days for which the sp is valid"
  default = 30
}

