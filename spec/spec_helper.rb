require 'serverspec'
require 'winrm'
require 'yaml'

host_properties = YAML.load_file('hosts.yml')
common_properties = YAML.load_file('properties.yml')

set :backend, :winrm
set :os, :family => 'windows'

endpoint = "http://#{ENV['TARGET_HOST']}:5985/wsman"

host = ENV['TARGET_HOST']

properties = host_properties[host]
properties[:roles].each do |r|
  properties =common_properties[r].merge(host_properties[host]) if common_properties[r]
end
set_property properties

host_vars = YAML.load_file(
  File.expand_path("../../host_vars/#{host}.yml", __FILE__)
) if File.exists?(File.expand_path("../../host_vars/#{host}.yml", __FILE__))


spec_property = host_vars ||= {}
puts "YAML: #{host}", host_vars.to_yaml
puts host_vars.to_yaml

if Gem::Version.new(WinRM::VERSION) < Gem::Version.new('2')
  winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => host_vars['winrm_opts'][:user], :pass => host_vars['winrm_opts'][:pass], :basic_auth_only => true)
  winrm.set_timeout 300 # 5 minutes
else
  opts = {
    user: host_vars['winrm_opts'][:user],
    password: host_vars['winrm_opts'][:pass],
    endpoint: endpoint,
    operation_timeout: 300,
    no_ssl_peer_verification: false,
  }

  winrm = ::WinRM::Connection.new(opts)
end

Specinfra.configuration.winrm = winrm
