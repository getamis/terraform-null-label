variable "BuiltWith" {
  description = "BuiltWith, e.g. 'terraform'"
  type        = string
  default     = "terraform"
}

variable "CreatedBy" {
  description = "CreatedBy, e.g. 'jenkins', 'autoscaling'"
  type        = string
  default     = ""
}

variable "Crypto" {
  description = "Crypto, e.g. 'btc', 'eth', 'ltc'"
  type        = string
  default     = ""
}

variable "Environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  type        = string
  default     = ""
}

variable "Language" {
  description = "Language, e.g. 'rails', 'nodejs', 'golang'"
  type        = string
  default     = ""
}

variable "Project" {
  description = "Project, e.g. 'max', 'maicoin', 'es'"
  type        = string
  default     = ""
}

variable "Role" {
  description = "Role, e.g."
  type        = string
  default     = ""
}

variable "Service" {
  description = "Service, e.g. 'frontend', 'api', 'daemons'"
  type        = string
  default     = ""
}

variable "additional_tag_map" {
  description = "Additional tags for appending to each tag map"
  type        = map(string)
  default     = {}
}

variable "attributes" {
  description = "Additional attributes (e.g. `1`)"
  type        = list(string)
  default     = []
}

variable "context" {
  description = "Default context to use for passing state between label invocations"
  type = object({
    Environment         = string
    Project             = string
    Name                = string
    Service             = string
    Role                = string
    Language            = string
    Crypto              = string
    BuiltWith           = string
    CreatedBy           = string
    additional_tag_map  = map(string)
    attributes          = list(string)
    delimiter           = string
    enabled             = bool
    label_order         = list(string)
    regex_replace_chars = string
    tags                = map(string)
  })
  default = {
    Environment         = ""
    Project             = ""
    Name                = ""
    Service             = ""
    Role                = ""
    Language            = ""
    Crypto              = ""
    BuiltWith           = ""
    CreatedBy           = ""
    additional_tag_map  = {}
    attributes          = []
    delimiter           = ""
    enabled             = true
    label_order         = []
    regex_replace_chars = ""
    tags                = {}
  }
}

variable "delimiter" {
  description = "Delimiter to be used between `project`, `environment`, `name` and `attributes`"
  type        = string
  default     = "-"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "label_order" {
  description = "The naming order of the id output and Name tag"
  type        = list(string)
  default     = []
}

variable "regex_replace_chars" {
  description = "Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`. By default only hyphens, letters and digits are allowed, all other chars are removed"
  type        = string
  default     = "/[^a-zA-Z0-9-]/"
}

variable "tags" {
  description =  "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
  type        = map(string)
  default     = {}
}

