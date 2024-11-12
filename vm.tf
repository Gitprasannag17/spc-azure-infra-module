resource "azurerm_linux_virtual_machine" "virtualmachine" {
    name = local.vm_name
    resource_group_name = local.rg_name
    location = var.region_name
    network_interface_ids = [azurerm_network_interface.nic.id]
    size = "Standard_B1s"
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    admin_username = var.vm_username
    admin_password = var.vm_userpassword
    disable_password_authentication =  false
    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-focal"
        sku = "20_04-lts-gen2"
        version = "latest"          
    }
    depends_on = [ azurerm_network_interface.nic ]
    
}

resource "null_resource" "deployapp" {
    triggers = {
        build_id = var.build_id
    }
   connection {
        type = "ssh"
        user =  var.vm_username
        password = var.vm_userpassword
        host = azurerm_linux_virtual_machine.virtualmachine.public_ip_address
    }
/*
 provisioner "remote-exec" {
        inline = [
          "tmux new-session -d -s myapp 'java -jar ~/apps/spring-pet-clinic-jar/spring-petclinic-3.3.0-SNAPSHOT.jar'"
        ]

    }
    
*/
    provisioner "file" {
      source        = "deployspc.sh"
      destination   = "/tmp/deploy.sh" 
      
    }

    provisioner "file" {
      source        = var.jar_path
      destination   = "/tmp/spc.jar" 
      
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/deploy.sh",
          "/tmp/deploy.sh",

        ]

    }
    

    depends_on = [
        azurerm_linux_virtual_machine.virtualmachine
    ]    

}
