FROM alpine:3.17

# Common runtime dependencies of the fish shell
RUN apk add --no-cache \
    coreutils \
    curl \
    git \
    fish

RUN printf "\nUsing \e[38;5;27mFish-%s\e[m\n\n" $(fish --version)

ENTRYPOINT ["fish", "-c"]
CMD [ "fish" ]
