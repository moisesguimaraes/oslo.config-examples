FROM nginx

LABEL maintainer="Moisés Guimarães de Medeiros <moguimar@redhat.com>"

COPY nginx /etc/nginx

RUN sed -i -e 's,conf.d/flask.conf,conf.d/flask-prod.conf,' /etc/nginx/nginx.conf
