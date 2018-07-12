FROM nginx:1-alpine

# Install nodejs and git for build
RUN apk add --update \
    nodejs \
    git \
  && rm -rf /var/cache/apk/*

RUN git clone https://github.com/IPS-LMU/emuDB-manager.git /code

WORKDIR /code

# Install dependencies
RUN npm install
COPY app.config.ts src/app

# Build
RUN ./node_modules/.bin/ng build
#RUN ./node_modules/.bin/ng build --prod

RUN cp -r dist/* /usr/share/nginx/html

# nginx configuration
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.vhost.conf /etc/nginx/conf.d/kwplus-nginx.vhost.conf
