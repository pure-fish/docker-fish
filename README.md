# docker-fish 
[![docker-pull]](https://hub.docker.com/r/purefish/docker-fish) 
[![ci-status]][ci-link]
![docker-size] 
[![sponsors]][sponsor-link]


> Docker images for the [Fish shell][fish] projects to test in control environment

## Usage

By default the image run `fish` shell:

```console
❯ docker run --interactive --tty --rm purefish/docker-fish
```

You can pass commands by quoting them:

```console
❯ docker run --interactive --tty --rm purefish/docker-fish 'fisher list'
jorgebucaran/fisher
jorgebucaran/fishtape
```

### Versions

We provide the following versions of Fish, thanks to Alpine package. Simplify specify the fish version as the tag image:

```console
❯ docker run --interactive --tty --rm purefish/docker-fish:3.5.1
```

| Fish    | Alpine |
| ------- | ------ | 
| `3.0.2` | `3.11` |
| `3.1.2` | `3.13` |
| `3.2.2` | `3.14` |
| `3.3.1` | `3.15` |
| `3.4.1` | `3.16` |
| `3.5.1` | `3.17`, `latest`
| `3.6.0` | `edge` |

## Installed Packages

* [Fisher][fisher] ;
* [Fishtape][fishtape] ;
* Check the [Dockerfile] for the list of additional packages ;

## How to Develop

* See [CONTRIBUTING.md] ;
* See [RELEASE.md].

## Thanks

* @andreiborisov who work on the first version of [docker-fish](https://github.com/andreiborisov/docker-fish).
* @PureTryOut who maintain the alpine packages.

## License

[MIT](LICENSE)

[fish]: https://fishshell.com
[fisher]: https://github.com/jorgebucaran/fisher
[fishtape]: https://github.com/jorgebucaran/fishtape
[Dockerfile]: ./Dockerfile
[CONTRIBUTING.md]: ./CONTRIBUTING.md
[RELEASE.md]: ./RELEASE.md

[docker-pull]: https://img.shields.io/docker/pulls/purefish/docker-fish.svg?style=flat-square&logo=docker&label=pulls&color=2396ed
[docker-size]: https://img.shields.io/docker/image-size/purefish/docker-fish?label=size&style=flat-square "Docker Image Size (latest by date)"
[ci-link]: <https://github.com/pure-fish/pure/actions> "Github CI"
[ci-status]: https://img.shields.io/github/actions/workflow/status/pure-fish/docker-fish/.github/workflows/build-images.yml?style=flat-square
[sponsors]: https://img.shields.io/github/sponsors/edouard-lopez?label=💰&style=flat-square "GitHub Sponsors"
[sponsor-link]: https://github.com/sponsors/edouard-lopez/ "Become a sponsor"