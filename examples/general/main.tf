module "general" {
  source  = "../../"

  Crypto = var.Crypto
  Environment = var.Environment
  Language = var.Language
  Project = var.Project
  Service = var.Service
}