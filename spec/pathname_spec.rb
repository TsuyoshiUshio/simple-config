require 'spec_helper'
require File.expand_path('../../pathname_ext', __FILE__)

describe 'Pathnameのオープンクラスをテストする' do

  it ' gitのURIに対応する' do
    expect(Pathname.new('git://github.com/abc').git?).to be_truthy
    expect(Pathname.new('https://github.com/abc').git?).to be_falsey
  end
  it 'httpsのURIに対応する' do
    expect(Pathname.new('https://github.com/abc').https?).to be_truthy
    expect(Pathname.new('/User/anonymous/home').https?).to be_falsey
  end

end