resource "azurerm_public_ip" "this" {
  name                    = var.name
  resource_group_name     = var.resource_group_name
  location                = var.location
  allocation_method       = var.allocation_method
  zones                   = var.zones
  ddos_protection_mode    = var.ddos_protection_mode
  ddos_protection_plan_id = var.ddos_protection_plan_id
  domain_name_label       = var.domain_name_label
  edge_zone               = var.edge_zone
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  ip_tags                 = var.ip_tags
  ip_version              = var.ip_version
  public_ip_prefix_id     = var.public_ip_prefix_id
  reverse_fqdn            = var.reverse_fqdn
  sku                     = var.sku
  sku_tier                = var.sku_tier
  tags                    = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }

}

resource "azurerm_management_lock" "pub_ip_lock" {
  count      = var.lock.lock_level != "CanNotDelete" ? 1 : 0
  name       = var.lock.name
  scope      = azurerm_public_ip.this.id
  lock_level = var.lock.lock_level
  notes      = var.lock.notes
}

resource "azurerm_role_assignment" "public_ip_address" {
  for_each = var.role_assignments != null ? var.role_assignments : {}

  scope                                  = azurerm_public_ip.this.id
  role_definition_id                     = each.value.role_definition_id
  role_definition_name                   = each.value.role_definition_name
  principal_id                           = each.value.principal_id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings != null ? var.diagnostic_settings : {}

  name                           = each.value.name
  target_resource_id             = azurerm_public_ip.this.id
  eventhub_name                  = each.value.eventhub_name
  eventhub_authorization_rule_id = each.value.eventhub_authorization_rule_id
  log_analytics_workspace_id     = each.value.log_analytics_workspace_id
  log_analytics_destination_type = each.value.log_analytics_destination_type
  storage_account_id             = each.value.storage_account_id
  partner_solution_id            = each.value.partner_solution_id

  dynamic "enabled_log" {
    for_each = each.value.enabled_log != null ? each.value.enabled_log : []
    content {
      category       = enabled_log.value.category_group == null ? enabled_log.value.category : null
      category_group = enabled_log.value.category_group
    }
  }

  dynamic "metric" {
    for_each = each.value.metric != null ? [each.value.metric] : []
    content {
      category = metric.value.category
      enabled  = metric.value.enabled
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}
