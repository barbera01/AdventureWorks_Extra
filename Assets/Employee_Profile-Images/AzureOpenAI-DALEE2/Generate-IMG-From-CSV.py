import requests
import time
import os
import csv
import os
import io
import warnings

# OPen AI UEndpoint
api_base = 'https:/############.openai.azure.com/'
#Open AI key
api_key = "#######################"
api_version = '2022-08-03-preview'
url = "{}dalle/text-to-image?api-version={}".format(api_base, api_version)

filename = 'Staff.csv'


with open(filename, 'r') as csvfile:
    reader = csv.DictReader(csvfile,  delimiter = ",")
    for row in reader:
        #BusinessEntityID,FirstName,LastName,JobTitle,BirthDate,City,sname,cname
        FN = row['FirstName'] 
        BID = row['BusinessEntityID']
        LN = row['LastName']
        JT = row['JobTitle']
        BD = row['BirthDate']
    
        
     
        IMGFileName = f"{FN}-{LN}-{BID}"
                # Set up our initial generation parameters.
        

        headers= { "api-key": api_key, "Content-Type": "application/json" }
        body = {
            "caption": f"a work profile photo for {FN} {LN} whos role is {JT} and who was born {BD}",
            "resolution": "1024x1024"
        }
        submission = requests.post(url, headers=headers, json=body)
        operation_location = submission.headers['Operation-Location']
        retry_after = submission.headers['Retry-after']
        status = ""
        while (status != "Succeeded"):
            time.sleep(int(retry_after))
            response = requests.get(operation_location, headers=headers)
            status = response.json()['status']
        image_url = response.json()['result']['contentUrl']


        response = requests.get(image_url)
        with open(f"/images/{IMGFileName}.jpg", "wb") as f:
            f.write(response.content)
