
## testing deploying an app with mercurial


Chef::Log.warn("#{node[:deploy][:snb][:kilnuser]}:#{node[:deploy][:snb][:kilnpass]}@smallneatbox.kilnhg.com/Repo/Repositories/CMS/promo")

#hg "/home/site/checkouts/www" do
#  repository "https://#{node[:deploy][:snb][:kilnuser]}:#{node[:deploy][:snb][:kilnpass]}@smallneatbox.kilnhg.com/Repo/Repositories/CMS/promo"
#  reference "tip"
#  action :sync
#end