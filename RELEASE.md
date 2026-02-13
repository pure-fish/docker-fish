# Release Process

Build and publish are done by the CI, see our [workflow].

We have a map of `Alpine` version and the expected `Fish` version.

## Latest

Is build automatically by Docker Hub automated build feature by using the Dockerfile from the `main` branch. It means `latest` tag corresponds to the `alpine:latest`, i.e latest stable version.

## Adding New Versions

To add a new Fish version, use the `just` recipe:
```bash
just tag-version FISH_VERSION=X.Y.Z ALPINE_VERSION=alpine-version
```

## Build Optimization

The CI workflow automatically skips building images that already exist on Docker Hub. To force a rebuild of all images, manually trigger the workflow with the "Force rebuild all images" option enabled.

[workflow]: .github/workflows/build-images.yml
