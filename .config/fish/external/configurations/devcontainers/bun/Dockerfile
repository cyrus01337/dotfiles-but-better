FROM cyrus01337/neovim-devcontainer AS system
ENV DEBIAN_FRONTEND="noninteractive"
ENV USER="developer"
ENV HOME="/home/$USER"
USER root
WORKDIR /workspace

RUN ["apt-get", "update"]
RUN ["apt-get", "dist-upgrade", "-y"]
RUN ["apt-get", "install", "-y", "jq"]

FROM system AS bun
USER $USER
ENV BUN_INSTALL="$HOME/.bun"

RUN curl -fsSL https://bun.sh/install | bash;

FROM bun AS cleanup
USER root

RUN ["apt-get", "clean"]
RUN ["apt-get", "autoremove", "-y"]

FROM cleanup AS final
USER $USER
