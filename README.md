# caddy

[![dockerhub-pulls-badge]][dockerhub-link]
[![][microbadger]][microbadger 2]
[![][circleci]][circleci 2]

A [Docker][docker] image for [Caddy][caddyserver]. This
image includes cross-platform support, as well as the following Caddy plugins:

- [git][caddyserver 2]
- [cors][caddyserver 4]
- [realip][caddyserver 5]
- [expires][caddyserver 6]
- [cache][caddyserver 7]
- [cloudflare (for DNS challenge authentication)][caddyserver 8]

## Getting Started

For complete documentation, check out the [Caddy website][caddyserver] or e.g.,
the [caddy-docker repo](https://github.com/abiosoft/caddy-docker).

To get started, run the following, and point your browser to
`http://127.0.0.1:2015`.

```sh
$ docker run -d -p 2015:2015 jessestuart/caddy
```

### Let's Encrypt Subscriber Agreement

Caddy may prompt you to agree to [Let's Encrypt Subscriber
Agreement][letsencrypt]. This is configurable with `ACME_AGREE` environment
variable.

### Default Caddyfile

The image contains a default Caddyfile:

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

Use a valid domain and add email to your Caddyfile to avoid prompt at runtime.
Replace `mydomain.com` with your domain and `user@host.com` with your email.

**Note** that this does not work on local environments.

```
mydomain.com
tls user@host.com
```

[caddyserver 2]: https://caddyserver.com/docs/http.git
[caddyserver 4]: https://caddyserver.com/docs/http.cors
[caddyserver 5]: https://caddyserver.com/docs/http.realip
[caddyserver 6]: https://caddyserver.com/docs/http.expires
[caddyserver 7]: https://caddyserver.com/docs/http.cache
[caddyserver 8]: https://caddyserver.com/docs/tls.dns.cloudflare
[caddyserver 9]: https://caddyserver.com/docs/telemetry
[caddyserver]: https://caddyserver.com
[circleci 2]: https://circleci.com/gh/jessestuart/caddy-multiarch/tree/master
[circleci]: https://img.shields.io/circleci/project/github/jessestuart/caddy-multiarch.svg
[docker]: https://docker.com
[dockerhub-link]: https://hub.docker.com/r/jessestuart/caddy/
[dockerhub-pulls-badge]: https://img.shields.io/docker/pulls/jessestuart/caddy.svg
[getcomposer]: https://getcomposer.org
[github 2]: https://github.com/mholt/caddy
[github]: https://github.com/mholt/caddy/tree/v0.11.0
[letsencrypt 2]: https://letsencrypt.org/docs/rate-limits/
[letsencrypt 3]: https://community.letsencrypt.org/t/rate-limits-for-lets-encrypt/6769
[letsencrypt]: https://letsencrypt.org/documents/2017.11.15-LE-SA-v1.2.pdf
[microbadger 2]: https://microbadger.com/images/jessestuart/caddy
[microbadger]: https://images.microbadger.com/badges/image/jessestuart/caddy.svg
[shields]: https://img.shields.io/badge/version-0.11.0-blue.svg
