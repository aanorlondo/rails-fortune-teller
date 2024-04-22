#!/bin/bash
CWD="$(dirname "$(readlink -f "$0")")" || exit 1
host_ip=$(ipconfig getifaddr en0)

# clean
docker rm -f FORTUNE-TELLER-LOCAL

# build
docker build -t fortune_teller:local .

# run
docker run \
    -d \
    -p 3210:3000 \
    --env RAILS_MASTER_KEY="$(cat $CWD/config/master.key)" \
    --add-host="host:${host_ip}" \
    --name FORTUNE-TELLER-LOCAL \
    fortune_teller:local
