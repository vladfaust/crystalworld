#!/bin/sh

set -eux

project_dir=$(dirname $(realpath "docker-entrypoint.sh"))

run() {
	DATABASE_URL=$1 JWT_SECRET_KEY=$2 $project_dir/bin/server
}

migrate() {
	DATABASE_URL=$1 $project_dir/bin/cake db:migrate
}

# the number of hex digits in the JWT secret
jwt_size=${jwt_size:-16}

# allows overriding the random generation script
gen_jwt=${gen_jwt:-"crystal eval puts Random::Secure.hex 16"}

# Set the JWT to either the given value of $JWT_SECRET_KEY or the evaluation of the
# command stored in the $gen_jwt variable
JWT_SECRET_KEY=${JWT_SECRET_KEY:-"$($gen_jwt)"}

DATABASE_URL=${DATABASE_URL:-"sqlite3://./crystalworld.db"}
db_proto=$(printf $DATABASE_URL | sed -rn 's_^(\w+://).+$_\1_p')
# In the case of SQLite the rest of the URL is the filepath
rest_of_url=$(printf $DATABASE_URL | sed 's_^\w+://__')

# if there's no file at the location specifed by $DATABASE_URL
if ! [ -f $rest_of_url ]; then
  if [ $db_proto = "sqlite3://" ]; then
    migrate $DATABASE_URL
	else
		echo "unsupported database protocol $db_proto"
		exit 64
  fi
fi

run $DATABASE_URL $JWT_SECRET_KEY
