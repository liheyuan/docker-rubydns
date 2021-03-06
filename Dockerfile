FROM ruby:2.4-alpine
MAINTAINER coder4

RUN apk update && apk --no-cache add build-base

COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose

EXPOSE 53 53/udp

RUN mkdir /etc/rubydns /app
WORKDIR /app

COPY conf/hosts /etc/rubydns
COPY ./rubydns.rb ./host_map.rb ./run_docker.sh ./ 
# Use env param REST_URL / IP_PREFIX / UPSTREAM / HOSTS
CMD ./run_docker.sh
