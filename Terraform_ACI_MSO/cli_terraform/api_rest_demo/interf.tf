terraform {
  required_version = ">= 1.0.1"
}

terraform {
  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
    }
  }
}

provider "aci" {
  username = var.aci_username
  password = var.aci_password
  url      = var.aci_url
#  insecure = true
}

resource "aci_rest" "add_interf_des" {
  path       = "/api/mo/uni.json"
  payload = <<EOF

{
    "infraHPathS": {
        "attributes": {
            "rn": "hpaths-2202_eth1_11",
            "dn": "uni/infra/hpaths-2202_eth1_11",
            "descr": "Interface is not in use",
            "name": "2202_eth1_11"
        },
        "children": [
            {
                "infraRsHPathAtt": {
                    "attributes": {
                        "dn": "uni/infra/hpaths-2202_eth1_11/rsHPathAtt-[topology/pod-1/paths-2202/pathep-[eth1/11]]",
                        "tDn": "topology/pod-1/paths-2202/pathep-[eth1/11]"
                    }
                }
            }
        ]
    }
}
  EOF
}
