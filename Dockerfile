FROM node:22-alpine

WORKDIR /app

RUN apk add --no-cache postgresql-client

COPY dist ./dist
COPY init.sql ./init.sql

ENV NODE_ENV=production
EXPOSE 8080

CMD psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f /app/init.sql && exec node --enable-source-maps ./dist/index.mjs
FROM node:22-alpine

WORKDIR /app

COPY dist ./dist

ENV NODE_ENV=production
EXPOSE 8080

CMD ["node", "--enable-source-maps", "./dist/index.mjs"]
