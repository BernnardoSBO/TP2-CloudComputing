FROM node:18-alpine3.17 as builder
RUN mkdir /client
COPY ./client ./client
WORKDIR /client
RUN npm install
RUN npm run k8s-build

FROM nginx:stable

RUN apt-get update
RUN apt-get install dnsutils -y

COPY --from=builder /client/dist /usr/share/nginx/client
RUN rm /etc/nginx/conf.d/default.conf
COPY --from=builder /client/nginx.default.conf /etc/nginx/conf.d