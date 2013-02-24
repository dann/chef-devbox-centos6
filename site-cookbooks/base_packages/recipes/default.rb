#
# Cookbook Name:: base_packages
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

%w{vim-enhanced zsh sysstat dstat perf oprofile tcpdump nc valgrind strace blktrace}.each do |pkg|
  package pkg do
    action :install
  end
end
