ARG DEBIAN_TAG=13.4

FROM docker.io/library/debian:${DEBIAN_TAG} AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y install \
        git \
        build-essential \
        man \
        man-db \
        shellcheck \
        curl \
        python3 \
        pip \
        pipx \
        pandoc \
        ripgrep \
        fd-find \
        rsync \
        fzf \
        jq \
        bat \
        neovim \
        vim \
        less \
        eza \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd lug
RUN useradd -G lug -m gnuplususer

RUN mkdir /lug && \
    chown root:lug /lug && \
    chmod u=rwx,g=rwxs,o= /lug

COPY --chown=gnuplususer:lug ./Containerfile /lug/Containerfile

USER gnuplususer
WORKDIR /home/gnuplususer

ENTRYPOINT bash
