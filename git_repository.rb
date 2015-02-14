require 'repository'
require 'pathname_ext'

class GitRepository < Repository
  def self.create(path = 'config')
    config = load_yaml(path)
    GitRepository.new(config)
  end

  def clone_to(relative_path)
    raise "RAILS_ENVがtest以外のときはつかえません" unless ENV["RAILS_ENV"] == "test"
    FileUtils.remove_dir(Dir::pwd + '/' + relative_path, force=true)
    FileUtils.mkdir(Dir::pwd + '/' + relative_path)
    repository_paths.each{|key|
        FileUtils.cp_r(self.send(key), Dir::pwd + '/' + relative_path)
    }
    new_config = @config.dup
    repository_paths.each{|key|
      new_config["repository_base"]["test"][key] =  relative_path + '/' + (Pathname.new(self.send(key)).basename.to_s)
    }

    puts new_config
    GitRepository.new({:config_path => config_path,  :contents => new_config})
  end

  def method_missing(method, *arg)
    return File.expand_path("../#{contents_hash[method.to_s]}", __FILE__) if @environment == "test" && repository_path?(method.to_s)
    super
  end

  def repository_path?(key)
    repository_paths.include?(key)
  end

  def repository_paths
    @config['repository_paths']
  end

  def initialize(config)
    super(config)
  end


end