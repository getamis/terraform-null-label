module "general" {
  source  = "../../"

  crypto      = var.crypto
  environment = var.environment
  language    = var.language
  project     = var.project
  service     = var.service
}