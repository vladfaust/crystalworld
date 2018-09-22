# ![Crystal World](media/logo.png)

[![Built with Crystal](https://img.shields.io/badge/built%20with-crystal-000000.svg?style=flat-square)](https://crystal-lang.org/)
[![Build status](https://img.shields.io/travis/vladfaust/crystalworld/master.svg?style=flat-square)](https://travis-ci.org/vladfaust/crystalworld)
[![Awesome](https://github.com/vladfaust/awesome/blob/badge-flat-alternative/media/badge-flat-alternative.svg)](https://github.com/veelenga/awesome-crystal)
[![vladfaust.com](https://img.shields.io/badge/style-.com-lightgrey.svg?longCache=true&style=flat-square&label=vladfaust&colorB=0a83d8)](https://vladfaust.com)
[![Patrons count](https://img.shields.io/badge/dynamic/json.svg?label=patrons&url=https://www.patreon.com/api/user/11296360&query=$.included[0].attributes.patron_count&style=flat-square&colorB=red&maxAge=86400)](https://www.patreon.com/vladfaust)

Welcome to the Crystal World, a [RealWorld back-end API](https://realworld.io) application implemented in [Crystal](https://crystal-lang.org)!

[![Become Patron](https://vladfaust.com/img/patreon-small.svg)](https://www.patreon.com/vladfaust)

## About

This project is aimed to demonstrate how easy and enjoyable it is to develop a highly-performant web application in [Crystal](https://crystal-lang.org), which is proven to be both *fast* and *slick* language, featuring:

* ⚡️ **Efficiency** comparable to languages like Go and C
* 💎 **Beauty** inherited from Ruby
* 🔒 **Type system** with smart compilator

Crystal World relies on [Prism web framework](https://github.com/vladfaust/prism) and [Core ORM](https://github.com/vladfaust/core) as its foundation. The database chosen is PostgreSQL. Go ahead and read the source code, you'll find it delightfully simple and understandeable! 🍰

*Note that although Crystal itself is not officially released yet, it's already being used in many real-world (including business) applications.*

## Installation

Clone this repository with

```shell
git clone https://github.com/vladfaust/crystalworld.git && cd crystalworld
```

You'll need to [install Crystal Programming Language](https://crystal-lang.org/docs/installation/) for non-docker based installation. You'll also need PostgreSQL installed and running. Write down its access url (e.g. `postgres://postgres:postgres@localhost:5432/crystalworld`), it will be used as `DATABASE_URL` environment variable.

Crystal is a compiled language. It has different compilation modes, e.g. development and production. Production code is faster and packed into a single binary, however it builds slightly longer. Therefore, there are multiple ways to proceed:

### Production build from the source code

1. Set env vars: `export APP_ENV=production DATABASE_URL="" JWT_SECRET_KEY=""`
2. Build the app: `shards build --production --release --no-debug`
3. Apply migrations: `./bin/cake db:migrate`
4. Launch the server: `./bin/server`

### Production build with Docker

*Remember that you'll need to somehow link PostgreSQL to the image.*

1. Build an image: `docker build -t crystalworld:latest .`
2. Apply migrations:`docker run -e DATABASE_URL="" crystalworld bin/cake db:migrate`
3. Launch the server: `docker run -p 5000:5000 -e DATABASE_URL="" -e JWT_SECRET_KEY="" crystalworld`

### Development build

1. Create an `/.env.development` file and put some environment variables there (see below)
1. Apply migrations: `crystal src/bin/cake.cr -- db:migrate` (or install [Cake](https://github.com/axvm/cake) and exec `cake db:migrate`)
2. Launch the server in development mode: `crystal src/bin/server.cr`

Example output:

```
[21:57:17:276] DEBUG > Welcome to the Crystal World! ✨ https://github.com/vladfaust/crystalworld
[21:57:17:276]  INFO > Prism::Server v0.2.0 is listening on http://0.0.0.0:5000
[21:59:39:561]  INFO > SELECT articles.*, '' AS _author, author.username FROM articles JOIN users AS "author" ON "author".id = articles.author_id WHERE (articles.slug = $1)
[21:59:39:562]  INFO > 909μs
[21:59:39:562]  INFO > SELECT favorites.* FROM favorites WHERE (favorites.article_id = $1 AND favorites.user_id = $2)
[21:59:39:563]  INFO > 527μs
[21:59:39:563]  INFO >     GET /articles/how-to-train-your-dragon 200 2.043ms
```

## Environment variables

Crystal World follows [twelve-factor methodology](https://12factor.net/) and therefore relies on environment variables. You can see example and default variables at `/.env.example` file.

## Testing

Crystal has a convenient testing environment built-in. Read more at [Testing docs](https://crystal-lang.org/docs/guides/testing.html). Basically, you place specs under `/spec` folder and run them with `crystal spec`. It's also a good idea to have a separate `/.env.test` file.

## Contributors

- [@vladfaust](https://github.com/vladfaust) Vlad Faust - creator, maintainer
