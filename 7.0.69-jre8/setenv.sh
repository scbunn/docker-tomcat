#!/bin/sh
# ----------------------------------------------------------------------------
# Catalina environments settings (default)
# this file will be evaluated during catalina.sh run
# ----------------------------------------------------------------------------
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=${JMX_PORT:-9012}"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.rmi.port=${JMX_PORT:-9012}"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
export CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=false"
export CATALINA_OPTS="$CATALINA_OPTS -Djava.rmi.server.hostname=${DOCKER_HOST:-127.0.0.1}"
