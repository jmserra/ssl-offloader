#!/bin/sh

envsubst '${UPSTREAM}' < "/etc/nginx/nginx.tpl" > "/etc/nginx/nginx.conf"

nginx -g 'daemon off;'

