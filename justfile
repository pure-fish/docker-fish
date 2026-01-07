set shell := ["fish", "-c"]

CONTAINER_USER := "nemo"

# Internal build recipe (prefixed with _ to indicate private)
build FISH_VERSION ALPINE_VERSION BUILD_USING_BINARY="false" verbose="false":
    @printf "Building Fish {{ FISH_VERSION }} from {{ if BUILD_USING_BINARY == "true" { "source" } else { "package" } }}\n"
    @printf "verbosity: %s\n\n  " {{ verbose }}
    docker buildx build \
        {{ if verbose == "verbose" {""} else { "--quiet" } }} \
        --build-context alpine=docker-image://alpine:{{ ALPINE_VERSION }} \
        --build-arg FISH_VERSION={{ FISH_VERSION }} \
        --build-arg BUILD_USING_BINARY={{ BUILD_USING_BINARY }} \
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

# Print Fish version
print-fish-version:
    #!/usr/bin/env fish
    printf "\nUsing \e[38;5;27mFish %s\e[m\n\n" (fish --version | awk '{print $NF}')

# Add nemo user to the system
add-nemo-user:
    #!/usr/bin/env fish
    addgroup \
        --gid 1000 \
        {{ CONTAINER_USER }}
    adduser \
        --shell /usr/bin/fish \
        --ingroup {{ CONTAINER_USER }} \
        --disabled-password \
        --uid 1000 \
        {{ CONTAINER_USER }} {{ CONTAINER_USER }}

# Move justfile to container user home
move-to-container-user-home:
    #!/usr/bin/env fish
    mv justfile /home/{{ CONTAINER_USER }}/ \
    && chown {{ CONTAINER_USER }}:{{ CONTAINER_USER }} /home/{{ CONTAINER_USER }}/justfile \
    && printf "✅ justfile moved\n"

# Install Fisher package manager
install-fisher:
    #!/usr/bin/env fish
    curl -sL git.io/fisher \
    | source \
    && fisher install jorgebucaran/fisher \
    && printf "\nUsing \e[38;5;27mFisher %s\e[m\n\n" (fisher --version | awk '{print $NF}')

# Install Fishtape testing framework
install-fishtape:
    #!/usr/bin/env fish
    fisher install jorgebucaran/fishtape \
    && printf "\nUsing \e[38;5;27mFishtape %s\e[m\n\n" (fishtape --version | awk '{print $NF}')

tag-version FISH_VERSION ALPINE_VERSION COMMIT_HASH="HEAD":
    #!/usr/bin/env fish
    echo "{{ FISH_VERSION }} {{ ALPINE_VERSION }}"
    if test -z "{{ FISH_VERSION }}" -o -z "{{ ALPINE_VERSION }}"
        printf "❌ FISH_VERSION and ALPINE_VERSION must be set\n"
        exit 1
    else
        git tag "fish-{{ FISH_VERSION }}.alpine-{{ ALPINE_VERSION }}" --message "" {{COMMIT_HASH}};
        and begin
            printf "✅ Tagged fish-{{ FISH_VERSION }}.alpine-{{ ALPINE_VERSION }}\n"
            git push --tags
        end
    end