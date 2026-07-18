# Hackforge LUG - Bash Basics

This is part of a workshop that was hosted at [Hackforge](https://hackf.org) as part of the Linux User Group.

> [!IMPORTANT]
> Don't use this container in production environments. It should only be used for educational purposes.

```bash
podman run -it --rm ghcr.io/taar/lug-bb
```

## Build Container

```bash
podman build . -t lug-bb:latest
```

## Run the Container

```bash
# if built locally
podman run -it --rm lug-bb
```
