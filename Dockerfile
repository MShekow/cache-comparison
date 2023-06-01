# syntax=docker/dockerfile:1
FROM node:14.18.1 AS dependencies

WORKDIR /app
COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/root/.yarn,id=yarn_cache yarn install --frozen-lockfile --cache-folder /root/.yarn
COPY . .

#######################################
FROM dependencies AS tests

RUN yarn test

#######################################
FROM tests AS build
ADD --chmod=755 https://github.com/MShekow/directory-checksum/releases/download/v1.4.1/directory-checksum_1.4.1_linux_amd64 /usr/local/bin/directory-checksum
RUN directory-checksum --max-depth=4 && yarn build
