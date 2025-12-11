#!/bin/bash
#  /----------------------------------------------------------------\
# | Apache AirFlow = DEV-ONLY Linux Installer (Docker Compose)       |
# |                                                                  |
# | Documentation:                                                   |
# | https://airflow.apache.org/docs/apache-airflow/stable/index.html |
# |                                                                  |
# | MIT License                                                      |
# | Copyright (c) 2025 Guldir (lucasromulosr@github/linkedin)        |
# | See the LICENSE file in this repository for full license text.   |
#  \----------------------------------------------------------------/

set -euo pipefail

command -v curl >/dev/null 2>&1 || { printf >&2 "You need to install curl first.\n"; exit 1; }
command -v awk  >/dev/null 2>&1 || { printf >&2 "You need to install awk first.\n"; exit 1; }

if docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD=(docker compose)
elif docker-compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD=(docker-compose)
else
    printf >&2 "You need to install docker compose first.\n"
    exit 1
fi

YAML_URL="https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml"
YAML_FILENAME="docker-compose.yaml"
ENV_FILENAME=".env"
ENV_TEMP_FILENAME=".env.tmp"
CFG_FILENAME="./config/airflow.cfg"

# fetch docker compose yaml
[ ! -f "$YAML_FILENAME" ] && curl -fSL --retry 3 --retry-delay 2 --retry-connrefused "$YAML_URL" -o "$YAML_FILENAME"

# create airflow dirs
mkdir -p ./dags ./logs ./plugins ./config

# ---------- create/update .env -----------------
# create .env
[ -f "$ENV_FILENAME" ] || touch "$ENV_FILENAME"

# update AIRFLOW_UID with curr user id
awk -v uid="$(id -u)" '
    BEGIN { updated = 0 }
    /^AIRFLOW_UID=/ {
        print "AIRFLOW_UID=" uid
        updated = 1
        next
    }
    { print }
    END {
        if (!updated) {
            print "AIRFLOW_UID=" uid
        }
    }
' "$ENV_FILENAME" > "$ENV_TEMP_FILENAME" && mv "$ENV_TEMP_FILENAME" "$ENV_FILENAME"
# -----------------------------------------------

# initialize airflow cfg and database
if (( "${#DOCKER_COMPOSE_CMD[@]}" )) && [ ! -f "$CFG_FILENAME" ]; then
    "${DOCKER_COMPOSE_CMD[@]}" run airflow-cli airflow config list
    "${DOCKER_COMPOSE_CMD[@]}" up airflow-init
fi
