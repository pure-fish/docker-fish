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

build-3-0-2: (build "3.11" "3.0.2")
run-3-0-2: (run "3.0.2")

build-3-1-2: (build "3.13" "3.1.2")
run-3-1-2: (run "3.1.2")

build-3-2-2: (build "3.14" "3.2.2")
run-3-2-2: (run "3.2.2")

build-3-3-1: (build "3.15" "3.3.1")
run-3-3-1: (run "3.3.1")

build-3-4-1: (build "3.16" "3.4.1")
run-3-4-1: (run "3.4.1")

build-3-5-1: (build "3.17" "3.5.1")
run-3-5-1: (run "3.5.1")
