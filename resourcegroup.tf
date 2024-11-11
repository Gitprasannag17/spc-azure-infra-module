resource "azurerm_resource_group" "rg" {
    name = local.rg_name
    location = var.region_name
    tags = {
        Env = var.env_tag
    }
}