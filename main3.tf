resource "azurerm_resource_group" "resource_group_testwz" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_virtual_network" "virtual_network_testwz" {
  name                = var.vnet
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_testwz.name
}

resource "azurerm_subnet" "subnet_VNGW" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.resource_group_testwz.name
  virtual_network_name = azurerm_virtual_network.virtual_network_testwz.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "vpn_gw_ip" {
  name                = "ipp1"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vpn_gw" {
  name                = "vpngateway"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_ip.id
    subnet_id                     = azurerm_subnet.subnet_VNGW.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  name                = "local-pfsense"
  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = "190.210.192.159"  # Reemplaza con IP pública
  address_space   = ["192.168.234.0/24"]
}

# Conexión entre Azure y pfSense
resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                = "vpn-connection"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                           = "IPsec"
  virtual_network_gateway_id     = azurerm_virtual_network_gateway.vpn_gw.id
  local_network_gateway_id       = azurerm_local_network_gateway.onprem.id
  shared_key                     = "SuperSecretKey123"  # Mismo en pfSense

  enable_bgp = false
}


#Subred para ma maquina virtual
resource "azurerm_subnet" "subnetVM" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ip_VM" {
  name                = "ipVM"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
}



#Adaptador de red para la maquina virtual
resource "azurerm_network_interface" "nic" {
  name                = "nicVM"
  location            = var.location
  resource_group_name = var.resource_group_name

#Configuracion de ip para la VM
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnetVM.id
    private_ip_address_allocation = "Dynamic"
	public_ip_address_id          = azurerm_public_ip.ip_VM.id
  }
}

#creacion de la VM
resource "azurerm_windows_virtual_machine" "VirtualMachine" {
  name                = "LABWAZ01"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_B1s"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}