set shell := ["fish", "-c"]

build ALPINE_VERSION FISH_VERSION:
    docker build \
        --file ./images/Dockerfile-{{FISH_VERSION}} \
        --build-arg ALPINE_VERSION={{ALPINE_VERSION}} \
        --build-arg FISH_VERSION={{FISH_VERSION}} \
        --tag=fish-{{FISH_VERSION}} \
        .
run:
    docker run \
        --interactive \
        --tty \
    fish-{{FISH_VERSION}}:latest

build-3_0: (build "3.11" "3.0")
run-3_0: (run "3.0")
