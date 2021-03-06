# App Service Plan
module "app_service_plan" {
  source  = "claranet/app-service-plan/azurerm"
  version = "3.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short
  name_prefix         = coalesce(var.app_service_plan_name_prefix, var.name_prefix)

  sku = var.app_service_plan_sku

  kind     = var.app_service_plan_sku["tier"] == "Dynamic" ? "FunctionApp" : var.app_service_plan_os
  reserved = var.app_service_plan_os == "Linux" ? true : var.app_service_plan_reserved

  extra_tags = merge(
    var.extra_tags,
    var.app_service_plan_extra_tags,
    local.default_tags,
  )
}

module "function_app" {
  source  = "claranet/function-app-single/azurerm"
  version = "3.0.0"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = var.resource_group_name
  location            = var.location
  location_short      = var.location_short

  name_prefix                      = var.name_prefix
  storage_account_name_prefix      = var.storage_account_name_prefix
  application_insights_name_prefix = var.application_insights_name_prefix
  function_app_name_prefix         = var.function_app_name_prefix

  app_service_plan_id               = module.app_service_plan.app_service_plan_id
  function_language_for_linux       = var.function_language_for_linux
  function_app_application_settings = var.function_app_application_settings

  application_insights_instrumentation_key = var.application_insights_instrumentation_key
  application_insights_type                = var.application_insights_type

  extra_tags = merge(var.extra_tags, local.default_tags)
  application_insights_extra_tags = merge(
    var.extra_tags,
    var.application_insights_extra_tags,
    local.default_tags,
  )
  storage_account_extra_tags = merge(
    var.extra_tags,
    var.storage_account_extra_tags,
    local.default_tags,
  )
  function_app_extra_tags = merge(
    var.extra_tags,
    var.function_app_extra_tags,
    local.default_tags,
  )
}

