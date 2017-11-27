#!/usr/bin/env ruby
require 'rubydns'
require 'optparse'
require './host_map'

include HostMap

# opt define
options = {}
opts = OptionParser.new do |opts|
  opts.banner = "Usage: rubydns.rb [options]"

  opts.on('-t', '--hosts HOSTS', 'optional , extra host file location') { |v| options[:hosts] = v }
  opts.on('-u', '--url URL', 'optional, rest url for update dns entry, please use ip as host') { |v| options[:url] = v }
  opts.on('-p', '--prefix PREFIX', 'optional, ip prefix filter, valid only with url') { |v| options[:prefix] = v }
  opts.on('-s', '--upstream UPSTREAM', 'optional, upstream dns server') { |v| options[:upstream] = v }
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
rescue
  opt_exit(opts)
end

# Config
LIST_CONTAINER_URL = options[:url]
CONTAINER_IP_PREFIX = options[:prefix] 
UPSTREAM_DNS = options[:upstream]
HOST_FILE = options[:hosts] 
SLEEP_SECS = 10 

# Entry load hostfile and restentry
HostMap::schd_load(LIST_CONTAINER_URL, CONTAINER_IP_PREFIX, SLEEP_SECS) if LIST_CONTAINER_URL
HostMap::file_load(HOST_FILE) if HOST_FILE

# Bind dns
INTERFACES = [
  [:udp, "0.0.0.0", 53],
  [:tcp, "0.0.0.0", 53],
]

IN = Resolv::DNS::Resource::IN

# Use upstream DNS for name resolution.
UPSTREAM = UPSTREAM_DNS ? RubyDNS::Resolver.new([[:udp, UPSTREAM_DNS, 53], [:tcp, UPSTREAM_DNS, 53]]) : nil

# Start the RubyDNS server
RubyDNS::run_server(INTERFACES) do
  match(/(.*)/, IN::A) do |transaction, host|
    host_str = host.to_s
    ip = HostMap::locate_ip(host_str)
    if ip
      transaction.respond!(ip)
    else
      transaction.passthrough!(UPSTREAM) if UPSTREAM
    end
  end

  # Default DNS handler
  otherwise do |transaction|
    transaction.passthrough!(UPSTREAM) if UPSTREAM
  end
end
