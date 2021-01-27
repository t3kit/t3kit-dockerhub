############################################################
# nginx proxy image to use with t3kit project
# based on https://github.com/jwilder/nginx-proxy
# with modified nginx.tmpl to use with GitHub Actions
# with modified nginx.tmpl to enable http together with https
############################################################

# hadolint ignore=DL3007
FROM jwilder/nginx-proxy:0.8.0

# nginx-proxy/nginx-proxy  git hash
LABEL nginx-proxy="c8a6785"

# add modified nginx.tmpl to use with GitHub Actions
COPY nginx.tmpl /app/
