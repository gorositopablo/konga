FROM alpine:3.8
COPY . /app
WORKDIR /app
RUN apk upgrade --update \
    && apk --no-cache add bash git ca-certificates \
    && apk --no-cache add --update nodejs npm
RUN apk add --no-cache --virtual=build-dependencies \
     python build-base && \
     npm install && \
     apk del --purge build-dependencies
RUN npm install -g bower \
    && npm --unsafe-perm --production install
RUN apk del git \
    && rm -rf /var/cache/apk/* \
        /app/.git \
        /app/screenshots \
        /app/test \
    && adduser -H -S -g "Konga service owner" -D -u 1200 -s /sbin/nologin konga \
    && mkdir /app/kongadata /app/.tmp \
    && chown -R 1200:1200 /app/views /app/kongadata /app/.tmp
EXPOSE 1337
VOLUME /app/kongadata
ENTRYPOINT ["sh", "/app/start.sh"]