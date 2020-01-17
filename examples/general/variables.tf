variable "Crypto" {
  description = "Crypto, e.g. 'btc', 'eth', 'ltc'"
  type        = string
}

variable "Environment" {
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  type        = string
}

variable "Language" {
  description = "Language, e.g. 'rails', 'nodejs', 'golang'"
  type        = string
}

variable "Project" {
  description = "Project, e.g. 'max', 'maicoin', 'es'"
  type        = string
}

variable "Service" {
  description = "Service, e.g. 'frontend', 'api', 'daemons'"
  type        = string
}