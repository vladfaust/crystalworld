FROM crystallang/crystal:0.27.2

# Add the app and build it
WORKDIR /app/
ADD . /app
ARG CRYSTAL_ENV=production
RUN shards build --production --release --no-debug --progress --stats

# Run server by default
CMD ["bin/server"]
