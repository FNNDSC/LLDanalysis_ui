# ChRIS_ui production mode server
#
# Build with
#
#   docker build -t <name> .
#
# For example if building a local version, you could do:
#
#   docker build -t local/analysis_ui .
#
# In the case of a proxy (located at say 10.41.13.4:3128), do:
#
#    export PROXY="http://10.41.13.4:3128"
#    docker build --build-arg http_proxy=${PROXY} -t local/analysis_ui .
#
# To run the server up, do:
#
#   docker run --name analysis_ui -p 3000:3000 -d local/analysis_ui
#
# To run an interactive shell inside this container, do:
#
#   docker exec -it analysis_ui sh
#
# Tips:
# - for access logging, remove "--quiet" from CMD
# - docker-entrypoint.sh must start as root


FROM node:20.7 as builder

WORKDIR /app
COPY . .

RUN npm install --legacy-peer-deps
RUN npm run build 



FROM node:20.7-alpine

RUN yarn global add sirv-cli

WORKDIR /app

COPY --from=builder /app/dist /app

ENV HOST=0.0.0.0 PORT=3000
CMD ["sirv", "--etag", "--single"]
EXPOSE 3000

