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
# Run docker as file mode
docker run \
    -p 53:53 \
    -p 53:53/udp \
    --volume $PWD/conf:/etc/rubydns \
    --env HOSTS=/etc/rubydns/hosts \
    --detach \
    coder4/rubydns

# Run docker as file & rest mode
docker run \
    -p 53:53 \
    -p 53:53/udp \
    --volume $PWD/conf:/etc/rubydns \
    --env HOSTS=/etc/rubydns/hosts \
    --env REST_URL=http://192.168.99.100/container/list \
    --env IP_PREFIX=10. \
    --detach \
    coder4/rubydns
'''
