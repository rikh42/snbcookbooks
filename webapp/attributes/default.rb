
default[:shipit] = {}

node[:deploy].each do |application, deploy|
  	## Target Folder
  	default[:shipit][application][:deploy_to] = "/srv/www/#{application}"
	
	## Time now. We'll create a folder with this timestamp in it and install into that...
	default[:shipit][application][:release_date] = Time.now.utc.strftime("%Y%m%d%H%M%S")

	## Useful paths to the install path and the live path
	default[:shipit][application][:release_path] = "#{node[:shipit][application][:deploy_to]}/releases/#{node[:shipit][application][:release_date]}"
	default[:shipit][application][:current_path] = "#{node[:shipit][application][:deploy_to]}/current"
	default[:shipit][application][:doc_root] = "#{node[:shipit][application][:deploy_to]}/current/htdocs"

	## user and group information - will we need this?
	default[:shipit][application][:action] = 'deploy'
	default[:shipit][application][:user] = 'deploy'
	default[:shipit][application][:group] = 'www-data'
	default[:shipit][application][:shell] = '/bin/zsh'
end
