############################################################
# nginx proxy to use with t3kit project
# based on https://github.com/jwilder/nginx-proxy
# with modified nginx.tmpl to use with GitHub Actions
############################################################

# hadolint ignore=DL3007
FROM jwilder/nginx-proxy:latest

# nginx-proxy git hash
LABEL nginx-proxy="3a9de2d"

# add modified nginx.tmpl to use with GitHub Actions
COPY nginx.tmpl /app/
