variable "aci_username" { 
#  default = "aciadmin" 
  default = "admin" 
}

variable "aci_password" { 
#  default = "C1sco12345!" 
  default = "!v3G@!4@Y"
}

variable "aci_url" { 
#  default = "https://10.10.10.10" 
  default = "https://sandboxapicdc.cisco.com"
}

variable "demo_tenant_tf" {
  default = "dm_cli_terraform_T01"
# default = "dm_cli_terraform_appcentric_T01"
}

variable "vmm_domain" {
  default = "terraform_vDS"
}

