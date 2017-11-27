require 'net/http'
require 'uri'
require 'json'

module HostMap
  attr_accessor :localMap
  attr_accessor :restMap

  @localMap = Hash.new()
  @restMap = Hash.new()

  def file_load(file)
    @localMap = Hash[*File.read(file).split(/\s+/)]
  end

  def schd_load(list_container_url, prefix, sleep_sec)
    @restMap = Hash.new()
    Thread.new {
      while true
        begin
          # get from api & make new map
          containers = JSON.parse(Net::HTTP.get(URI.parse(list_container_url)))
          restmap_new = Hash.new()
          containers.each do |container|
            ip = container["ipList"].select {|ip| prefix ? ip.start_with?(prefix) : true  }
            restmap_new[container["hostname"]] = ip[0] if ip.size() > 0
          end
          # update map & sleep
          @restMap = restmap_new 
        rescue Exception => e
          puts e
        ensure
          sleep sleep_sec
        end
      end
    }
  end

  def locate_ip(host)
    ip_local = @localMap[host]
    return ip_local if ip_local
    ip_rest = @restMap[host]
    return ip_rest if ip_rest
    return nil
  end

end
