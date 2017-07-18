FROM cogniteev/oracle-java:latest

# STARDOG_HOME is user data directory
ENV STARDOG_VER=5.0.1 \
    STARDOG_HOME=/stardog \
    STARDOG=/stardog-5.0.1 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -qq -y unzip

WORKDIR /

# User data directory for $STARDOG_HOME
VOLUME ["/stardog"]

# App directory to be mounted under /
WORKDIR /

# Add the stardog zip file and license if present
COPY resources/* /

# Extract Stardog and add license key if present
RUN \
	unzip -qq /stardog-${STARDOG_VER}.zip && \
	rm -f /stardog-${STARDOG_VER}.zip && \
	mv /stardog-license-key.bin /stardog-${STARDOG_VER}/ 2>/dev/null || true

# Define stardog volume after populating it with stardog binaries
VOLUME /stardog-$STARDOG_VER/

EXPOSE 5820
EXPOSE 80

# remove locks, always replace license key if present, start stardog, echo logs
CMD rm -f /stardog/system.lock || true && \
    cp -f /stardog-$STARDOG_VER/stardog-license-key.bin $STARDOG_HOME 2>/dev/null || true && \
    /stardog-$STARDOG_VER/bin/stardog-admin server start && \
    sleep 1 && \
    (tail -f $STARDOG_HOME/stardog.log &) && \
    while (pidof java > /dev/null); do sleep 1; done