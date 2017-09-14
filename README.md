# Generic SSL Offloader using nginx as proxy

Needs a valid certificate into the same folder on the server running the container

Uses `UPSTREAM` environment variable to `proxy_pass: http://${UPSTREAM};`

Redirects connections made on port 80 to https://{host}{path}

## Running the service

Have a folder somewhere in the docker host (ex: /home/user/ssl) with the following files:
- certificate.crt : containing the certificate (+ chain if wanted)
- private.key : containing the server private key

Run the container mounting the volume like so:

`docker run -d --restart=always -e UPSTREAM=mybackend:8080 --link mybackend -p 443:443 -v /home/user/ssl:/etc/nginx/ssl --name ssl-offloader jmserra/ssl-offloader`