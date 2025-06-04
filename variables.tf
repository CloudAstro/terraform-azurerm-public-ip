variable "name" {
  type        = string
  description = <<DESCRIPTION
  * `name` - (Required) Specifies the name of the Public IP. Changing this forces a new Public IP to be created.

  Example Input:
  ```
  name = "pip-example"
  ```
  DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
  * `resource_group_name` - (Required) The name of the Resource Group where this Public IP should exist. Changing this forces a new Public IP to be created

  Example Input:
  ```
  resource_group_name = "rg-pip-example"
  ```
  DESCRIPTION
}

variable "location" {
  type        = string
  description = <<DESCRIPTION
  * `location` - (Required) Specifies the supported Azure location where the Public IP should exist. Changing this forces a new resource to be created.

  Example Input:
  ```
  location = "ger-west-central"
  ```
  DESCRIPTION
}

variable "allocation_method" {
  type        = string
  description = <<DESCRIPTION
  * `allocation_method` - (Required) Defines the allocation method for this IP address. Possible values are `Static` or `Dynamic`.
  ~> **Note** `Dynamic` Public IP Addresses aren't allocated until they're assigned to a resource (such as a Virtual Machine or a Load Balancer) by design within Azure. See `ip_address` argument.

  Example Input:
  ```
  allocation_method = "Static"
  ```
  DESCRIPTION

  validation {
    condition     = contains(["Static", "Dynamic"], var.allocation_method)
    error_message = "Possible values are Static or Dynamic for the allocation_method variable"
  }
}

variable "zones" {
  type        = list(string)
  default     = null
  description = <<DESCRIPTION
  * `zones` - (Optional) A collection containing the availability zone to allocate the Public IP in. Changing this forces a new resource to be created.
  ~> **Note:** Availability Zones are only supported with a [Standard SKU](https://docs.microsoft.com/azure/virtual-network/virtual-network-ip-addresses-overview-arm#standard) and [in select regions](https://docs.microsoft.com/azure/availability-zones/az-overview) at this time. Standard SKU Public IP Addresses that do not specify a zone are **not** zone-redundant by default

  Example Input:
  ```
  zones = ["1", "2", "3"]
  ```
  DESCRIPTION
}

variable "ddos_protection_mode" {
  type        = string
  default     = "VirtualNetworkInherited"
  description = <<DESCRIPTION
  * `ddos_protection_mode` - (Optional) The DDoS protection mode of the public IP. Possible values are `Disabled`, `Enabled`, and `VirtualNetworkInherited`. Defaults to `VirtualNetworkInherited`.

  Example Input:
  ```
  ddos_protection_mode = "VirtualNetworkInherited"
  ```
  DESCRIPTION

}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `ddos_protection_plan_id` - (Optional) The ID of DDoS protection plan associated with the public IP.
  ~> **Note:** `ddos_protection_plan_id` can only be set when `ddos_protection_mode` is `Enabled`.

  Example Input:
  ```
  ddos_protection_plan_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Network/ddosProtectionPlans/myDdosPlan"
  ```
  DESCRIPTION
}

variable "domain_name_label" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `domain_name_label` - (Optional) Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

  Example Input:
  ```
  domain_name_label = "my-public-ip"
  ```
  DESCRIPTION
}

variable "edge_zone" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `edge_zone` - (Optional) Specifies the Edge Zone within the Azure Region where this Public IP should exist. Changing this forces a new Public IP to be created.

  Example Input:
  ```
  edge_zone = "edge-zone-1"
  ```
  DESCRIPTION
}

variable "idle_timeout_in_minutes" {
  type        = number
  default     = 4
  description = <<DESCRIPTION
  * `idle_timeout_in_minutes` - (Optional)Specifies the timeout for the TCP idle connection. The value can be set between 4 and 30 minutes.

  Example Input:
  ```
  idle_timeout_in_minutes = 10
  ```
  DESCRIPTION

  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 30
    error_message = "idle_timeout_in_minutes must be between 4 and 30 minutes."
  }
}

variable "ip_tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
  * `ip_tags` - (Optional) A mapping of IP tags to assign to the public IP. Changing this forces a new resource to be created.
  ~> **Note** IP Tag `RoutingPreference` requires multiple `zones` and `Standard` SKU to be set.
  Example Input:
  ```
  ip_tags = {
    name = "WebServerIP"
    environment = "Production"
    owner = "Your Name"
    }
  ```
  DESCRIPTION
}

variable "ip_version" {
  type        = string
  default     = "IPv4"
  description = <<DESCRIPTION
  * `ip_version` - (Optional) The IP Version to use, IPv6 or IPv4. Changing this forces a new resource to be created. Defaults to IPv4.
  ~> **Note** Only static IP address allocation is supported for IPv6.
  Example Input:
  ```
  ip_version = "IPv4"
  ```
  DESCRIPTION

  validation {
    condition     = var.ip_version == "IPv4" || var.ip_version == "IPv6"
    error_message = "ip_version must be either 'IPv4' or 'IPv6'."
  }
}

variable "public_ip_prefix_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `public_ip_prefix_id` - (Optional) If specified, then the public IP address allocated will be provided from the public IP prefix resource. Changing this forces a new resource to be created.

  Example Input:
  ```
  public_ip_prefix_id = "/subscriptions/{subscription-id}/resourceGroups/{resource-group}/providers/Microsoft.Network/publicIPPrefixes/{prefix-name}"
  ```
  DESCRIPTION
}

variable "reverse_fqdn" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `reverse_fqdn` - (Optional) A fully qualified domain name that resolves to this public IP address. If specified, a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

  Example Input:
  ```
  reverse_fqdn = "myapp.example.com"
  ```
  DESCRIPTION

}

variable "sku" {
  type        = string
  default     = "Standard"
  description = <<DESCRIPTION
  * `sku` - (Optional) The SKU of the Public IP. Accepted values are `Basic` and `Standard`. Defaults to `Standard`. Changing this forces a new resource to be created.
  ~> **Note** Public IP Standard SKUs require `allocation_method` to be set to `Static`.

  Example Input:
  ```
  sku = "Standard"
  ```
  DESCRIPTION

  validation {
    condition     = contains(["Basic", "Standard", "[null]"], coalesce(var.sku, "[null]"))
    error_message = "Possible values are Basic or Standard for the sku variable"
  }
}

variable "sku_tier" {
  type        = string
  default     = "Regional"
  description = <<DESCRIPTION
  * `sku_tier` - (Optional) The SKU Tier that should be used for the Public IP. Possible values are `Regional` and `Global`. Defaults to `Regional`. Changing this forces a new resource to be created.
  ~> **Note** When `sku_tier` is set to `Global`, `sku` must be set to `Standard`.

  Example Input:
  ```
  sku_tier = "Regional"
  ```
  DESCRIPTION

  validation {
    condition     = contains(["Regional", "Global", "[null]"], coalesce(var.sku_tier, "[null]"))
    error_message = "Possible values are Regional or Global for the sku_tier variable"
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = <<DESCRIPTION
  * `tags` - (Optional) A mapping of tags to assign to the resource.

  Example Input:
  ```
  tags = {
    environment = "production"
  }
  ```
  DESCRIPTION
}

variable "lock" {
  type = object({
    name       = optional(string)
    scope      = optional(string)
    lock_level = optional(string, "CanNotDelete")
    notes      = optional(string)
  })
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
  * `name` - (Required) Specifies the name of the Management Lock. Changing this forces a new resource to be created.
  * `scope` - (Required) Specifies the scope at which the Management Lock should be created. Changing this forces a new resource to be created.
  * `lock_level` - (Required) Specifies the Level to be used for this Lock. Possible values are `CanNotDelete` and `ReadOnly`. Changing this forces a new resource to be created.
  ~> **Note:** `CanNotDelete` means authorized users are able to read and modify the resources, but not delete. `ReadOnly` means authorized users can only read from a resource, but they can't modify or delete it.
  * `notes` - (Optional) Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created.

  Example Input:
  ```
  lock = {
    name = "example-lock"
    scope= azurerm_public_ip.this.id
    lock_level = "CanNotDelete"
  }
  ```
  DESCRIPTION

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock.lock_level)
    error_message = "The lock level must be one of:'CanNotDelete', or 'ReadOnly'."
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "30")
    read   = optional(string, "5")
    update = optional(string, "30")
    delete = optional(string, "30")
  })
  default     = null
  description = <<DESCRIPTION
  The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
    * `create` - (Defaults to 30 minutes) Used when creating the Public IP.
    * `read` - (Defaults to 5 minutes) Used when retrieving the Public IP.
    * `update` - (Defaults to 60 minutes) Used when updating the Public IP.
    * `delete` - (Defaults to 60 minutes) Used when deleting the Public IP.
DESCRIPTION
}

variable "role_assignments" {
  type = map(object({
    name                                   = optional(string)
    scope                                  = string
    role_definition_id                     = optional(string)
    role_definition_name                   = optional(string)
    principal_id                           = string
    principal_type                         = optional(string)
    description                            = optional(string)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string)
    condition_version                      = optional(string)
    delegated_managed_identity_resource_id = optional(string)
  }))
  default     = {}
  description = <<DESCRIPTION
  * `role assignments` - A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
   * `name` - (Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created.
   * `scope` - (Required) The scope at which the Role Assignment applies to, such as /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333, /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup, or /subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM, or /providers/Microsoft.Management/managementGroups/myMG. Changing this forces a new resource to be created.
   * `role_definition_id` - (Optional) The Scoped-ID of the Role Definition. Changing this forces a new resource to be created.
   * `role_definition_name` - - (Optional) The name of a built-in Role. Changing this forces a new resource to be created.
   ~> Note: Either role_definition_id or role_definition_name must be set.
   * `principal_id` - (Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created.
   ~> Note: The Principal ID is also known as the Object ID (i.e. not the "Application ID" for applications).
   * `principal_type` - (Optional) The type of the principal_id. Possible values are User, Group and ServicePrincipal. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.
   * `condition` - (Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created.
   * `condition_version` - (Optional) The version of the condition. Possible values are 1.0 or 2.0. Changing this forces a new resource to be created.
   ~> Note: condition is required when condition_version is set.
   * `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.
   ~> Note: This field is only used in cross tenant scenarios.
   * `description` - (Optional) The description for this Role Assignment. Changing this forces a new resource to be created.
   * `skip_service_principal_aad_check` - (Optional) The description for this Role Assignment. Changing this forces a new resource to be created.
   ~> Note: If it is not a Service Principal identity it will cause the role assignment to fail.

  Example Input:
  ```
   role_assignments = {
    role_ass1 = {
      scope                                = "/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup"
      role_definition_name                 = "Reader"
      principal_id                         = "00000000-0000-0000-0000-000000000000"
      principal_type                       = "User"
      description                          = "Assign Reader role to user"
      skip_service_principal_aad_check     = false
      condition                            = null
      condition_version                    = null
      delegated_managed_identity_resource_id = null
    }
  }
  ```
  DESCRIPTION
}

variable "diagnostic_settings" {
  type = map(object({
    name                           = string
    target_resource_id             = optional(string)
    eventhub_name                  = optional(string)
    eventhub_authorization_rule_id = optional(string)
    log_analytics_workspace_id     = optional(string)
    storage_account_id             = optional(string)
    log_analytics_destination_type = optional(string)
    partner_solution_id            = optional(string)
    enabled_log = optional(list(object({
      category       = optional(string)
      category_group = optional(string)
    })))
    metric = optional(object({
      category = optional(string, "AllMetrics")
      enabled  = optional(bool)
    }))
    timeouts = optional(object({
      create = optional(string, "30")
      update = optional(string, "30")
      read   = optional(string, "5")
      delete = optional(string, "60")
    }))
  }))
  default     = null
  description = <<DESCRIPTION
  * `diagnostic_settings` - (Optional) Diagnostic settings for azure resources.
  The following arguments are supported:
    * `name` - (Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created.
    -> **NOTE:** If the name is set to 'service' it will not be possible to fully delete the diagnostic setting. This is due to legacy API support.
    * `target_resource_id` - (Optional) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created.
    * `eventhub_name` - (Optional) Specifies the name of the Event Hub where Diagnostics Data should be sent.
    -> **NOTE:** If this isn't specified then the default Event Hub will be used.
    * `eventhub_authorization_rule_id` - (Optional) Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data.
    -> **NOTE:** This can be sourced from [the `azurerm_eventhub_namespace_authorization_rule` resource](eventhub_namespace_authorization_rule.html) and is different from [a `azurerm_eventhub_authorization_rule` resource](eventhub_authorization_rule.html).
    -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
    * `log_analytics_workspace_id` - (Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent.
    -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
    * `storage_account_id` - (Optional) The ID of the Storage Account where logs should be sent.
    -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
    * `log_analytics_destination_type` - (Optional) Possible values are `AzureDiagnostics` and `Dedicated`. When set to `Dedicated`, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy `AzureDiagnostics` table.
    -> **NOTE:** This setting will only have an effect if a `log_analytics_workspace_id` is provided. For some target resource type (e.g., Key Vault), this field is unconfigurable. Please see [resource types](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables/azurediagnostics#resource-types) for services that use each method. Please [see the documentation](https://docs.microsoft.com/azure/azure-monitor/platform/diagnostic-logs-stream-log-store#azure-diagnostics-vs-resource-specific) for details on the differences between destination types.
    * `partner_solution_id` - (Optional) The ID of the market partner solution where Diagnostics Data should be sent. For potential partner integrations, [click to learn more about partner integration](https://learn.microsoft.com/en-us/azure/partner-solutions/overview).
    -> **NOTE:** At least one of `eventhub_authorization_rule_id`, `log_analytics_workspace_id`, `partner_solution_id` and `storage_account_id` must be specified.
    An `enabled_log` block supports the following:
      * `category` - (Optional) The name of a Diagnostic Log Category for this Resource.
      -> **NOTE:** The Log Categories available vary depending on the Resource being used. You may wish to use [the `azurerm_monitor_diagnostic_categories` Data Source](../d/monitor_diagnostic_categories.html) or [list of service specific schemas](https://docs.microsoft.com/azure/azure-monitor/platform/resource-logs-schema#service-specific-schemas) to identify which categories are available for a given Resource.
      * `category_group` - (Optional) The name of a Diagnostic Log Category Group for this Resource.
      -> **NOTE:** Not all resources have category groups available.
      -> **NOTE:** Exactly one of `category` or `category_group` must be specified.
    A `metric` block supports the following:
      * `category` - (Required) The name of a Diagnostic Metric Category for this Resource.
      * -> **NOTE:** The Metric Categories available vary depending on the Resource being used. You may wish to use [the `azurerm_monitor_diagnostic_categories` Data Source](../d/monitor_diagnostic_categories.html) to identify which categories are available for a given Resource.
      * `enabled` - (Optional) Is this Diagnostic Metric enabled? Defaults to `true`.
    The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
      * `create` - (Defaults to 30 minutes) Used when creating the Diagnostics Setting.
      * `update` - (Defaults to 30 minutes) Used when updating the Diagnostics Setting.
      * `read` - (Defaults to 5 minutes) Used when retrieving the Diagnostics Setting.
      * `delete` - (Defaults to 60 minutes) Used when deleting the Diagnostics Setting.

  Example Input:
  ```
  diagnostic_settings = {
    "diagnostic" = {
      name                           = "diagnostic_settings"
      target_resource_id             = null
      eventhub_name                  = null
      eventhub_authorization_rule_id = null
      log_analytics_workspace_id     = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myLogAnalyticsWorkspace"
      storage_account_id             = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/myResourceGroup/providers/Microsoft.Network/loadBalancers/my_load_balancer_1"
      log_analytics_destination_type = null
      partner_solution_id            = null
      enabled_log = [
        {
          category       = null
          category_group = "allLogs"
        }
      ]
      metric = {
        category = "AllMetrics"
        enabled  = true
      }
    }
  }
  ```
  DESCRIPTION
}
