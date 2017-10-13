#!/bin/bash

bundle install --binstubs --verbose
sudo bundle exec ./rubydns.rb
