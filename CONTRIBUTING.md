# Contributing Guide

Alpine images already [provide a `fish` package][alpine-fish] from their repository so we leverage that.

## Requirement

* [just] (a modern `make`-like system).

## Build supported versions

We provide aliases for already supported version:

```console
❯ just build-<TAB>
build-3-0-2  build-3-1-2  build-3-2-2  build-3-3-1  build-3-4-1  build-3-5-1
```

## Test version

Check provide version match `fish --version` output:

    just test 3.5.1


## Add a new `Alpine`/`Fish`

When a **new Fish version is available through alpine**, you can use the `build` recipe create a new image:

```console
❯ just build "edge" "3.5.1-r2"
```

The `build` recipe takes 3 arguments:

| Argument         | Description                | Need                   |
| ---------------- | -------------------------- | ---------------------- |
| `ALPINE_VERSION` | to use as base image       | **required**           |
| `FISH_VERSION`   | to tag the resulting image | _optional_<sup>†</sup> |
| `verbose`        | debug level                | _optional_             |

<sup>†</sup> Required in the CI build process.

## Build Unsupported versions

This is **not yet supported**, but we are open for PR! :heart:

### Proposal

:bulb: An idea would be to add a hook in the [Dockerfile]. e.g.:

```Dockerfile
ARG FISH_GIT_SHA=""
…
RUN [ -n "${FISH_GIT_SHA}" ] && make install-fish-from-source ${FISH_GIT_SHA}
```

And

```make
install-fish-from-source:
    git clone --depth 1 <fish-repo-url>@${FISH_FROM_SOURCE_GIT_SHA}
    <build steps>
```

## Release

See [RELEASE.md].

[just]: https://github.com/casey/just
[alpine-fish]: https://pkgs.alpinelinux.org/packages?name=fish&repo=&arch=
[Dockerfile]: ./Dockerfile
[RELEASE.md]: ./RELEASE.md