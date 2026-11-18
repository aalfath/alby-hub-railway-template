# Alby Hub for Railway: the official image, pinned by version and digest.
# Bump both the tag and the digest together, and add a CHANGELOG.md entry.
FROM ghcr.io/getalby/hub:v1.24.7@sha256:7e3de6dac330fb8a426c02a247d81ebaf07deece22634e97d8f20dd48c3a8e38

# All state (SQLite database, LDK node data, logs) lives under WORK_DIR.
# Mount a Railway volume at /data so it survives redeploys and restarts.
ENV WORK_DIR=/data/albyhub \
    PORT=8080

EXPOSE 8080

ENTRYPOINT ["/bin/main"]
