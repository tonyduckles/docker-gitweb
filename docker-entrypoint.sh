#!/usr/bin/env sh

set -e

# Update GECOS field for user=root, for prettier file-owner username
awk -F ":" \
    '
    $1=="root" { gecos="'"$ROOT_GECOS"'"; print $1":"$2":"$3":"$4":"gecos":"$6":"$7 }
    $1!="root" { print }
    ' /etc/passwd > /etc/passwd.edit
mv -f /etc/passwd.edit /etc/passwd

# Generate nginx config
envsubst '$PROJECTROOT' < /etc/nginx/default.conf.template > /etc/nginx/http.d/default.conf

# Generate gitweb config
envsubst '$PROJECTROOT$PROJECTS_LIST' < /etc/gitweb/gitweb.conf.template > /etc/gitweb/gitweb.conf

# Launch the fcgi server.
# Run as root so we can read repositories regardless
# and let nginx own socket so we can talk.
spawn-fcgi -s /var/run/fcgiwrap.socket -M 0666 -U nginx -- /usr/bin/fcgiwrap

# Start nginx
exec nginx -g "daemon off;"
