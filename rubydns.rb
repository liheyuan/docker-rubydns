#!/usr/bin/env ruby
require 'rubydns'
require 'optparse'
require './host_map'

include HostMap

# opt define
options = {:mode => "file"}
opts = OptionParser.new do |opts|
  opts.banner = "Usage: rubydns.rb [options]"

  opts.on('-m', '--mode MODE', [:file, :rest], 'file/rest custom dns entry mode') { |v| options[:mode] = v }
  opts.on('-u', '--url URL', 'optional for file mode, valid on rest mode only, rest url for update dns entry, please use ip as host') { |v| options[:url] = v }
  opts.on('-p', '--prefix PREFIX', 'optional, valid on rest mode only, ip prefix filter') { |v| options[:prefix] = v }
  opts.on('-h', '--help', 'Displays Help') { puts opts; exit }

end

# exit
def opt_exit(opts)
  puts opts
  exit
end

# parse
begin
  opts.parse!
  REST_MODE = (options[:mode].to_s == "rest")
  opt_exit(opts) if REST_MODE and not options[:url]
rescue
  opt_exit(opts)
end

# Config
LIST_CONTAINER_URL = options[:url] if REST_MODE 
CONTAINER_IP_PREFIX = options[:prefix] 
HOST_FILE = '/etc/rubydns/hosts'
SLEEP_SECS = 10 

# Entry load mode select
if REST_MODE
  HostMap::schd_load(LIST_CONTAINER_URL, CONTAINER_IP_PREFIX, SLEEP_SECS)
else
  HostMap::file_load(HOST_FILE)
end

# Bind dns
INTERFACES = [
  [:udp, "0.0.0.0", 53],
  [:tcp, "0.0.0.0", 53],
]

IN = Resolv::DNS::Resource::IN

# Use upstream DNS for name resolution.
UPSTREAM = RubyDNS::Resolver.new([[:udp, "8.8.8.8", 53], [:tcp, "8.8.8.8", 53]])

# Start the RubyDNS server
RubyDNS::run_server(INTERFACES) do
  puts IN::A
  match(/(.*)/, IN::A) do |transaction, host|
    ip = HostMap::hostmap[host.to_s]
    transaction.respond!(ip) if ip
  end

  # Default DNS handler
  otherwise do |transaction|
    transaction.passthrough!(UPSTREAM)
  end
end
