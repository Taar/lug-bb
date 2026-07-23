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
        locales \
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

RUN sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
RUN locale-gen
RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

USER gnuplususer

RUN mkdir -m u=rwx,g=,o= ./lug

RUN rm .profile
COPY --chown=gnuplususer:gnuplususer ./bashrc.bash .bashrc
COPY --chown=gnuplususer:gnuplususer ./bash_aliases.bash .bash_aliases

COPY --chown=gnuplususer:gnuplususer ./scripts ./lug/scripts

RUN mkdir -p -m u=rwx,g=,o= ./.local/bin
RUN ln -s /home/gnuplususer/lug/scripts/utilities/* /home/gnuplususer/.local/bin/ 

COPY --chown=gnuplususer:gnuplususer ./LICENSE ./lug/LICENSE
COPY --chown=gnuplususer:gnuplususer ./Containerfile ./lug/Containerfile

ENTRYPOINT bash
