# caddy

[![][circleci]][circleci 2]
[![][microbadger]][microbadger 2]
[![][microbadger 3]][microbadger 2]

A [Docker][docker] image for [Caddy][caddyserver]. This
image includes cross-platform support, as well as the following Caddy plugins:

* [git][caddyserver 2]
* [filemanager][caddyserver 3]
* [cors][caddyserver 4]
* [realip][caddyserver 5]
* [expires][caddyserver 6]
* [cache][caddyserver 7]
* [cloudflare (for DNS challenge authentication)][caddyserver 8]

## Getting Started
Here we lay out some very basic use-cases for Caddy; for complete documentation,
check out the [Caddy website][caddyserver] or e.g., the [caddy-docker
repo][https://github.com/abiosoft/caddy-docker].

## Getting Started

```sh
$ docker run -d -p 2015:2015 jessestuart/caddy
```

Point your browser to `http://127.0.0.1:2015`.

### Let's Encrypt Subscriber Agreement

Caddy may prompt you to agree to
[Let's Encrypt Subscriber Agreement][letsencrypt].
This is configurable with `ACME_AGREE` environment variable. Set it to true to
agree. `ACME_AGREE=true`.

### Default Caddyfile

The image contains a default Caddyfile.

```
0.0.0.0
browse
fastcgi / 127.0.0.1:9000 php # php variant only
on startup php-fpm7 # php variant only
```

The last 2 lines are only present in the PHP variant.

#### Paths in container

- Caddyfile: `/etc/Caddyfile`

- Sites root: `/srv`

#### Using local Caddyfile and sites root

Replace `/path/to/Caddyfile` and `/path/to/sites/root` accordingly.

```sh
$ docker run -d \
    -v /path/to/sites/root:/srv \
    -v path/to/Caddyfile:/etc/Caddyfile \
    -p 2015:2015 \
    jessestuart/caddy
```

### Let's Encrypt Auto SSL

**Note** that this does not work on local environments.

Use a valid domain and add email to your Caddyfile to avoid prompt at runtime.
Replace `mydomain.com` with your domain and `user@host.com` with your email.

```
mydomain.com
tls user@host.com
```

[caddyserver]: https://caddyserver.com
[caddyserver 2]: https://caddyserver.com/docs/http.git
[caddyserver 3]: https://caddyserver.com/docs/http.filemanager
[caddyserver 4]: https://caddyserver.com/docs/http.cors
[caddyserver 5]: https://caddyserver.com/docs/http.realip
[caddyserver 6]: https://caddyserver.com/docs/http.expires
[caddyserver 7]: https://caddyserver.com/docs/http.cache
[caddyserver 8]: https://caddyserver.com/docs/tls.dns.cloudflare
[caddyserver 9]: https://caddyserver.com/docs/telemetry
[circleci]: https://circleci.com/gh/jessestuart/caddy-multiarch/tree/master.svg?style=shield
[circleci 2]: https://circleci.com/gh/jessestuart/caddy-multiarch/tree/master
[docker]: https://docker.com
[getcomposer]: https://getcomposer.org
[github]: https://github.com/mholt/caddy/tree/v0.11.0
[github 2]: https://github.com/mholt/caddy
[letsencrypt]: https://letsencrypt.org/documents/2017.11.15-LE-SA-v1.2.pdf
[letsencrypt 2]: https://letsencrypt.org/docs/rate-limits/
[letsencrypt 3]: https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769
[microbadger]: https://images.microbadger.com/badges/image/jessestuart/caddy.svg
[microbadger 2]: https://microbadger.com/images/jessestuart/caddy
[microbadger 3]: https://images.microbadger.com/badges/version/jessestuart/caddy.svg
[shields]: https://img.shields.io/badge/version-0.11.0-blue.svg
