FROM python:3.10-alpine AS build
LABEL org.opencontainers.image.authors="Marcin Sztolcman <marcin@urzenia.net>"

ARG VERSION=2.2.2

RUN addgroup -S sendria && adduser -S sendria -G sendria

RUN apk add --no-cache bash
WORKDIR /home/sendria
USER sendria

COPY --chown=sendria:sendria . .
RUN python3 -m pip install --user .
ENV PATH="/home/sendria/.local/bin:$PATH"
WORKDIR /home/sendria/sendria
RUN webassets -m sendria.build_assets build


EXPOSE 1025 1080
WORKDIR /home/sendria

ENTRYPOINT [ "sendria", "--foreground", "--db=./mails.sqlite", "--smtp-ip=0.0.0.0", "--http-ip=0.0.0.0" ]