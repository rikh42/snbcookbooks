## Updated Napes original code that was based on SSH access to the Mercurial Repo.
## Our Mercurial Server does not support this, so I updated the hg commands to something that
## would work for us.

## Clone and / or Sync with the repo. Use this by default
action :sync do
  execute "clone repository" do    
    not_if "hg identify #{new_resource.path}"
    command "hg clone -r #{new_resource.reference} #{new_resource.repository} #{new_resource.path}"
  end
  execute "pull changes" do
      command "cd #{new_resource.path} && hg pull -r #{new_resource.reference} #{new_resource.repository}"
  end
  execute "update" do
      command "cd #{new_resource.path} && hg update -r #{new_resource.reference}"
  end
  execute "update owner" do
    command "chown -R #{new_resource.owner}:#{new_resource.group} #{new_resource.path}"
  end
  execute "update permissions" do
    command "chmod -R #{new_resource.mode} #{new_resource.path}"
  end
end
 

## clone the project 
action :clone do
  execute "clone repository" do
    not_if "hg identify #{new_resource.path}"
    command "hg clone -r #{new_resource.reference} #{new_resource.repository} #{new_resource.path}"
  end
  execute "update owner" do
    command "chown -R #{new_resource.owner}:#{new_resource.group} #{new_resource.path}"
  end
  execute "update permissions" do
    command "chmod -R #{new_resource.mode} #{new_resource.path}"
  end
end
