FROM alpine:latest
LABEL maintainer=tonyduckles

ENV	PROJECTROOT=/var/lib/git/repositories \
	PROJECTS_LIST=/var/lib/git/projects.list \
	PUID=1000

RUN apk --no-cache add \
# Install gettext, for `envsubst`
	gettext \
# Install nginx packages & modules
	nginx \
	nginx-mod-http-brotli \
# Install gitweb packages
	git-gitweb \
	perl-cgi \
	fcgiwrap \
	spawn-fcgi \
	highlight

RUN set -x \
# Forward access and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
# Create /run/nginx directory, for nginx's default PID location
	&& mkdir -p /run/nginx \
# Create empty nginx extra.conf file
	&& touch /etc/nginx/extra.conf

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

COPY ./nginx/nginx.conf /etc/nginx/default.conf.template

COPY ./gitweb/gitweb.conf /etc/gitweb/gitweb.conf.template

EXPOSE 80

HEALTHCHECK CMD nginx -t &>/dev/null \
	&& wget -O - http://localhost:80/.ping &>/dev/null \
	|| exit 1

CMD ["/docker-entrypoint.sh"]
