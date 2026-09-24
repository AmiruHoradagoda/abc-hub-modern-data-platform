# syntax=docker/dockerfile:1
# Match the supplied NiFi export and existing container.
FROM apache/nifi:2.10.0@sha256:362d7a7caa27f246f2fd8797f906cb216ae71546e15abee5c6b579187c42e28e

USER root
RUN mkdir -p /opt/nifi/drivers
ADD --checksum=sha256:31fbf6f06b2217fb51d5100cee51b22625cc81640da0679b47914e54c1e6377c \
    https://jdbc.postgresql.org/download/postgresql-42.7.12.jar \
    /opt/nifi/drivers/postgresql-42.7.12.jar
RUN chmod 0444 /opt/nifi/drivers/postgresql-42.7.12.jar
USER nifi

# Keep the upstream HTTPS entrypoint. Import the process-group JSON through
# the NiFi UI; it is not a replacement for NiFi's internal flow.json.gz.
