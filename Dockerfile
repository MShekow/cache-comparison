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

RUN yarn build
