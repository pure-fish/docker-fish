# Contributing Guide

This project supports building Fish Docker images in two ways:

1. **Package installation**: Using pre-built Fish packages from Alpine repositories (faster)
2. **Binary installation**: Installing prebuilt Fish binaries from GitHub releases (supports any released version)

## Requirements

* [just] (a modern `make`-like system)
* Docker with `buildx` support

## Building Fish Versions

The `build` recipe takes the following arguments:

| Argument           | Description                    | Default   | Notes                        |
| ------------------ | ------------------------------ | --------- | ---------------------------- |
| `FISH_VERSION`     | Fish version to build          | required  | e.g., "4.0.2", "4.1.1"      |
| `ALPINE_VERSION`   | Alpine base image version      | required  | e.g., "3.22", "edge"        |
| `BUILD_USING_BINARY`| Build method                   | "false"   | "true" for binary installation      |
| `verbose`          | Build output verbosity         | "false"   | "verbose" for detailed logs  |

### Build from Alpine Package (Recommended)

For Fish versions available in Alpine repositories:

```fish
# Build Fish 4.0.2 from Alpine 3.22 package
just build 4.0.2 3.22

# Build from binary with verbose output
just build 4.0.2 3.22 false verbose
```

### Build from Binary

For newer Fish versions not yet available in Alpine packages:

```fish
# Build Fish 4.2.1 from prebuilt binary
just build 4.2.1 edge true

# Build with verbose output  
just build 4.2.1 edge true verbose
```

## Testing Versions

Verify that the built image contains the expected Fish version:

```fish
# Test Fish 4.0.2 built on Alpine 3.22
just test 4.0.2 3.22
```

The test command will:

* Show expected vs actual Fish versions with color coding
* Display ✓ VERSION MATCH for successful matches  
* Display ✗ VERSION MISMATCH for failures
* Handle missing Docker images gracefully

## Adding New Fish Versions

### For Versions Available in Alpine

When Alpine releases a new Fish package, add it to the GitHub Actions matrix in `.github/workflows/build-images.yml`:

```yaml
{ fish: 4.0.7, alpine: "edge" }
```

### For Versions Not Yet in Alpine

For newer Fish versions, use binary builds in the matrix:

```yaml
{ fish: 4.2.0, alpine: "edge", binary: true }
```

The build system will automatically:

* Download the binary archive from GitHub releases
* Compile Fish with all required dependencies (including Rust for newer versions)
* Create a Docker image with the specified Fish version

### Manual Local Builds

You can also build any Fish version locally:

```fish
# Build latest Fish from prebuilt binary
just build 4.2.1 edge true

# Build specific older version from package
just build 3.7.1 3.21 false
```

## Technical Details

### Build Methods

The Dockerfile supports two installation methods controlled by the `BUILD_USING_BINARY` argument:

* **Package method** (`BUILD_USING_BINARY=false`): Fast builds using Alpine's pre-built Fish packages
* **Binary method** (`BUILD_USING_BINARY=true`): Installs prebuilt Fish binaries from GitHub releases

### Multi-stage Build

The build process uses Docker multi-stage builds:

1. **Build stage**: Downloads and extracts prebuilt Fish binaries from GitHub releases (when needed)
2. **Final stage**: Creates minimal runtime image with Fish installed

### Binary Build Dependencies

When building from prebuilt binaries, the build stage temporarily installs:

* curl - for downloading the binary archive
* tar and xz - for extracting the compressed archive

These build dependencies are removed after extraction to keep the final image size minimal.

## Release

See [RELEASE.md].

[just]: https://github.com/casey/just
[RELEASE.md]: ./RELEASE.md
