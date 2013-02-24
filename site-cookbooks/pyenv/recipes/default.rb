#
# Cookbook Name:: pyenv
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{git gcc make readline-devel openssl-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

git node['user']['home'] + "/.pyenv" do
  user node['user']['name']
  group node['user']['group']
  repository "https://github.com/yyuu/pyenv.git"
  reference "master"
  action :checkout
end

bash "pyenv" do
  user node['user']['name']
  group node['user']['group'] 
  cwd node['user']['home']
  environment "HOME" => node['user']['home']

  code <<-EOC
    echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    source ~/.bashrc
    pyenv install #{node['rbenv']['version']}
    pyenv global #{node['rbenv']['version']}
    pyenv versions
    pyenv rehash
  EOC

  not_if { File.exists?(node['user']['home'] + "/.pyenv/shims/ruby") }
end
