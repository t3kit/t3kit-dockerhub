############################################################
# nginx proxy image to use with t3kit project
# based on https://github.com/nginx-proxy/nginx-proxy
# with modified nginx.tmpl to enable http together with https
############################################################

# hadolint ignore=DL3007
FROM nginxproxy/nginx-proxy:0.9-alpine

ENV HTTPS_METHOD=noredirect

# hadolint ignore=SC1141
RUN { \
        echo 'client_max_body_size 200M;'; \
    } > /etc/nginx/conf.d/nproxy.conf; \
    mkdir -vp /nproxy/certs

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["forego", "start", "-r"]
