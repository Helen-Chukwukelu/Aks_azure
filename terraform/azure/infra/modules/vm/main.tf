resource "random_password" "password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "azurerm_virtual_network" "vm_vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.2.0/16"]
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = var.vm_sub
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vm_nic" {
  for_each = var.vm_map
  #count               = 2
  name                = "${each.value.name}-nic" #"nic-${count.index+1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.value.name}-ipconfig-nic"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  #count               = 2
  for_each = var.vm_map
  name                = each.value.name #"myVM${count.index+1}"
  resource_group_name = var.resource_groupname
  location            = var.location
  size                = each.value.size
  admin_username      = "niyez"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.vm_nic[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }

  custom_data = base64encode(<<EOF
                #!/bin/bash
                echo "Hello from ${each.value.name} !"
                EOF
  )
}

resource "azurerm_virtual_machine_extension" "vm-extensions" {
  count                = 2
  name                 = "vm${count.index+1}-ext"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"
    }
SETTINGS

}