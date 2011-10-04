
## testing deploying an app with mercurial

hg "/home/site/checkouts/www" do
  repository "https://cded8771-cc27-49dd-85b6-f3131e20dc05:none@smallneatbox.kilnhg.com/Repo/Repositories/CMS/promo"
  reference "tip"
  action :sync
end