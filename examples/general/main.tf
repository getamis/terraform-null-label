module "general" {
  source  = "../../"

  crypto      = var.crypto
  environment = var.environment
  language    = var.language
  name        = var.name
  project     = var.project
  service     = var.service
}