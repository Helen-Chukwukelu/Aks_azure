variable "image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "source_image_project" {
  type    = string
  default = "ubuntu-os-cloud"
}
variable "bastion_disk_size_gb" {
  type    = string
  default = "30"
}

variable "bastion_service_account" {
  default = {

    email  = "678893936446-compute@developer.gserviceaccount.com",
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
  type = object({
    email  = string,
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account."
}

variable "num_instances" {
  type    = string
  default = "1"
}

variable "nat_ip" {
  description = "Public ip address"
  default     = null
}

variable "network_tier" {
  description = "Network network_tier"
  default     = "PREMIUM"
}

variable "vpn_users" {
  default     = ["user1", "user2"]
  description = "list of users that need access to the VPN"
}
