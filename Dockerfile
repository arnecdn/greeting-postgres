FROM postgres:16.0

RUN apt-get update && \
    apt-get install -y git build-essential postgresql-server-dev-16 libcurl4-nss-dev  \
    locales && rm -rf /var/lib/apt/lists/*

# Install locale generation tools (if not present)
#RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/*

# Uncomment or add the desired locale in locale.gen
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen  \
    locale-gen en_US.UTF-8

# Set environment variables for the locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8 \

RUN git clone https://github.com/DataDog/pg_tracing.git /pg_tracing && \
    cd /pg_tracing && \
    make PG_VERSION=16 && \
    make install

RUN rm -rf /pg_tracing && \
    apt-get remove --purge -y git build-essential postgresql-server-dev-16 && \
    apt-get autoremove -y && \
    apt-get clean

RUN echo "shared_preload_libraries = 'pg_tracing'" >> /usr/share/postgresql/postgresql.conf.sample