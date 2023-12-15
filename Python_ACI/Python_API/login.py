import requests
import json
 
def get_token():  
#   url = "https://10.88.36.23/api/aaaLogin.json"
   url = "https://sandboxapicdc.cisco.com/api/aaaLogin.json"
 
   payload = {
      "aaaUser": {
         "attributes": {
#          "name":"damcfarl",
#          "pwd":"cisco!123"
           "name":"admin",
           "pwd":"!v3G@!4@Y"
         }
      }
   }
 
   headers = {
      "Content-Type" : "application/json"
   }
 
   requests.packages.urllib3.disable_warnings()
   response = requests.post(url,data=json.dumps(payload), headers=headers, verify=False).json()
   token = response['imdata'][0]['aaaLogin']['attributes']['token']
    
   return token
 
def main():
   token = get_token()
   print("The token is: " + token)
 
if __name__ == "__main__":
   main()
