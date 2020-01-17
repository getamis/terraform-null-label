locals {
  defaults = {
    label_order = [
      "Environment",
      "Project",
      "Name",
      "Service",
      "Role",
      "Language",
      "Crypto",
      "BuiltWith",
      "CreatedBy"
    ]
    delimiter   = "-"
    replacement = ""
    # The `sentinel` should match the `regex_replace_chars`, so it will be replaced with the `replacement` value
    sentinel   = "~"
    attributes = [""]    
  }

  # The values provided by variables superceed the values inherited from the context

  enabled             = var.enabled
  regex_replace_chars = coalesce(var.regex_replace_chars, var.context.regex_replace_chars)  

  Environment = lower(replace(coalesce(var.Environment, var.context.Environment,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  Project     = lower(replace(coalesce(var.Project, var.context.Project,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  Service     = lower(replace(coalesce(var.Service, var.context.Service,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  Role        = lower(replace(coalesce(var.Role, var.context.Role,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  Language    = lower(replace(coalesce(var.Language, var.context.Language,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  Crypto      = lower(replace(coalesce(var.Crypto, var.context.Crypto,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  BuiltWith   = lower(replace(coalesce(var.BuiltWith, var.context.BuiltWith,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))
  CreatedBy   = lower(replace(coalesce(var.CreatedBy, var.context.CreatedBy,  local.defaults.sentinel), local.regex_replace_chars, local.defaults.replacement))

  delimiter          = coalesce(var.delimiter, var.context.delimiter, local.defaults.delimiter)
  label_order        = length(var.label_order) > 0 ? var.label_order : (length(var.context.label_order) > 0 ? var.context.label_order : local.defaults.label_order)
  additional_tag_map = merge(var.context.additional_tag_map, var.additional_tag_map)

  # Merge attributes
  attributes = compact(distinct(concat(var.attributes, var.context.attributes, local.defaults.attributes)))

  tags = merge(var.context.tags, local.generated_tags, var.tags)

  tags_as_list_of_maps = flatten([
    for key in keys(local.tags) : merge(
      {
        key   = key
        value = local.tags[key]
    }, var.additional_tag_map)
  ])

  tags_context = {
    # For AWS we need `Name` to be disambiguated sine it has a special meaning
    Environment = local.Environment
    Project     = local.Project
    Name        = local.id
    Service     = local.Service
    Role        = local.Role
    Language    = local.Language
    Crypto      = local.Crypto
    BuiltWith   = local.BuiltWith
    CreatedBy   = local.CreatedBy
    attributes  = local.attributes
  }

  generated_tags = { for l in keys(local.tags_context) : title(l) => local.tags_context[l] if length(local.tags_context[l]) > 0 }

  id = lower(join(local.delimiter, list(local.Environment, local.Project, local.Service)))
}

