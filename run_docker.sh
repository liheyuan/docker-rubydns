#!/bin/sh

HOSTS_PARAM=""
if [ x"$HOSTS" != x"" ];then
    HOSTS_PARAM=" -t $HOSTS"
fi

UPSTREAM_PARAM=""
if [ x"$UPSTREAM" != x"" ];then
    UPSTREAM_PARAM=" -s $UPSTREAM"
fi

REST_URL_PARAM=""
if [ x"$REST_URL" != x"" ];then
    REST_URL_PARAM=" -u $REST_URL"
fi

IP_PREFIX_PARAM=""
if [ x"$IP_PREFIX" != x"" ];then
    IP_PREFIX_PARAM=" -p $IP_PREFIX"
fi

bundle exec ./rubydns.rb $HOSTS_PARAM $UPSTREAM_PARAM $REST_URL_PARAM $IP_PREFIX_PARAM
