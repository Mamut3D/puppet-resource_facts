Facter.add(:resources) do
  require 'puppet'
  require 'json'
  require 'yaml'
  resources = {}

  # load config file if it's been put in place
  config_file = File.join(File.dirname(Puppet.settings[:config]),'resource_facts.yaml')
  conf = File.file?(config_file) ? YAML::load_file(config_file) : []

  conf.each do |type|
    next if Puppet::Type.type(type).instances.count.zero?
    resource_hash = {}
    Puppet::Type.type(type).instances.each do |instance|
      resource_hash[instance.retrieve_resource.title] = instance.retrieve_resource.to_hash
    end
    resources[type] = resource_hash
  end

  setcode do
    JSON.parse(resources.to_json)
  end
end
