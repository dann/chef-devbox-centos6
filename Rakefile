task :default => "cookbook:validate"


namespace :solo do
  desc "Prepare chef-solo with knife-solo: rake solo:prepare host=192.168.50.10"
  task :prepare do
    host = ENV["host"]
    sh "knife solo prepare vagrant@#{host}"
  end

  desc "Setup host using knife-solo: rake solo:setup host=192.168.50.10"
  task :setup do
    host = ENV["host"]
    sh "knife solo cook vagrant@#{host}"
  end
end
namespace :cookbook do
  desc "Validate cookbooks: rake cookbook:validate"
  task :validate do
    sh "foodcritic site-cookbooks"
  end

  desc "Create a cookbook: rake cookbook:create name=test"
  task :create do
    name = ENV["name"]
    sh "knife cookbook create #{name} -o site-cookbooks"
  end

end
