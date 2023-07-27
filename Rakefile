require 'rake'
require 'rspec/core/rake_task'
require 'yaml'

hosts = YAML.load_file('hosts.yml')

desc " Check all hosts (=spec:all)"
task :spec => 'spec:all'
task :default => :spec

namespace :spec do
  desc " Check All hosts (=spec) "
  task :all => hosts.keys.map {|host| 'spec:' + host }

  hosts.keys.each do |host|
    desc "#{host} run test"
    RSpec::Core::RakeTask.new(host.to_sym) do |t|
      ENV['TARGET_HOST'] = host
      role = hosts[host][:roles].join(',')
      puts "################################################################################"
      puts " Target host : #{ENV['TARGET_HOST']}"
      puts " Role        : ${role}"
      puts "################################################################################"
      t.fail_on_error = false
      t.pattern = '{spec,common_spec,feature_spec,template_spec,deploy_spec}/{' + hosts[host][:roles].join(',') + '}/**/*_spec.rb'
    end
  end
end
