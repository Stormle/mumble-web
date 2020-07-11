#!/bin/sh

websockify --cert=/home/node/mykey.crt --key=/home/node/mykey.key --ssl-only --ssl-target --web=/home/node/dist 1443 localhost:64738 &
websockify --ssl-target --web=/home/node/dist 8080 localhost:64738 &

/usr/bin/murmurd -fg -v
