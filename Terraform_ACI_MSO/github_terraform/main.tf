terraform {
  required_version = ">=1.0.1"
}

terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
#     version = "0.7.1"   
    }
  }
}

provider "aci" {
  username = var.aci_username
  password = var.aci_password
  url      = var.aci_url
#  insecure = true
}

terraform {
  backend "local" {
#   path="/home/cisco/projects/aci/tf_state/terraform.tfstate"
    path="/home/damcfarl/Documents/terraform_statefiles/terraform_tfstate"
  }
}


resource "aci_tenant" "tenant_tf" {
  name = var.demo_tenant_tf
}

resource "aci_vrf" "vrf_tf" {
  tenant_dn = aci_tenant.tenant_tf.id
  name      = var.vrf_tf
}

resource "aci_bridge_domain" "internal_tf" {
  tenant_dn          = aci_tenant.tenant_tf.id
  name               = var.bd1_tf
  relation_fv_rs_ctx = aci_vrf.vrf_tf.id
}

resource "aci_bridge_domain" "external_tf" {
  tenant_dn          = aci_tenant.tenant_tf.id
  name               = var.bd2_tf
  relation_fv_rs_ctx = aci_vrf.vrf_tf.id
}

resource "aci_subnet" "internal_tf_subnet" {
  parent_dn        = aci_bridge_domain.internal_tf.id
  ip               = var.bd_subnet1_tf
}

resource "aci_subnet" "external_tf_subnet" {
  parent_dn        = aci_bridge_domain.external_tf.id
  ip               = var.bd_subnet2_tf
}

resource "aci_application_profile" "anp_tf" {
  tenant_dn = aci_tenant.tenant_tf.id
  name      = var.anp_tf
}

# resource "aci_vmm_domain" "vds" {
#   provider_profile_dn = var.provider_profile_dn
#   name                = "ESX0-leaf102"
# }

#data "aci_vmm_domain" "vds" {
#  provider_profile_dn = "/uni/vmmp-VMware"
#  name                = "dm_vDS"
#}

resource "aci_application_epg" "internal_tf" {
  application_profile_dn = aci_application_profile.anp_tf.id
  name                   = var.epg1_tf
  relation_fv_rs_bd      = aci_bridge_domain.internal_tf.id
}

resource "aci_application_epg" "external_tf" {
  application_profile_dn = aci_application_profile.anp_tf.id
  name                   = var.epg2_tf
  relation_fv_rs_bd      = aci_bridge_domain.external_tf.id
}

resource "aci_epg_to_contract" "internal_provide_contract" {
  application_epg_dn = aci_application_epg.internal_tf.id
  contract_dn        = aci_contract.contract_internal_tf_external_tf.id
  contract_type      = "provider"
}

resource "aci_epg_to_contract" "external_provide_contract" {
  application_epg_dn = aci_application_epg.external_tf.id
  contract_dn        = aci_contract.contract_internal_tf_external_tf.id
  contract_type      = "consumer"
}


resource "aci_contract" "contract_internal_tf_external_tf" {
  tenant_dn = aci_tenant.tenant_tf.id
  name      = "contract_Web"
}

resource "aci_filter" "allow_http" {
  tenant_dn = aci_tenant.tenant_tf.id
  name      = "allow_http"
}
resource "aci_filter" "allow_icmp" {
  tenant_dn = aci_tenant.tenant_tf.id
  name      = "allow_icmp"
}

resource "aci_filter_entry" "http" {
  name        = "http"
  filter_dn   = aci_filter.allow_http.id
  ether_t     = "ip"
  prot        = "tcp"
  d_from_port = "http"
  d_to_port   = "http"
  stateful    = "yes"
}

resource "aci_filter_entry" "icmp" {
  name        = "icmp"
  filter_dn   = aci_filter.allow_icmp.id
  ether_t     = "ip"
  prot        = "icmp"
  stateful    = "yes"
}


resource "aci_contract_subject" "subject_tf" {
  contract_dn                  = aci_contract.contract_internal_tf_external_tf.id
  name                         = "Web_subject"
  relation_vz_rs_subj_filt_att = [
     aci_filter.allow_http.id,
     aci_filter.allow_icmp.id,
  ]
}
