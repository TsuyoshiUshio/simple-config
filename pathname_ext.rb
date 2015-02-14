require 'pathname'
require 'uri'

class Pathname
  def git?
    URI(to_s).scheme == 'git'
  end
  def https?
    URI(to_s).scheme == 'https'
  end
end