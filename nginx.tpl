user  nginx;
worker_processes  1;

pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
}

http {
    log_format main '$time_iso8601 $request_time $status "$request_method $scheme://$host$request_uri" "$http_user_agent" $remote_addr $http_x_forwarded_for';
    access_log /dev/stdout main;
    error_log /dev/stdout notice;
    
    sendfile        on;
    keepalive_timeout  30;
    gzip  on;
    
    map $http_upgrade $connection_upgrade {
        default Upgrade;
        ''      close;
    }

    server {
        listen 443 ssl;
        ssl_certificate /etc/nginx/ssl/certificate.crt;
        ssl_certificate_key /etc/nginx/ssl/private.key;
        server_name _;

        location / {
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Port $server_port;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_pass http://${UPSTREAM};
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            # This allows the ability for the execute shell window to remain open for up to 15 minutes. Without this parameter, the default is 1 minute and will automatically close.
            proxy_read_timeout 900s;
        }
    }
    
    server {
        listen 80;
        server_name _;
        return 301 https://$server_name$request_uri;
    }
}
