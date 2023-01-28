# Release Process

Build and publish are done by the CI, see our [workflow].

We have a map of `Alpine` version and the expected `Fish` version.

## Latest

Is build automatically by Docker Hub automated build feature by using the Dockerfile from the `main` branch. It means `latest` tag corresponds to the `alpine:latest`, i.e latest stable version.

[workflow]: .github/workflows/build-images.yml
