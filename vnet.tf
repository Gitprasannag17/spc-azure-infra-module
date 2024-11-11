resource "azurerm_virtual_network" "vnet" {
    name = local.vnet_name 
    resource_group_name = local.rg_name
    address_space = [var.vnet_cidr]
    location = var.region_name
    tags = {
        Env = var.env_tag
    }

    depends_on = [azurerm_resource_group.rg]

}

resource "azurerm_subnet" "subnet" {
    resource_group_name = local.rg_name
    virtual_network_name = local.vnet_name 
    count = length(var.subnet_names)
    address_prefixes = [cidrsubnet(var.vnet_cidr,8,count.index)]
    name = var.subnet_names[count.index]

    depends_on = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_security_group" "nsg" {
    name = local.nsg_name
    resource_group_name = local.rg_name
    location = var.region_name
    security_rule {
        name = "openssh"
        priority = "320"
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = var.vnet_cidr

    }

    security_rule {
        name = "openhttp"
        priority = "330"
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = var.vnet_cidr

    }

    security_rule {
        name = "open8080"
        priority = 340
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = 8080
        source_address_prefix = "*"
        destination_address_prefix = var.vnet_cidr
    }
  


    depends_on = [azurerm_virtual_network.vnet]

}

resource "azurerm_public_ip" "public-ip" {
    name = local.public_ip_name
    resource_group_name = local.rg_name
    location = var.region_name
    allocation_method = "Dynamic"
    sku = "Basic"

    depends_on = [azurerm_resource_group.rg]

}

resource "azurerm_network_interface" "nic" {
    name = local.nic_name
    resource_group_name = local.rg_name
    location = var.region_name
    ip_configuration {
        name = "spc_nic_ip"
        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.subnet[0].id
        public_ip_address_id = azurerm_public_ip.public-ip.id
    }

    depends_on = [ 
        azurerm_subnet.subnet,
        azurerm_public_ip.public-ip
        ]
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
    network_interface_id = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}