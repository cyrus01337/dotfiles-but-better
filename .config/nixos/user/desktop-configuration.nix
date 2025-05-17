{pkgs, ...}: {
    programs.plasma = {
        enable = true;
        immutableByDefault = true;
        kwin = {
            virtualDesktops = {
                names = [
                    "Main"
                    "Development"
                    "Music"
                    "Extra"
                ];
                number = 4;
            };

            scripts.polonium = {
                enable = true;
                settings = {
                    borderVisibility = "borderAll";
                    layout = {
                        engine = "half";
                        insertionPoint = "activeWindow";
                    };
                };
            };
            tiling.padding = 8;
        };
        kscreenlocker = {
            timeout = 0;
        };
        panels = [
            {
                hiding = "autohide";
                location = "bottom";
                widgets = [
                    {
                        kickoff = {
                            icon = "nix-snowflake-black";
                            sortAlphabetically = true;
                        };
                    }

                    "org.kde.plasma.pager"
                    "org.kde.plasma.icontasks"
                    "org.kde.plasma.marginsseparator"

                    {
                        systemTray.items.shown = [
                            "org.kde.plasma.clipboard"
                            "org.kde.plasma.volume"
                            "org.kde.plasma.battery"
                            "org.kde.networkmanagement"
                        ];
                    }

                    {
                        digitalClock = {
                            calendar.firstDayOfWeek = "sunday";
                            time.format = "12h";
                        };
                    }
                ];
            }
        ];
        window-rules = [
            {
                apply = {
                    maximizehoriz = true;
                    maximizevert = true;
                    noborder = {
                        apply = "force";
                        value = true;
                    };
                };
                description = "Remove window decorations";
                match = {
                    window-class = {
                        type = "regex";
                        value = ".+";
                    };
                    window-types = ["normal"];
                };
            }
        ];
        workspace = {
            clickItemTo = "open";
            lookAndFeel = "org.kde.breezedark.desktop";
            theme = "breeze-dark";
        };

        configFile.kwinrc.Desktops.Number = {
            immutable = true;
            value = 4;
        };
        hotkeys.commands = {
            "launch-terminal" = {
                command = "alacritty";
                key = "Ctrl+Alt+T";
                name = "Launch terminal";
            };
            "launch-browser" = {
                command = "firefox";
                key = "Ctrl+Alt+B";
                name = "Launch web browser";
            };
        };
        input.keyboard = {
            repeatDelay = 150;
            repeatRate = 30;
        };
        shortcuts.kwin = let
            NO_HOTKEY = "";
        in {
            "Toggle Tiles Editor" = NO_HOTKEY;
            "Switch Power Profile" = NO_HOTKEY;

            "Minimise Window" = "Meta+M";
            "Close Window" = "Meta+Q";

            "Switch to Desktop 1" = "Meta+1";
            "Switch to Desktop 2" = "Meta+2";
            "Switch to Desktop 3" = "Meta+3";
            "Switch to Desktop 4" = "Meta+4";

            "Window to Desktop 1" = "Meta+!";
            "Window to Desktop 2" = "Meta+\"";
            "Window to Desktop 3" = "Meta+£";
            "Window to Desktop 4" = "Meta+$";

            "Polonium: Focus Above" = "Meta+Up";
            "Polonium: Focus Below" = "Meta+Down";
            "Polonium: Focus Left" = "Meta+Left";
            "Polonium: Focus Right" = "Meta+Right";
            "Polonium: Insert Above" = "Shift+Meta+Up";
            "Polonium: Insert Below" = "Shift+Meta+Down";
            "Polonium: Insert Left" = "Shift+Meta+Left";
            "Polonium: Insert Right" = "Shift+Meta+Right";
            "Polonium: Use Monocle Engine" = "Meta+F";
            "Polonium: Cycle Engine" = "Meta+S";
        };
    };
}
