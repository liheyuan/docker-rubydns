#!/bin/sh

if [ x"$RUN_MODE" == x"file" ]; then
    bundle exec ./rubydns.rb -m file
elif [ x"$RUN_MODE" == x"rest" ]; then
    if [ x"$REST_URL" == x"" ];then
        echo "invalid ENV_PARAM REST_URL"
    else
        EXTRA_PARAM=""
        if [ x"$IP_PREFIX" != x"" ];then
            EXTRA_PARAM=" -p $IP_PREFIX"
        fi
        bundle exec ./rubydns.rb -m rest -u $REST_URL $EXTRA_PARAM
    fi
else
    echo "invalid ENV_PARAM RUN_MODE"
    exit -1
fi
