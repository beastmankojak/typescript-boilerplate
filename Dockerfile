FROM node:lts-bookworm as builder
RUN npm i -g pnpm \
  && apt-get update \
  && apt-get install -y --no-install-recommends dumb-init
COPY . /app
WORKDIR /app
RUN pnpm install --frozen-lockfile && pnpm run build

FROM node:lts-bookworm-slim
RUN npm i -g pnpm
COPY --from=builder --chown=node:node /app/package.json /app/package.json
COPY --from=builder --chown=node:node /app/pnpm-lock.yaml /app/pnpm-lock.yaml
COPY --from=builder --chown=node:node /app/dist /app/dist
COPY --from=builder /usr/bin/dumb-init /usr/bin/dumb-init
USER node
WORKDIR /app
RUN pnpm install --frozen-lockfile --prod
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "dist/index"]