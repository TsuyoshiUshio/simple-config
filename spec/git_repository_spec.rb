require 'spec_helper'
require File.expand_path('../../git_repository', __FILE__)


describe 'Gitに特化したリポジトリクラスの拡張' do

  it 'テスト環境の場合、相対パスが指定されているが、絶対パスを返却する' do
    ENV['RAILS_ENV'] = "test"
    expect(GitRepository.create('spec/config').release).to eq Dir::pwd + '/spec/repositories/release.git'
    ENV['RAILS_ENV'] = "production"
    expect(GitRepository.create('spec/config').release).to eq 'git://github.com/sample/release.git'
  end

  it 'テスト環境の場合、テンポラリのディレクトリのパスに入れ替えるclone_to機能を実装する' do
     ENV['RAILS_ENV'] = 'test'
     clone = GitRepository.create('spec/config').clone_to("spec/temp")
     expect(clone.release).to eq Dir::pwd + '/spec/temp/release.git'
  end
end