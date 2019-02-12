FROM node:10-alpine as builder

RUN apk add --no-cache bash curl python make g++ dos2unix

WORKDIR /opt/soundclerk

COPY .docker-packages/ ./

RUN yarn install

COPY . ./

RUN find . -type f -not -path */node_modules/* -not -path */public/* -print0 | xargs -0 -n 1 -P 4 dos2unix

RUN \
# compile client packages
node_modules/.bin/lerna run build \
    --scope @soundclerk/* \
    --ignore @soundclerk/app \
    --parallel \
    --stream \
# compile client app
&& node_modules/.bin/lerna run build \
    --scope @soundclerk/app \
    --stream


FROM nginx as server
COPY client/app/nginx.default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /opt/soundclerk/client/app/build /usr/share/nginx/html
EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
