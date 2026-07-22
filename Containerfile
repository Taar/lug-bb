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

RUN useradd -m gnuplususer

WORKDIR /home/gnuplususer/

USER gnuplususer

RUN mkdir -m u=rwx,g=,o= ./lug

RUN rm .profile
COPY ./bashrc.bash .bashrc
COPY ./bash_aliases.bash .bash_aliases
COPY ./bash_profile.bash .bash_profile

COPY ./Containerfile ./lug/Containerfile
COPY ./LICENSE ./lug/LICENSE
COPY ./scripts ./lug/scripts

RUN mkdir -p -m u=rwx,g=,o= ./.local/bin
RUN ln -s /home/gnuplususer/lug/scripts/utilities/* /home/gnuplususer/.local/bin/ 

ENTRYPOINT bash
