FROM node:current-alpine3.20 AS build
WORKDIR /build

RUN npm -g install pnpm
COPY package.json package.json
COPY pnpm-lock.yaml pnpm-lock.yaml

RUN pnpm i

COPY . .

RUN NODE_OPTIONS="--max-old-space-size=8192" pnpm build

FROM nginx:latest AS base

COPY ./.nginx/gzip.conf /etc/nginx/conf.d/
COPY ./.nginx/default.conf /etc/nginx/conf.d/

COPY --from=build /build/dist /usr/share/nginx/html

EXPOSE 80