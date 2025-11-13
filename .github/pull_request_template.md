# Add support for Fish 9.9.9

1. Edit `.github/workflows/build-images.yml` to add a new version of Fish.

    ```yaml
    { fish: 9.9.9, alpine: "edge", source: true },
    ```

1. Edit `README.md` to add the new version to the table.

    ```markdown
    | `9.9.9` | [`edge`](https://pkgs.alpinelinux.org/packages?name=fish&arch=x86_64&branch=edge), `latest`
    | source  |
    ```

1. Commit using the [conventional commit][cc]  `feat: add fish 9.9.9` (or similar).

[cc]: https://www.conventionalcommits.org/
