variable   "vmname"             {}
variable   "location"           {}
variable   "rg_name"            {}
variable   "nsg"                {}
variable   "vnet"               {}
variable   "vmsize"             {}
variable   "vm_count"           {}
#variable   "managed_disk_name"  {}
#variable   "managed_disk_sizes" {}
#variable   "managed_disk_type"  {}
#variable   "lun"                {}


# Resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.rg_name}"
  location = "${var.location}"
}

# NSG
resource "azurerm_network_security_group" "sg" {
  name                = "${var.nsg}"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
}

#VNET
resource "azurerm_virtual_network" "vn" {
  name                = "${var.vnet}"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

#SUBNET
resource "azurerm_subnet" "sn" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

#PUBLIC IP
resource "azurerm_public_ip" "pubip" {
  name                = "myPublicIP"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

#NIC
resource "azurerm_network_interface" "nic" {
  name                = "mynic"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

##Virtual machine creation


resource "azurerm_virtual_machine" "sap" {
   count                        =  "${length(var.vmname)}"
   name                         =  "${element(var.vmname,count.index)}"
   location                     =  var.location
   resource_group_name          =  azurerm_resource_group.rg.name
   network_interface_ids        =  [azurerm_network_interface.nic.id]
   vm_size                      =  "${element(var.vmsize, count.index)}"

   storage_image_reference {
       publisher        = "Canonical"
       offer            = "UbuntuServer"
       sku              = "18.04-LTS"
       version          = "latest"
    }

   storage_os_disk {
       name                     = "pyhtian_os-disk"
       create_option            = "Fromimage"
       managed_disk_type        = "Standard_LRS"
    }

   os_profile {
       computer_name    = "${element(var.vmname, count.index)}"
       admin_username   = "azureadmin"
       admin_password   = "Avengers#12345"
    }

   os_profile_linux_config {
       disable_password_authentication = false
                }
}
