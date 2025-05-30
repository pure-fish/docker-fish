set shell := ["fish", "-c"]

build ALPINE_VERSION FISH_VERSION verbose="verbose":
    @printf "verbosity: %s\n\n  " {{ verbose }}
    docker buildx build \
        {{ if verbose == "verbose" {""} else { "--quiet" } }} \
        --build-context alpine=docker-image://alpine:{{ ALPINE_VERSION }} \
        --file ./Dockerfile \
        --tag=fish-{{ FISH_VERSION }} \
        ./

run FISH_VERSION:
    docker run \
        --interactive \
        --tty \
    fish-{{ FISH_VERSION }}:latest

test FISH_VERSION:
    docker run \
        --rm \
        fish-{{ FISH_VERSION }} \
        'fish --version | grep {{ FISH_VERSION }}'

build-3-0-2 verbose="false": (build "3.11" "3.0.2" verbose)
run-3-0-2: (run "3.0.2")

build-3-1-2 verbose="false": (build "3.13" "3.1.2" verbose)
run-3-1-2: (run "3.1.2")

build-3-2-2 verbose="false": (build "3.14" "3.2.2" verbose)
run-3-2-2: (run "3.2.2")

build-3-3-1 verbose="false": (build "3.15" "3.3.1" verbose)
run-3-3-1: (run "3.3.1")

build-3-4-1 verbose="false": (build "3.16" "3.4.1" verbose)
run-3-4-1: (run "3.4.1")

build-3-5-1 verbose="false": (build "3.17" "3.5.1" verbose)
run-3-5-1: (run "3.5.1")

build-3-6-1 verbose="false": (build "3.18" "3.6.1" verbose)
run-3-6-1: (run "3.6.1")

build-3-6-3 verbose="false": (build "3.19" "3.6.3" verbose)
run-3-6-3: (run "3.6.3")

build-3-7-1 verbose="false": (build "3.21" "3.7.1" verbose)
run-3-7-1: (run "3.7.1")

build-4-0-2 verbose="false": (build "edge" "4.0.2" verbose)
run-4-0-2: (run "4.0.2")

# build-3-6-2 verbose="false": (build "edge" "3.6.2" verbose)
# run-3-6-2: (run "3.6.2")