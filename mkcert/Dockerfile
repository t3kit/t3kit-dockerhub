############################################################
# mkcert docker image to use with t3kit project
# generate locally trusted development certificates
# based on https://github.com/FiloSottile/mkcert
############################################################

FROM golang:1.23.3-alpine3.20

# FiloSottile/mkcert git hash
LABEL mkcert-hash="2a46726"

# Install git, bash
RUN apk add --no-cache git=~2.45 \
&& apk add --no-cache bash=~5.2

# Install mkcert
# RUN go install filippo.io/mkcert@1.4.4
RUN git clone https://github.com/FiloSottile/mkcert && cd mkcert \
&& go build -ldflags "-X main.Version=$(git describe --tags)"

# add Docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/

RUN mkdir -vp /certs/server

WORKDIR /certs/server

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mkcert"]
