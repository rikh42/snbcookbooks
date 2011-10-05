
## testing deploying an app with mercurial


Chef::Log.warn("Syncing site from Kiln")
Chef::Log.warn(node)
hg "/home/site/checkouts/www" do
  repository "https://#{node[:snb][:kilnuser]}:#{node[:snb][:kilnpass]}@smallneatbox.kilnhg.com/Repo/Repositories/CMS/promo"
  reference "tip"
  action :sync
end