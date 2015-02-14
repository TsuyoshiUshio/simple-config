require 'yaml'

class Repository
  def config_path
    @config_path
  end

  def self.create(path = 'config')
      config = load_yaml(path)
      Repository.new(config)
  end

  private
  def self.load_yaml(path)
    config_path = File.expand_path("../#{path}/repository.yml", __FILE__)
    environment = ENV['RAILS_ENV']
    environment ||= 'development'
    begin
      f = open(config_path)
      config_contents = YAML.load(f.read)
      f.close
    rescue Exception => e
       raise "#{config_path}にrepository.yamlが見つかりません"
    end
    {:config_path => config_path, :environment => environment, :config_contents => config_contents}
  end

  def self.generate_methods(config, environment)
    config[environment].each do |k, v|
       define_method(k) { "#{v}" }
    end
  end

  def initialize(config)
    @config_path = config[:config_path]
    @environment = config[:environment]
    @config = config[:config_contents]
    Repository.generate_methods(@config, @environment)
  end
end