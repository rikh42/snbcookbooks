
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

node[:deploy].each do |application, deploy|
  Chef::Log.warn("Looing at app #{application}. Type = #{deploy[:application_type]}. Data = #{deploy}")

  ## Skip applications that aren't in our format
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping webapp deploy #{application} as we only support type=php")
    next
  end

  ## Get ready 
  shipit = node[:shipit][application]
  Chef::Log.warn("Deploying Application #{application} to #{shipit[:release_path]}")
  Chef::Log.warn(shipit)

  ## create the new release directory
  directory "#{shipit[:release_path]}" do
    action :create
    mode 0755
    owner node[:shipit][:user]
    group node[:shipit][:group]
    recursive true
  end

  ## Sync with the mercurial repo
  ## We actually set this up in the Scalarium interface as a Subversion repro
  ## as that lets us specify all the fields we need
  hg shipit[:release_path] do
    repository "https://#{deploy[:scm][:user]}:#{deploy[:scm][:password]}@#{deploy[:scm][:repository]}"
    reference "tip"
    action :sync
  end

  ## configure and activate the web app (make the config files etc)
  web_app deploy[:application] do
    docroot shipit[:absolute_document_root]
    server_name deploy[:domains].first
    server_aliases deploy[:domains][1, deploy[:domains].size] unless deploy[:domains][1, deploy[:domains].size].empty?
    mounted_at deploy[:mounted_at]
    ssl_certificate_ca deploy[:ssl_certificate_ca]
  end

  # move away default virtual host so that our app can be the default
  execute "mv away default virtual host" do
    action :run
    command "mv /etc/apache2/sites-enabled/000-default /etc/apache2/sites-enabled/zzz-default"
    only_if do 
      File.exists?("#{node[:apache][:dir]}/sites-enabled/000-default") 
    end
  end

  ## Create or update the link to the new release path, making the changes live
  link "#{shipit[:current_path]}" do
    to "#{shipit[:release_path]}"
    owner shipit[:user]
    group shipit[:group]
  end
end
