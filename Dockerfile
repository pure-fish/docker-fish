# syntax=docker/dockerfile:1.4
# Used for Github action 'docker/build-push-action@v3' 
#   to specify the image version, cf. https://docs.docker.com/engine/reference/commandline/buildx_build/#build-context
FROM alpine:latest

# Common runtime dependencies of the fish shell
RUN apk add --no-cache \
    coreutils \
    curl \
    make \
    git \
    fish

# for `root` user
COPY ./makefile ./ 
RUN make \
    print-fish-version \
    add-nemo-user \
    move-to-container-user-home
USER nemo
WORKDIR /home/nemo

# for `nemo` user
RUN make install-fisher
RUN make install-fishtape

ENTRYPOINT ["fish", "-c"]
CMD [ "fish"]
