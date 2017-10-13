# docker-kanboard-test

## How to run
'''
# Run local
docker run -d -p 53 -p 53/udp -v $PWD/conf:/etc/rubydns coder4/rubydns
# Run as service
docker service --name rubydns coder4/rubydns
'''
