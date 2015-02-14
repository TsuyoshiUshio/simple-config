require 'yaml'

class Repository
  def config_path
    @config_path
  end

  def self.create(path = 'config')
      Repository.new(path)
  end

  private
  def load_yaml
    begin
      f = open(@config_path)
      @config = YAML.load(f.read)
      f.close
    rescue Exception => e
       raise "#{@config_path}にrepository.yamlが見つかりません"
    end
  end

  def self.generate_methods(config, environment)
    config[environment].each do |k, v|
       define_method(k) { "#{v}" }
    end
  end

  def initialize(path)
    @config_path = File.expand_path("../#{path}/repository.yml", __FILE__)
    @environment = ENV['RAILS_ENV']
    @environment ||= 'development'
    load_yaml
    Repository.generate_methods(@config, @environment)
  end
end