import requests
import urllib
import sys

# Update the uploaded VCL for a particular service and version
# https://docs.fastly.com/api/config#vcl_0971365908e17086751c5ef2a8053087
# only works on "draft version", contents matched custom cvl upoloaded

# command: python $path $file_name $service_ID $version $vcl_name $fastly_api
# Example: python /Users/me/Documents/thisproject/updatevcl.py upload.vcl thisismyserviceid 6 vclname thisismyfastlyapitoken

# sys.argv[1] - update file name (an example file upload.vcl is in this directory)
# sys.argv[2] - service ID
# sys.argv[3] - version
# sys.argv[4] - existing vcl name
# sys.argv[5] - fastly api key


def update_vcl():

    file = sys.argv[1]
    # file closing automatically
    with open(file, 'r') as fh: 
        content = fh.read() 
        vcl_data = content

        service_id = sys.argv[2]
        version_no = sys.argv[3]
        vcl_name = sys.argv[4]
        fastly_key = sys.argv[5]
        url = 'https://api.fastly.com/service/' + service_id + '/version/' + version_no + '/vcl/' + vcl_name
        #  You can change Content-Type, can add more header
        headers = { 'Content-Type': 'application/x-www-form-urlencoded', 'Fastly-key': fastly_key  } 
        payload = { 'content': vcl_data } 

    try: 
        #data will be converted according to the header 
        req = requests.put(url, data=payload, headers=headers) 
        if req.status_code == 200: 
            print "Updated uploaded VCL" 
            return True 
        else:
            print "Error uploading VCL" 
            print "Error:" + str(req.status_code)
            print "Error content:" + req.content
    except Exception, err: 
        print str(err) 
        return False

        
update_vcl()

