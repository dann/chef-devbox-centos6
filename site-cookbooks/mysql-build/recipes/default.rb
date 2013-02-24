#
# Cookbook Name:: mysql-build
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{git curl gcc cmake}.each do |pkg|
  package pkg do
    action :install
  end
end

git node['user']['home'] + "/mysql-build" do
  user node['user']['name']
  group node['user']['group']
  repository "git://github.com/kamipo/mysql-build.git"
  reference "master"
  # action :sync
  action :checkout
end

bash "mysql-build" do
  user node['user']['name']
  group node['user']['group'] 
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    export PATH="$HOME/mysql-build/bin:$PATH"  >> ~/.bashrc
    source ~/.bashrc

    mkdir -p ~/opt/mysql
    mysql-build -v #{node['mysql-build']['version']} ~/opt/mysql/#{node['mysql-build']['version']}
    cd ~/opt/mysql/#{node['mysql-build']['version']}
    ./scripts/mysql_install_db
    ./bin/mysqld_safe &

    ./bin/mysql -e 'show variables like "version"'

  EOC

  not_if { Dir.exists?(node['user']['home'] + "/opt/mysql/#{node['mysql-build']['version']}") }
end
