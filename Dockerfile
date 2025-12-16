# syntax=docker/dockerfile:1

ARG POSTGRES_TAG=18
FROM postgres:${POSTGRES_TAG}

ARG SUPERCRONIC_VERSION
# renovate: datasource=github-releases depName=EnterpriseDB/system_stats
ARG SYSTEM_STATS_EXTENSION_VERSION="3.2"
# renovate: datasource=github-releases depName=tensorchord/VectorChord
ARG VCHORD_EXTENSION_VERSION="0.4.3"

ENV TZ=UTC
ENV LANG=en_US.utf8
ENV PGPORT=5432
ENV PGUSER=postgres
ENV PGDATA=/var/lib/postgresql/data
ENV PGBACK_DATA=/var/lib/pgbackrest

# --- Install Dependencies & Tools ---
RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    wget \
    bash \
    pgbackrest \
    ca-certificates \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# postgresql-server-dev-${PG_MAJOR} \
COPY . /
RUN chmod +x /entrypoint.sh

# --- Install SuperCronic ---
RUN wget -O /usr/local/bin/supercronic "https://github.com/aptible/supercronic/releases/download/${SUPERCRONIC_VERSION}/supercronic-linux-amd64" \
    && chmod +x /usr/local/bin/supercronic

ENTRYPOINT ["/entrypoint.sh"]

STOPSIGNAL SIGINT

CMD ["postgres"]