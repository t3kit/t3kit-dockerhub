# Start nginx proxy to use with t3kit project

[Based on Automated Nginx Reverse Proxy for Docker](https://github.com/jwilder/nginx-proxy)

Use it to handle several **t3kit** projects in one local machine. The main advantage of it is just to use one `VIRTUAL_HOST` env variable to separate it from other projects

## Quick start

```shell
docker network create nproxy
docker run -d -p=80:80 --name=nproxy --restart=unless-stopped --network=nproxy -v=/var/run/docker.sock:/tmp/docker.sock:ro jwilder/nginx-proxy
```

***

Check [t3kit starter kit](https://github.com/t3kit/t3kit-starter) with all needed documentation to start.
