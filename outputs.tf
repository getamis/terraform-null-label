output "id" {
  description = "Disambiguated ID"
  value       = local.enabled ? local.id : ""
}

output "BuiltWith" {
  description = "Normalized BuiltWith"
  value       = local.enabled ? local.BuiltWith : ""
}

output "CreatedBy" {
  description = "Normalized CreatedBy"
  value       = local.enabled ? local.CreatedBy : ""
}

output "Crypto" {
  description = "Normalized Crypto"
  value       = local.enabled ? local.Crypto : ""
}

output "Environment" {
  description = "Normalized Environment"
  value       = local.enabled ? local.Environment : ""
}

output "Language" {
  description = "Normalized Language"
  value       = local.enabled ? local.Language : ""
}

output "Project" {
  description = "Normalized Project"
  value       = local.enabled ? local.Project : ""
}

output "Service" {
  description = "Normalized Service"
  value       = local.enabled ? local.Service : ""
}

output "attributes" {
  description = "List of attributes"
  value       = local.enabled ? local.attributes : []
}

output "delimiter" {
  description = "Delimiter between `namespace`, `environment`, `stage`, `name` and `attributes`"
  value       = local.enabled ? local.delimiter : ""
}

output "tags" {
  description = "Normalized Tag map"
  value       = local.enabled ? local.tags : {}
}

output "tags_as_list_of_maps" {
  description = "Additional tags as a list of maps, which can be used in several AWS resources"
  value       = local.tags_as_list_of_maps
}

output "label_order" {
  description = "The naming order of the id output and Name tag"
  value       = local.label_order
}
