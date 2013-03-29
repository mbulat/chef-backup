#
# Cookbook Name:: backup
# Recipe:: default
#
# Copyright 2011, Alastair Brunton
#
# MIT license
#

# Install backup, s3sync, fog, mail, whenever

package "libxslt" do
  package_name "libxslt-dev"
  action :install
end

package "libxml-dev" do
  package_name "libxml2-dev"
  action :install
end

backup_bag = Chef::EncryptedDataBagItem.load("passwords","backup")

['backup', 's3sync', 'fog', 'mail', 'whenever', 'popen4'].each do |gem_name|
  gem_package gem_name do
    action :install
  end
end

['Backup', 'Backup/config', 'Backup/log'].each do |dir|
  execute "mkdir /home/#{node[:backup][:backup_user]}/#{dir}" do
    user node[:backup][:backup_user]
    only_if { !File.directory?("/home/#{node[:backup][:backup_user]}/#{dir}") }
  end
end

script "backup dependencies" do
  interpreter "bash"
  user "root"
  cwd "/home/#{node[:backup][:backup_user]}/Backup"
  code <<-EOH
  /usr/local/bin/backup dependencies --install net-ssh
  /usr/local/bin/backup dependencies --install net-scp
  /usr/local/bin/backup dependencies --install excon
  /usr/local/bin/backup dependencies --install fog
  sudo touch /home/#{node[:backup][:backup_user]}/Backup/.installed
  EOH
  not_if "test -f /home/#{node[:backup][:backup_user]}/Backup/.installed"
end

template "/home/#{node[:backup][:backup_user]}/Backup/config.rb" do
  owner node[:backup][:backup_user]
  source "config.rb.erb"
  variables(:config => node[:backup], :backup_bag => backup_bag)
  not_if { File.exists?("/home/#{node[:backup][:backup_user]}/Backup/config.rb")}
end


# Whenever config setup.
template "/home/#{node[:backup][:backup_user]}/Backup/config/schedule.rb" do
  owner node[:backup][:backup_user]
  source "schedule.rb.erb"
  variables(:config => node[:backup])
  not_if { File.exists?("/home/#{node[:backup][:backup_user]}/Backup/config/schedule.rb")}
end

template "/etc/logrotate.d/whenever_log" do
  owner "root"
  source "logrotate.erb"
  variables(:backup_path => "/home/#{node[:backup][:backup_user]}/Backup")
  not_if { File.exists? "/etc/logrotate.d/whenever_log" }
end

# Do manually since we don't want every machine doing this
#script "schedule" do
  #interpreter "bash"
  #user "root"
  #cwd "/home/#{node[:backup][:backup_user]}/Backup"
  #code <<-EOH
  #/usr/local/bin/whenever -w
  #sudo touch /home/#{node[:backup][:backup_user]}/Backup/.scheduled
  #EOH
  #not_if "test -f /home/#{node[:backup][:backup_user]}/Backup/.scheduled"
#end
