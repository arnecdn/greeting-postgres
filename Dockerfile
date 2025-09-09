FROM postgres:16.0

RUN apt-get update && \
    apt-get install -y git  \
    build-essential  \
    postgresql-server-dev-16  \
    libcurl4-nss-dev \
    vim \
    locales  \
    locales-all

RUN git clone https://github.com/DataDog/pg_tracing.git /pg_tracing && \
    cd /pg_tracing && \
    make PG_VERSION=16 && \
    make install

RUN rm -rf /pg_tracing && \
    apt-get remove --purge -y git build-essential postgresql-server-dev-16 && \
    apt-get autoremove -y && \
    apt-get clean
 \
    # Add custom config file
COPY postgresql.conf /etc/postgresql/postgresql.conf

# Optionally, set the config file location
ENV POSTGRESQL_CONF=/etc/postgresql/postgresql.conf


# Start PostgreSQL with the custom config
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
