FROM node:20-alpine

RUN apk add --no-cache git

WORKDIR /app
RUN npm install -g serve

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve", "-s", "/data/ente/web/apps/photos/out", "-l", "tcp://0.0.0.0:3000"]

EXPOSE 3000
