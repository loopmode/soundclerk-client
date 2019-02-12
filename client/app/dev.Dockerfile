FROM node:10-alpine

RUN apk add --no-cache bash curl python make g++ dos2unix

WORKDIR /opt/soundclerk

COPY .docker-packages/ ./

RUN yarn install

COPY . ./

RUN find . -type f -not -path */node_modules/* -not -path */public/* -print0 | xargs -0 -n 1 -P 4 dos2unix

# client app
EXPOSE 3000
# debugger
EXPOSE 9229

