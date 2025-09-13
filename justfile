set shell := ["fish", "-c"]

# Internal build recipe (prefixed with _ to indicate private)
build FISH_VERSION ALPINE_VERSION BUILD_FROM_SOURCE="false" verbose="false":
    @printf "Building Fish {{ FISH_VERSION }} from {{ if BUILD_FROM_SOURCE == "true" { "source" } else { "package" } }}\n"
    @printf "verbosity: %s\n\n  " {{ verbose }}
    docker buildx build \
        {{ if verbose == "verbose" {""} else { "--quiet" } }} \
        --build-context alpine=docker-image://alpine:{{ ALPINE_VERSION }} \
        --build-arg FISH_VERSION={{ FISH_VERSION }} \
        --build-arg BUILD_FROM_SOURCE={{ BUILD_FROM_SOURCE }} \
        --file ./Dockerfile \
        --tag=fish-{{ FISH_VERSION }}.alpine-{{ ALPINE_VERSION }} \
        ./

run FISH_VERSION ALPINE_VERSION:
    docker run \
        --interactive \
        --tty \
        fish-{{ FISH_VERSION }}.alpine-{{ ALPINE_VERSION }}

test FISH_VERSION ALPINE_VERSION:
    #!/usr/bin/env fish
    set expected "{{ FISH_VERSION }}"
    set actual (docker run --rm fish-{{ FISH_VERSION }}.alpine-{{ ALPINE_VERSION }} 'fish --version')
    
    if echo "$actual" | grep -q "$expected"
        echo (set_color --bold --background green)"✓ fish version $expected"(set_color normal)" is correctly installed"
    else
        echo (set_color --bold --background red)"✗ $actual"(set_color normal)" is installed, while expecting "(set_color --background green)"$expected"(set_color normal)
        exit 1
    end

# Build and test in one command
build-and-test FISH_VERSION ALPINE_VERSION: (build FISH_VERSION ALPINE_VERSION) (test FISH_VERSION ALPINE_VERSION)