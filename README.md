# docker-fish [![Docker pulls](https://img.shields.io/docker/pulls/andreiborisov/fish.svg?logo=docker&label=pulls&color=2396ed)](https://hub.docker.com/r/andreiborisov/fish)

> Dockerfiles for the [fish shell](https://fishshell.com)

## Thanks

* This fork aim to be a reboot but with ideas from @andreiborisov's [docker-fish](https://github.com/andreiborisov/docker-fish)

## Usage

Default command is `fish` shell:

```console
docker run -it --rm pure-fish/docker-fish:latest
```

Passing options to `fish`:

```console
$ docker run -it --rm pure-fish/docker-fish:latest --version
fish, version 3.0.2
```

Running command in `fish`:

```console
$ docker run -it --rm andreiborisov/fish:3 fisher list
jorgebucaran/fisher
jorgebucaran/fishtape
```

## How to dev

**requirement:** [just][just].

```console
❯ just FISH_VERSION=3.0 build  
```

## Installed Packages

* [Fisher](https://github.com/jorgebucaran/fisher)
* [Fishtape](https://github.com/jorgebucaran/fishtape)

## License

[MIT](LICENSE)

[just]: https://github.com/casey/just
