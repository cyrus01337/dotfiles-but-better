FROM debian:bookworm AS system
USER root
ENV USER="neovim"
ENV GROUP="$USER"
ENV HOME="/home/$USER"
ENV DEBIAN_FRONTEND="noninteractive"
WORKDIR /workspace

RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "-y", "ripgrep", "sudo", "unzip", "zsh"]

FROM system AS user
USER root

RUN addgroup $GROUP \
    && useradd -mg $GROUP -G sudo -s /usr/bin/zsh $USER \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers;

FROM user AS cargo
USER $USER

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && . $HOME/.cargo/env \
    && rustup default stable;

FROM user AS stylua
USER root
WORKDIR /usr/bin

RUN curl -L https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip -o stylua.zip \
    && unzip stylua.zip;

# TODO: See if you can steal the Neovim executable from an existing Neovim image
# running Debian Bookworm to improve performance by avoiding archive extraction
FROM user AS neovim
USER root
WORKDIR /neovim

RUN curl -L https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz -o neovim.zip \
    && tar -xzf neovim.zip --strip-components=1 \
    && rm neovim.zip;

FROM user AS final
USER root

COPY --from=cargo $HOME/.cargo/ $HOME/.cargo/
COPY --from=stylua /usr/bin/stylua /usr/bin/stylua
COPY --from=neovim /neovim/ /usr/

RUN ["apt-get", "clean"]
RUN ["apt-get", "autoremove", "-y"]
