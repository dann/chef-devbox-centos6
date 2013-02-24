#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{git gcc readline-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

git node['user']['home'] + "/.dotfiles" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/dann/dotfiles.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "setup-dotfiles" do
  user node['user']['name']
  group node['user']['group'] 
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    cd ~/.dotfiles
    ./dotsetup.sh
  EOC
end
