# updatecvl.rb
#!/usr/bin/ruby

require 'rest-client'
require 'uri'

# Update the uploaded VCL for a particular service and version
# https://docs.fastly.com/api/config#vcl_0971365908e17086751c5ef2a8053087
# only works on draft version contents matched custom cvl upoloaded

# command: ruby $file_name $service_ID $version $vcl_name $fastly_api
# Example: ruby updatevcl.rb upload.vcl myserviceid 9 test myapikeyforfastly

# ARGV[0] - update file name (an example file upload.vcl is in this directory)
# ARGV[1] - service ID
# ARGV[2] - version
# ARGV[3] - existing vcl name
# ARGV[4] - fastly api key


def update_vcl

    if ARGV.length < 5
        puts "Too few arguments"
        exit
    end
    
    puts "Working on updating VCL"

    file = ARGV[0]
    service_id = ARGV[1]
    version_no = ARGV[2]
    vcl_name = ARGV[3]
    fastly_key = ARGV[4]
    url = 'https://api.fastly.com/service/' + service_id + '/version/' + version_no + '/vcl/' + vcl_name
    header = { 'Content-Type' => 'application/x-www-form-urlencoded', 'Fastly-key' => fastly_key } 
    
    # encode as 'Content-Type' is 'application/x-www-form-urlencoded'
    payload = URI::encode(File.read(file))

    # Error handling
    begin
        res = RestClient.put url, payload, headers = header
        puts res.code
        if res.code == 200
            puts "Updated VCL"
            puts res.body
            return true
        end

    rescue RestClient::ExceptionWithResponse => error
        puts "Error uploading VCL"
        puts error.response
        return false
    end
end

# calling the function
update_vcl