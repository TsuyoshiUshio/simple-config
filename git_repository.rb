require 'repository'
require 'pathname_ext'

class GitRepository < Repository
  def self.create(path = 'config')
    config = load_yaml(path)
    if ENV['ENABLE_CLONE'] != 'false' && ENV['RAILS_ENV'] == 'test' then
      GitRepository.new(config).clone_to('spec/temp')
    else
      GitRepository.new(config)
    end
  end

  def clone_to(relative_path)
    raise "RAILS_ENVがtest以外のときはつかえません" unless ENV["RAILS_ENV"] == "test"
    copy_repos(relative_path)
    new_config = @config.dup
    repository_paths.each{|key|
      new_config["repository_base"]["test"][key] =  relative_path + '/' + (Pathname.new(self.send(key)).basename.to_s)
    }
    GitRepository.new({:config_path => config_path,  :contents => new_config})
  end

  def copy_repos(relative_path)
    FileUtils.remove_dir(Dir::pwd + '/' + relative_path, force=true)
    FileUtils.mkdir(Dir::pwd + '/' + relative_path)
    repository_paths.each{|key|
      FileUtils.cp_r(self.send(key), Dir::pwd + '/' + relative_path)
    }
  end

  def method_missing(method, *arg)
    return File.expand_path("../#{contents_hash[method.to_s]}", __FILE__) if @environment == "test" && repository_path?(method.to_s)
    super
  end


  def initialize(config)
    super(config)
  end


end