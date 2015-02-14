require 'yaml'

class Repository
  def config_path
    @config_path
  end

  def self.create(path = 'config')
      config = load_yaml(path)
      Repository.new(config)
  end

  def method_missing(method, *args)
    return contents_hash[method.to_s] if contents_hash.key?(method.to_s)
    super
  end

  protected

  def initialize(config)
    @config_path = config[:config_path]
    @environment = ENV['RAILS_ENV']
    @environment ||= 'development'
    @config = config[:contents]
  end

  def self.load_yaml(path)
    config_path = File.expand_path("../#{path}/repository.yml", __FILE__)

    begin
      f = open(config_path)
      contents = YAML.load(f.read)
      f.close
    rescue Exception => e
      raise "#{config_path}にrepository.yamlが見つかりません"
    end
    {:config_path => config_path,  :contents => contents}
  end

  def contents_hash
      @config['repository_base'][@environment]
  end


end