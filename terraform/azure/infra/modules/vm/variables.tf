variable "vm_map" {
    type = map(object({
        name = string
        size = string
    }))
    default = {
        "vm1" = {
            name = "jenkins-vm"
            size = "Standard_DS1_v2"
        }
        "vm2" = {
            name = "tomcat-vm"
            size = "Standard_DS2_v2"
        }
    }
}


