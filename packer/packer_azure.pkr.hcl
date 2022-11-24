variable "client_id" {
  default = env("ARM_CLIENT_ID")
}

variable "client_secret" {
  default = env("ARM_CLIENT_SECRET")
}

variable "subscription_id" {
  default = env("ARM_SUBSCRIPTION_ID")
}

variable "tenant_id" {
  default = env("ARM_TENANT_ID")
}

variable "location" {
  type    = string
  default = "East US 2"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "azure-arm" "nginx" {
  azure_tags = {
    owner = "Adenn Tumba"
    dept  = "Engineering"
    task  = "Image deployment"
  }
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  subscription_id                   = var.subscription_id
  tenant_id                         = var.tenant_id
  location                          = var.location
  image_offer                       = "UbuntuServer"
  image_publisher                   = "Canonical"
  image_sku                         = "18.04-LTS"
  managed_image_name                = "Image-nginx-${local.timestamp}"
  managed_image_resource_group_name = "RG-ElasticStack"
  os_type                           = "Linux"
  vm_size                           = "Standard_B1s"
}

build {
  sources = ["azure-arm.nginx"]

  provisioner "shell" {
    script = "script.sh"
  }
}
