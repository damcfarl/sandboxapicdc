import requests
import json
from login import get_token
 
tenant_name = "dm_tenant_filter"
tenant_descr = "Created_by_python_and_REST_API"
 
def create_tenant():
   
   token = get_token()
#   url = "https://10.88.36.23/api/mo/uni.json"
   url = "https://sandboxapicdc.cisco.com/api/mo/uni.json"
   payload = {
      "fvTenant": {
         "attributes": {
            "descr": tenant_descr,
            "name": tenant_name
         }
      }
   }
 
   headers = {
      "Cookie" : f"APIC-Cookie={token}", 
   }
 
   requests.packages.urllib3.disable_warnings()
   response = requests.post(url,data=json.dumps(payload), headers=headers, verify=False)
 
   if (response.status_code == 200):
      print ("\nSuccessfully created tenant", tenant_name, "\n")
   else:
      print("\nIssue with creating tenant", tenant_name, "\n")
 
def get_tenant():
   return tenant_name
 
if __name__ == "__main__":
   create_tenant()
