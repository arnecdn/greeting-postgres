FROM postgres:16.0

RUN apt-get update && \
    apt-get install -y git build-essential postgresql-server-dev-16 libcurl4-nss-dev \
    locales locales-all

RUN git clone https://github.com/DataDog/pg_tracing.git /pg_tracing && \
    cd /pg_tracing && \
    make PG_VERSION=16 && \
    make install

RUN rm -rf /pg_tracing && \
    apt-get remove --purge -y git build-essential postgresql-server-dev-16 && \
    apt-get autoremove -y && \
    apt-get clean

RUN echo "shared_preload_libraries = 'pg_tracing'" >> /usr/share/postgresql/postgresql.conf.sample