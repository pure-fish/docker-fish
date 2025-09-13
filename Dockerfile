# syntax=docker/dockerfile:1.4
# Used for Github action 'docker/build-push-action@v3' 
#   to specify the image version, cf. https://docs.docker.com/engine/reference/commandline/buildx_build/#build-context
# hadolint ignore=DL3007
# use 'edge' so automated build on docker hub use it instead of latest stable
FROM alpine:latest as base

# Build arguments
ARG FISH_VERSION=""
ARG BUILD_FROM_SOURCE="false"

# Build stage for Fish from source
FROM base as fish-builder
RUN if [ "$BUILD_FROM_SOURCE" = "true" ]; then \
        apk add --no-cache --virtual .build-deps \
            build-base \
            cmake \
            ncurses-dev \
            pcre2-dev \
            gettext-dev \
            wget \
            tar \
            rust \
            cargo && \
        wget -O fish-${FISH_VERSION}.tar.xz "https://github.com/fish-shell/fish-shell/releases/download/${FISH_VERSION}/fish-${FISH_VERSION}.tar.xz" && \
        tar -xf fish-${FISH_VERSION}.tar.xz && \
        cd fish-${FISH_VERSION} && \
        cmake -DCMAKE_INSTALL_PREFIX=/usr/local . && \
        make && \
        make install && \
        apk del .build-deps; \
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
    make \
    git \
    bash \
    libgcc \
    ncurses \
    pcre2 \
    gettext && \
    if [ "$BUILD_FROM_SOURCE" != "true" ]; then \
        apk add --no-cache fish; \
    fi

# Ensure fish is in PATH regardless of installation method
ENV PATH="/usr/local/bin:$PATH"

FROM with-fish AS final
WORKDIR /workspace
COPY ./makefile /workspace/
RUN echo "$PATH"
RUN ls /usr/local/ /usr/local/bin/
RUN make print-fish-version 
RUN make add-nemo-user 
RUN make move-to-container-user-home

# As `nemo` user
USER nemo
WORKDIR /home/nemo
RUN make \
    install-fisher \
    install-fishtape

ENTRYPOINT ["fish", "-c"]
CMD [ "fish"]
