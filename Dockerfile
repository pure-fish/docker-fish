# syntax=docker/dockerfile:1.4
# Used for Github action 'docker/build-push-action@v3' 
#   to specify the image version, cf. https://docs.docker.com/engine/reference/commandline/buildx_build/#build-context
# hadolint ignore=DL3007
# use 'edge' so automated build on docker hub use it instead of latest stable
FROM alpine:latest 

# Common runtime dependencies of the fish shell
# We need bash for devcontainer's feature installation scripts, e.g. https://github.com/devcontainers/features/tree/main/src/git
RUN apk add --no-cache \
    coreutils \
    curl \
    make \
    git \
    bash \
    fish

WORKDIR /workspace
COPY ./makefile /workspace/
RUN make \
    print-fish-version \
    add-nemo-user \
    move-to-container-user-home

# As `nemo` user
USER nemo
WORKDIR /home/nemo
RUN make \
    install-fisher \
    install-fishtape

ENTRYPOINT ["fish", "-c"]
CMD [ "fish"]
