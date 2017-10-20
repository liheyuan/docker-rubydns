# docker-kanboard-test

## How to test
'''
# run in file mode (load custom from /etc/rubydns/hosts)
ruby ./rubydns.rb -m file
# or run in rest mode (load from rest api, see https://github.com/liheyuan/docker-swarm-dict)
ruby ./rubydns.rb -m rest -u http://192.168.99.100:8080/container/list -p 10.
# dig
dig @localhost -p 53 hostname 
'''

## How to run
'''
# Run local
docker run -d -p 53 -p 53/udp -v $PWD/conf:/etc/rubydns coder4/rubydns
# Run as service
docker service --name rubydns coder4/rubydns
'''
