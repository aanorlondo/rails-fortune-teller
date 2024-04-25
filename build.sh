#!/bin/bash
CWD="$(dirname "$(readlink -f "$0")")" || exit 1
host_ip=$(hostname -I | awk '{print $1}')

# clean
docker rm -f FORTUNE-TELLER-LOCAL

# build
docker build -t fortune_teller:rasp4 .

# run
docker run \
    -d \
    -p 3210:3000 \
    --env RAILS_MASTER_KEY="$(cat $CWD/config/master.key)" \
    --add-host="host:${host_ip}" \
    --name FORTUNE-TELLER-LOCAL \
    fortune_teller:rasp4
