# setup base image
FROM mhart/alpine-node:14.17 AS base
WORKDIR /app
COPY package*.json ./
RUN npm ci

# building stage
FROM base AS build
COPY . ./
RUN npm run build
RUN npm prune --production

# production image
FROM mhart/alpine-node:slim-14.17 AS prod
WORKDIR /app
EXPOSE 3000
COPY --from=build /app/build ./
COPY --from=build /app/package.json ./
COPY --from=build /app/node_modules ./node_modules/
CMD ["node", "index.js"]
