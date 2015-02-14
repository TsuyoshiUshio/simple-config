require 'spec_helper'
require File.expand_path('../../repository', __FILE__)

describe '環境毎のリポジトリを管理するクラスを作成する' do

  it 'インスタンスが生成出来る' do
    repository = Repository.create
    expect(repository.config_path).to eq File.expand_path('../../config/repository.yml', __FILE__)
    repository = Repository.create('spec/config')
    expect(repository.config_path).to eq File.expand_path('../../spec/config/repository.yml', __FILE__)
  end

  it 'repository.ymlが無い場所を指定したら例外' do
    expect{repository = Repository.create('.')}.to raise_error("#{Dir::pwd}/repository.ymlにrepository.yamlが見つかりません")
  end

  it '環境変数にあわせて変数を取得出来る' do
    ENV['RAILS_ENV'] = 'development'
    repository = Repository.create
    expect(repository.release).to eq "https://github.com/sample/release.git"
  end
end