
## testing deploying an app with mercurial

hg "/home/site/checkouts/www" do
  repository "https://bitbucket.org/zurmo/zurmo"
  reference "tip"
  action :sync
end