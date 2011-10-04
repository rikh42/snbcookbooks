
## testing deploying an app with mercurial

hg "/home/site/checkouts/www" do
  repository "https://bitbucket.org/zurmo/zurmo"
  reference "tip"
  key "/home/site/.ssh/keyname"
  action :sync
end