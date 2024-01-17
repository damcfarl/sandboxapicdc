import requests
import json
from login import get_token
 
#tenant_name = "dm_tenant_python_REST_API"
#tenant_descr = "Created_by_python_and_REST_API"
tenant_name = "dm_tenant_filter"
filter_name = "dm-ssh"
#dn_filter_name = "uni/tn-{{"tenant_name"}}/flt-dm-ssh"
dn_filter_type_name = "uni/tn-dm_tenant_filter/flt-dm-ssh/e-dm-ssh"
#print ("dn_filter_name: ", dn_filter_name), 
print ("dn_filter_type_name: ", dn_filter_type_name),

def create_filter():
   
   token = get_token()
   url = "https://sandboxapicdc.cisco.com/api/mo/uni.json"
#  url = "https://10.88.36.23/api/mo/uni.json"

#  dn_filter_name = "uni/tn-dm_tenant_filter/flt-dm-ssh",
#  print ("dn_filter_name: ", dn_filter_name), 
#  dn_filter_type_name = "uni/tn-dm_tenant_filter/flt-dm-ssh/e-dm-ssh",
#  print ("dn_filter_type_name: ", dn_filter_type_name), 


   payload = {
       "vzFilter": {
           "attributes": {
#              "dn": "uni/tn-dm_loop/flt-dm-ssh",
#              "dn": "uni/tn-{{tenant_name}}/flt-dm-ssh",
               "dn": "uni/tn-dm_tenant_filter/flt-dm-ssh",
#              "dn": dn_filter_name,
               "name": "dm-ssh",
               "rn": "flt-dm-ssh",
               "status": "created,modified"
           },
           "children": [
               {
                   "vzEntry": {
                       "attributes": {
#                          "dn": "uni/tn-{{tenant_name}}/flt-dm-ssh/e-dm-ssh",
                           "dn": "uni/tn-dm_tenant_filter/flt-dm-ssh/e-dm-ssh",
#                          "dn": dn_filter_type_name,
                           "name": "dm-ssh",
                           "etherT": "ip",
                           "prot": "tcp",
                           "dFromPort": "ssh",
                           "dToPort": "ssh",
                           "rn": "e-dm-ssh",
                           "status": "created,modified"
                       },
                       "children": []
                   }
               }
           ]
       }
   }
   headers = {
      "Cookie" : f"APIC-Cookie={token}", 
   }
 
   requests.packages.urllib3.disable_warnings()
   response = requests.post(url,data=json.dumps(payload), headers=headers, verify=False)
 
   if (response.status_code == 200):
      print ("\nSuccessfully created filter", filter_name, "\n")
   else:
      print("\nIssue with creating filter", filter_name, "\n")
 
def get_filter():
   return filter_name
 
if __name__ == "__main__":
   create_filter()
