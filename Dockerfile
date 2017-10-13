FROM ruby:2.4-alpine
MAINTAINER coder4

RUN apk update && apk --no-cache add build-base

COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose

EXPOSE 53 53/udp

RUN mkdir /etc/rubydns
COPY hosts /etc/rubydns

RUN mkdir /app
WORKDIR /app

COPY rubydns.rb ./
CMD bundle exec ./rubydns.rb
