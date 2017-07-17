FROM cogniteev/oracle-java:latest

# STARDOG_HOME is user data directory
ENV STARDOG_VER=5.0.1 \
    STARDOG_HOME=/stardog \
    STARDOG=/stardog-5.0.1 \
    DEBIAN_FRONTEND=noninteractive

WORKDIR /

# User data directory for $STARDOG_HOME
VOLUME ["/stardog"]

# App directory to be mounted under /
WORKDIR /
ADD resources/stardog-${STARDOG_VER}.tar.gz /
ADD resources/stardog-license-key.bin /stardog-${STARDOG_VER}/

# Define stardog volume after populating it with stardog binaries
VOLUME /stardog-$STARDOG_VER/

EXPOSE 5820
EXPOSE 80

# remove locks, always replace license key, start stardog, echo logs
CMD rm -f /stardog/system.lock || true && \
    cp /stardog-$STARDOG_VER/stardog-license-key.bin $STARDOG_HOME && \
    /stardog-$STARDOG_VER/bin/stardog-admin server start && \
    sleep 1 && \
    (tail -f $STARDOG_HOME/stardog.log &) && \
    while (pidof java > /dev/null); do sleep 1; done