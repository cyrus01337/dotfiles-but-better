{
    lib,
    pkgs,
    ...
}: let
    inherit lib;

    shared = import ./../../shared.nix;
in {
    home.packages = [pkgs.tmux];
    programs.tmux = {
        aggressiveResize = true;
        baseIndex = 1;
        disableConfirmationPrompt = true;
        enable = true;
        escapeTime = 0;
        extraConfig = builtins.readFile (shared.dotfiles-xdg + "/tmux/tmux.conf");
        focusEvents = true;
        historyLimit = 100000;
        mouse = true;
        newSession = true;
        plugins = with pkgs.tmuxPlugins; [
            vim-tmux-navigator

            {
                extraConfig = ''
                    set -g @dracula-plugins false
                    set -g @dracula-show-left-icon session
                '';
                plugin = dracula;
            }
        ];
        prefix = "C-Space";
        terminal = "tmux-256color";
    };
}
