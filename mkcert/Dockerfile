############################################################
# mkcert docker image to use with t3kit project
# generate locally trusted development certificates
# based on https://github.com/FiloSottile/mkcert
############################################################

FROM golang:1.13.5-alpine

# FiloSottile/mkcert git hash
LABEL mkcert-hash="64cb80e"

# Install git, bash
RUN apk add --no-cache git=~2.24 \
&& apk add --no-cache bash=~5.0

# Install mkcert
RUN go get -v -u github.com/FiloSottile/mkcert

# add Docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/

RUN mkdir -vp /certs/server

WORKDIR /certs/server

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mkcert"]
