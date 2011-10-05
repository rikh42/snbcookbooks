
## testing deploying an app with mercurial

## What does this have to do. Assuming we have apache / php installed on the server and not a lot else.

### Create a vhost for the app and restart apache

### Create a folder for the app to live in :-
### live - symlink to the current release
### deployments
### 	201110041242
### 		all files in here
### 		htdocs - live above will be a symlink to one of these folders.

### get the latest release and put it into an appropriate folder



Chef::Log.warn("Syncing site from Kiln")
Chef::Log.warn(node[:shipit])

directory "#{node[:shipit][:release_path]}" do
  action :create
  mode 0755
  owner node[:shipit][:user]
  group node[:shipit][:group]
  recursive true
end

directory "#{node[:shipit][:current_path]}" do
  action :create
  mode 0755
  owner node[:shipit][:user]
  group node[:shipit][:group]
  recursive true
end

hg node[:shipit][:release_path] do
  repository "https://#{node[:snb][:kilnuser]}:#{node[:snb][:kilnpass]}@smallneatbox.kilnhg.com/Repo/Repositories/CMS/promo"
  reference "tip"
  action :sync
end

