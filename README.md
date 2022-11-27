# Docker Gitweb

[![CI](https://github.com/tonyduckles/docker-gitweb/actions/workflows/ci.yml/badge.svg)](https://github.com/tonyduckles/docker-gitweb/actions/workflows/ci.yml)

Provides a [Gitweb](https://git-scm.com/docs/gitweb) — a Git web interface (web
frontend to Git repositories) - docker image (non official).

## Features

- [Gitweb](https://git-scm.com/docs/gitweb), read access only
- Small image size based on [Alpine Linux](https://alpinelinux.org/)
- Healthcheck endpoint
- Use environment variables for [customization](#Customization)
- GZIP and Brotli support
- Use `X-Forwarded-For` header when getting client IP

## Usage

```yml
version: "2.3"

services:
  gitweb:
    image: ghcr.io/tonyduckles/gitweb:latest
    ports:
      - "8080:80"
    volumes:
      - repo-data:/var/lib/git:ro

volumes:
  repo-data:
```

For the above example to produce anything interesting the volume `repo-data`
must include at least one git repository.

## Customization

### Environment Variables

When you start the container, you can configure Gitweb by passing one or more
environment variables or arguments on the docker run command line.

#### `PUID`

Set the user nginx runs as (default `1000`)

#### `PROJECTROOT`

The directories where your projects are. *Must not end with a slash.*
Default: `PROJECTROOT=/var/lib/git/repositories`

#### `PROJECTS_LIST`

Define which file Gitweb reads to learn the git projects. If set to empty
string; Gitweb simply scan the `PROJECTROOT` directory.
Default: `PROJECTS_LIST=/var/lib/git/projects.list`

### Additional Nginx Configuration

If you'd rather add some additional configuration yourself, you can mount an
additional nginx config at `/etc/nginx/extra.conf`, which will be included in
the primary config.
