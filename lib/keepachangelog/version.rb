require 'json'

module Keepachangelog
  def self.version
    path = File.expand_path('../../package.json', File.dirname(__FILE__))
    file = File.read path
    json = JSON.parse file
    json['version']
  end
end
