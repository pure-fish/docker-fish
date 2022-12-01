# Github action 'docker/build-push-action@v3' can update the 'FROM'
FROM alpine

# Common runtime dependencies of the fish shell
RUN apk add --no-cache \
    coreutils \
    curl \
    git \
    fish

RUN printf "\nUsing \e[38;5;27m%s\e[m\n\n" "$(fish --version)"

ENTRYPOINT ["fish", "-c"]
CMD [ "fish" ]
