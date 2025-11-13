# syntax=docker/dockerfile:1.4
# Used for Github action 'docker/build-push-action@v3' 
#   to specify the image version, cf. https://docs.docker.com/engine/reference/commandline/buildx_build/#build-context
# hadolint ignore=DL3007
# use 'edge' so automated build on docker hub use it instead of latest stable
FROM alpine:latest as base

# Build arguments
ARG FISH_VERSION=""
ARG BUILD_USING_BINARY="false"
ARG RELEASE_URL="https://github.com/fish-shell/fish-shell/releases/download"

# Build stage for Fish from source
FROM base as fish-builder
WORKDIR /tmp
RUN if [ "$BUILD_USING_BINARY" = "true" ]; then \
        apk add --no-cache --virtual .build-deps \
            curl \
            tar \
            xz \
        && curl \
            --location \
            "${RELEASE_URL}/${FISH_VERSION}/fish-${FISH_VERSION}-linux-x86_64.tar.xz" \
        | tar -xJ \
        && cp ./fish /usr/local/bin/ \
        && apk del .build-deps; \
    fi
# Final stage
FROM base as with-fish

# Copy Fish binary if built from source
COPY --from=fish-builder /usr/local /usr/local

# Common runtime dependencies of the fish shell
# We need bash for devcontainer's feature installation scripts, e.g. https://github.com/devcontainers/features/tree/main/src/git
RUN apk add --no-cache \
    coreutils \
    curl \
    just \
    git \
    bash \
    libgcc \
    ncurses \
    pcre2 \
    gettext && \
    if [ "$BUILD_USING_BINARY" != "true" ]; then \
        apk add --no-cache fish; \
    fi

# Ensure fish is in PATH regardless of installation method
ENV PATH="/usr/local/bin:$PATH"

FROM with-fish AS final
WORKDIR /workspace
COPY ./justfile /workspace/
RUN just \
    print-fish-version \
    add-nemo-user \
    move-to-container-user-home

# As `nemo` user
USER nemo
WORKDIR /home/nemo
RUN just \
    install-fisher \
    install-fishtape

ENTRYPOINT ["fish", "-c"]
CMD [ "fish"]
