FROM debian:bookworm-slim AS system
ENV DEBIAN_FRONTEND="noninteractive"
ENV USER="developer"
ENV GROUP="$USER"
ENV HOME="/home/$USER"
USER root

RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "-y", "curl", "sudo", "zsh"]

RUN addgroup $GROUP \
    && useradd -mg $USER -G sudo -s /usr/bin/zsh $USER \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

FROM system AS cargo
USER $USER

RUN curl -fsLS https://sh.rustup.rs | sh -s -- -y \
    && . $HOME/.cargo/env \
    && rustup default stable;
RUN curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash;

ENV PATH="$PATH:$HOME/.cargo/bin"

FROM cargo AS starship
ENV PATH="$PATH:$HOME/.cargo/bin"

COPY --from=cargo --chown=$USER:$GROUP $HOME/.cargo/ $HOME/.cargo/

RUN ["cargo", "binstall", "-y", "starship"]

FROM system AS cleanup
USER root

COPY --from=cargo --chown=$USER:$GROUP $HOME/.rustup/ $HOME/.rustup/
COPY --from=cargo --chown=$USER:$GROUP $HOME/.cargo/ $HOME/.cargo/
COPY --from=starship --chown=$USER:$GROUP $HOME/.cargo/ $HOME/.cargo/

RUN ["apt-get", "clean"]
RUN ["apt-get", "autoremove", "-y"]

FROM cleanup AS final
USER $USER
WORKDIR $HOME
