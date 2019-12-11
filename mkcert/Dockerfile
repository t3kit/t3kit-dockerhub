############################################################
# mkcert docker image to use with t3kit project
# generate locally trusted development certificates
# based on https://github.com/FiloSottile/mkcert
############################################################

FROM golang:1.13.5-alpine

# Install git, bash
RUN apk add --no-cache git=~2.22
RUN apk add --no-cache bash=~5.0


# Install mkcert
RUN go get -v -u github.com/FiloSottile/mkcert

# FiloSottile/mkcert git hash
LABEL mkcert_hash="cb6311c"

# add Docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/


WORKDIR /certs

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["mkcert"]