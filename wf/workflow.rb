#!/usr/bin/env ruby

require 'thor'
require 'json'
require 'date'
require 'rest_client'
require 'socket'

$api_host = ENV["api_host"] || "esu4v050"
$version = DateTime.now.strftime(format='%Y.%m.%d-%H:%M:%S')
$execute_sleep = 10
$vm_size = 0
$vm_check_port = 22
$vm_check_retries = 20
$vm_check_sleep = 10

class WorkflowEngine < Thor

	include Thor::Actions
  
    desc "provision <template/json> <output/json>" , "Provision VMs and produces a resource file"
    	def provision(input, outfile)
    		actor = Proc.new do |vappid, name|
    			puts "Provisioning VM \"#{name}\" with vappid = #{vappid}"
    			ip = `lc-node-add -i #{vappid} -s #{$vm_size} -n #{name} ex_bridged=true`.split(" ")[2]
 				raise "Could not provision VM #{name}" if !ip.match(/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/)
 				num_retries = $vm_check_retries
				begin 
					s = TCPSocket.open(ip, $vm_check_port).close
				rescue
					if num_retries > 0
						puts "Waiting for VM \"#{name}\" with #{ip} to boot up... (#{num_retries} attempts left)"
						num_retries -= 1
						sleep $vm_check_sleep
						retry
					else
						raise "VM \"#{name}\" connectivity check failed, exiting..."
					end
				end
 				ip
    		end
    		tmpl = JSON.parse(File.read(input))
    		threads = []
    		tmpl.fetch("nodes").each_pair do |tlist, tvms|
    			threads << Thread.new(tlist, tvms) do |list, vms|
					vms.each_key do |vmname|
						name = "_" + vmname + "-" + DateTime.now.strftime(format='%Y%m%d-%H%M%S')
						vms[vmname]["ip"] = actor.call(vms[vmname].delete("vappid"), name)
					end
				end
			end
			threads.each {|t| t.join}
			File.open(outfile, 'w') {|file| file.write(JSON.generate(tmpl))}
		end

    desc "save <path/to/json> <workflow_name> [version]", "Saves a workflow from a JSON file to server"
  		def save(file, name, version = $version)
  			dsl = JSON.parse(File.read(file))
    		payload = {"name" => name, "version" => version, "dsl" => dsl}
    		response = RestClient.post "http://#{$api_host}/workflow/save", :params => JSON.generate(payload)
    		response_json = JSON.parse(response)
    		if (response_json["status"] == "success")
    			$wf_id = response_json["result"]["id"]
    			puts "Workflow \"#{name}\" has been successfuly created with ID = #{$wf_id}"
    		else 
    			puts "Workflow creation failed, server response:"
    			puts response
    		end

  		end

  	desc "instantiate <workflow_id> [path/to/res/json]", "Instantiates a workflow given the id and resources file"
  		def instantiate(id, file = nil)
  			if file
  				resources = JSON.parse(File.read(file))
  			else
				puts "[WARNING] Resources file missing, using default context."
  				resources = {}
  			end
  			payload = {"id" => id, "resources" => resources}
  			response = JSON.parse(RestClient.post "http://#{$api_host}/workflow/instantiate", :params => JSON.generate(payload))
  			if (response["status"] == "success")
	  			$af_id = response["result"]["ActionFlow"]["id"]
	  			puts "Action flow for workflow ID = #{id} has been created with ID = #{$af_id}"
	  		else
	  			puts response
	  			raise "Action flow instantiation failed"
	  		end
  	end

  	desc "execute <af_id>", "Kicks off an ActionFlow given the ID"
  		def execute(id)
  			payload = {"id" => id}
  			response = RestClient.post "http://#{$api_host}/actionflow/run", :params => JSON.generate(payload)
  			status = JSON.parse(response)["result"]["status"]
			while true do
				response = JSON.parse(RestClient.get "http://#{$api_host}/actionflow")
				status = response["result"]["actionflows"].select {|af| af["id"] == id}[0]["status"]
				if (status == "Executing")
					puts "Still executing..."
					sleep $execute_sleep
					next
				elsif (status == "Failed")
					raise "Execution failed"
				elsif (status == "Success")
					puts "Execution completed successfuly"
					return
				end
			end
  	end

  	desc "start <workflow_id> [resources_file]", "Instantiates and runs an ActionFlow given the workflow ID and a resources file"
  		def start(workflow_id, resources = nil)
  			invoke :instantiate,  [workflow_id, resources]
  			invoke :execute, [$af_id]
  	end


end

WorkflowEngine.start