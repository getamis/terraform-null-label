variable "crypto" {
  description = "crypto, e.g. 'btc', 'eth', 'ltc'"
  type        = string
}

variable "environment" {
  description = "environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  type        = string
}

variable "language" {
  description = "language, e.g. 'rails', 'nodejs', 'golang'"
  type        = string
}

variable "name" {
  description = "name, e.g."
  type        = string
}

variable "project" {
  description = "project, e.g. 'max', 'maicoin', 'es'"
  type        = string
}

variable "service" {
  description = "service, e.g. 'frontend', 'api', 'daemons'"
  type        = string
}