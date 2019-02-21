FROM crystallang/crystal:0.27.2

RUN apt-get update &&\
    apt-get upgrade libsqlite3-dev -yqq &&\
    apt-get clean

# Add the app and build it
WORKDIR /app/
ADD . /app
ARG CRYSTAL_ENV=production
RUN shards build --production --release --no-debug --progress --stats

# Run server by default
CMD ["bin/server"]
