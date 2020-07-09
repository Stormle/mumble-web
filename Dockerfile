FROM node:alpine

LABEL maintainer="Andreas Peters <support@aventer.biz>"

ENV MUMBLE_SERVER=localhost:64738

WORKDIR /home/node

RUN echo http://nl.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk add --update --no-cache git tini websockify murmur openssl ca-certificates python

COPY . .

RUN cp ./murmur.ini /etc/murmur.ini
RUN chown -R node.node /home/node

USER node

RUN npm install
RUN npm run build

ENTRYPOINT ["sh", "./serversetup2.sh"]
