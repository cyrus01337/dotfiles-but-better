FROM cyrus01337/shell-devcontainer AS system
ENV DEBIAN_FRONTEND="noninteractive"
ENV USER="developer"
ENV GROUP="$USER"
ENV HOME="/home/$USER"
USER root
WORKDIR /workspace

RUN ["apt-get", "install", "-y", "black", "fd-find", "gcc", "git", "isort", "lua5.1", "luarocks", "make", "python3.11-venv", "python3-pip", "ripgrep", "unzip"]
RUN ["apt-get", "install", "-y", "iproute2"]

RUN ["update-alternatives", "--install", "/usr/bin/python", "python", "/usr/bin/python3", "20"]
RUN addgroup docker \
    && usermod -aG docker $USER;

FROM system AS dive
USER root

COPY ./install-dive.sh .

RUN ["./install-dive.sh"]
RUN ["rm", "./install-dive.sh"]

FROM system AS github-cli
USER root

COPY ./install-github-cli.sh .

RUN ["./install-github-cli.sh"]
RUN ["rm", "./install-github-cli.sh"]

FROM system AS go
USER $USER
WORKDIR /go

RUN curl -fsLS https://go.dev/dl/go1.23.1.linux-amd64.tar.gz -o go.tar.gz \
    && tar xfz go.tar.gz \
    && rm go.tar.gz

FROM system AS node
USER $USER

RUN curl -fsLS https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir "$HOME/.local/share/fnm";

ENV PATH="$HOME/.local/share/fnm:$PATH"

RUN eval "$(fnm env --shell bash)" \
    && fnm install 22 \
    && fnm use 22 \
    && npm install -g npm prettier;

FROM system AS python
USER $USER

RUN python -m pip install -U pip;

FROM system AS stylua
USER root
WORKDIR /usr/bin

RUN curl -fsLS https://github.com/JohnnyMorganz/StyLua/releases/download/v0.20.0/stylua-linux-x86_64.zip -o stylua.zip \
    && unzip stylua.zip \
    && rm stylua.zip;

FROM system AS neovim
USER root
WORKDIR /neovim

RUN curl -fsLS https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz -o neovim.zip \
    && tar xfz neovim.zip --strip-components=1 \
    && rm neovim.zip;

FROM system AS cleanup
USER root

COPY --from=go /go/ /usr/local/
COPY --from=node --chown=$USER:$GROUP $HOME/.local/share/fnm/ $HOME/.local/share/fnm/
COPY --from=stylua /usr/bin/stylua /usr/bin/stylua
COPY --from=neovim /neovim/ /usr/

RUN ["apt-get", "clean"]
RUN ["apt-get", "autoremove", "-y"]

FROM cleanup AS final
USER $USER
