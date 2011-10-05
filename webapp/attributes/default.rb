
## The apps folder where it will be deployed
default[:shipit][:deploy_to] = "/srv/www/webapp"

## Time now. We'll create a folder with this timestamp in it and install into that...
default[:shipit][:release_date] = Time.now.utc.strftime("%Y%m%d%H%M%S")

## Useful paths to the install path and the live path
default[:shipit][:release_path] = "#{node[:shipit][:deploy_to]}/releases/#{node[:shipit][:release_date]}"
default[:shipit][:current_path] = "#{node[:shipit][:deploy_to]}/current"
default[:shipit][:doc_root] = "#{node[:shipit][:deploy_to]}/current/htdocs"

## user and group information - will we need this?
default[:shipit][:action] = 'deploy'
default[:shipit][:user] = 'deploy'
default[:shipit][:group] = 'www-data'
default[:shipit][:shell] = '/bin/zsh'
