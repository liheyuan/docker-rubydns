require 'net/http'
require 'uri'
require 'json'

module HostMap
  attr_accessor :hostmap

  def initialize
    @hostmap = Hash.new()
  end

  def file_load(file)
    @hostmap = Hash[*File.read(file).split(/\s+/)]
  end

  def schd_load(list_container_url, prefix, sleep_sec)
    Thread.new {
      while true
        begin
          # get from api & make new map
          containers = JSON.parse(Net::HTTP.get(URI.parse(list_container_url)))
          hostmap_new = Hash.new()
          containers.each do |container|
            ip = container["ipList"].select {|ip| prefix ? ip.start_with?(prefix) : true  }
            hostmap_new[container["hostname"]] = ip[0] if ip.size() > 0
          end
          # update map & sleep
          @hostmap = hostmap_new 
          sleep sleep_sec
        rescue Exception => e
          puts e
        end
      end
    }
  end

end
