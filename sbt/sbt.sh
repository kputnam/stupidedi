#!/bin/sh

FLAGS='-Xmx512M -XX:PermSize=512M -XX:MaxPermSize=512M'

if [ -t 1 ]; then
  # STDOUT is a tty, color is probably OK
  FLAGS="$FLAGS"
else
  # disable specs color
  FLAGS="$FLAGS -Dsbt.log.noformat=true"
fi

java $FLAGS -jar `dirname $0`/sbt-launch.jar "$@"
