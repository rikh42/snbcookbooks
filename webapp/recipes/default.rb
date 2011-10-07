# Author:: Rik. (chef@smallneatbox.co.uk)
# Cookbook Name:: webapp
# Recipe:: default
#
# Copyright 2011, Small Neat Box Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## Deploy Apps on Scalarium from a Mercurial Repo
## Creates new release folder (named with the current timestamp), clones the project
## into it, configures apache to use it and finally updates a symlink to point at
## the new release.

## The web_app.conf.erb template file was taken from the Scalarium chef receipies on Github


Chef::Log.warn("Deploying Apps")

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
  Chef::Log.warn("Syncing site from Kiln")
  hg shipit[:release_path] do
    repository "https://#{deploy[:scm][:user]}:#{deploy[:scm][:password]}@#{deploy[:scm][:repository]}"
    reference "tip"
    action :sync
  end

  ## configure and activate the web app (make the config files etc)
  Chef::Log.warn("Updating Apache config for App")
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
  Chef::Log.warn("Updating symlink to new latest release")
  link "#{shipit[:current_path]}" do
    to "#{shipit[:release_path]}"
    owner shipit[:user]
    group shipit[:group]
  end
end


Chef::Log.warn("Deploy All Done")

