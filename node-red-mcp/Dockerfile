ARG BUILD_FROM=ghcr.io/hassio-addons/base:21.0.3
FROM ${BUILD_FROM}

# Install build dependencies (Alpine 3.24 base ships nodejs 22+)
RUN apk add --no-cache git nodejs npm

# Build node-red-mcp from source
RUN git clone --depth 1 https://github.com/ziv-daniel/node-red-mcp.git /opt/node-red-mcp \
    && cd /opt/node-red-mcp \
    && npm install --legacy-peer-deps --no-audit --no-fund \
    && npx tsup \
    && rm -rf .git

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
