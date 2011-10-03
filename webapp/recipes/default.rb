
## testing deploying an app with mercurial

hg "/home/site/checkouts/www" do
  repository "ssh://hg@bitbucket.org/niallsco/chef-hg"
  reference "tip"
  key "/home/site/.ssh/keyname"
  action :sync
end