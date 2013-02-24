#
# Cookbook Name:: plenv
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
%w{git gcc make readline-devel openssl-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

git node['user']['home'] + "/.plenv" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/tokuhirom/plenv.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "plenv" do
  user node['user']['name']
  group node['user']['group'] 
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(plenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    plenv install #{node['plenv']['version']}
    plenv global #{node['plenv']['version']}
    plenv versions
    plenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.plenv/shims/perl") }
end
