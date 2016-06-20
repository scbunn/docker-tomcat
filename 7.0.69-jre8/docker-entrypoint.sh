#!/bin/bash
# ----------------------------------------------------------------------------
# Docker entrypoint for Tomcat 
# 
# 0) Configure ENV vars 
# 1) Run /app_setup.sh if exists
# 2) Run catalina.sh run
# ----------------------------------------------------------------------------
set -e

if [ "$1" == "tomcat" ]; then
  # if we need to communicate back to the docker host we need to know
  # how to reach it.  This is achieved with the ENV DOCKER_HOST.

  # if an app_setup.sh script exists, run it.
  if [ -f "/app_setup.sh" ]; then
    chmod +x /app_setup.sh
    /app_setup.sh
  fi

  # Run tomcat
  echo "Starting Tomcat"
  exec gosu tomcat "$CATALINA_HOME/bin/catalina.sh" run
else
  exec "$@"
fi


