{pkgs, ...}: {
    home.packages = with pkgs; [
        dracula-icon-theme
        dracula-theme
    ];

    programs.plasma = {
        enable = true;
        fonts = let
            noto-sans = {
                family = "Noto Sans";
                pointSize = 10;
            };
        in {
            fixedWidth = {
                family = "FantasqueSansM Nerd Font";
                pointSize = 12;
            };
            # For completion's sake
            general = noto-sans;
            menu = noto-sans;
            small = noto-sans;
            toolbar = noto-sans;
            windowTitle = noto-sans;
        };
        immutableByDefault = true;
        kwin = {
            effects = {
                desktopSwitching.animation = "slide";
                dimInactive.enable = true;
                minimization.animation = "magiclamp";
                windowOpenClose.animation = "glide";
                wobblyWindows.enable = true;
            };
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
            tiling.padding = 32;
        };
        overrideConfig = true;
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
                    {
                        pager.general = {
                            displayedText = "desktopNumber";
                            showWindowOutlines = false;
                        };
                    }
                    {
                        iconTasks = {
                            launchers = [];
                        };
                    }

                    "org.kde.plasma.marginsseparator"

                    {
                        systemTray.items = {
                            hidden = [
                                "org.kde.plasma.mostrecentdrives"
                            ];
                            shown = [
                                "org.kde.plasma.clipboard"
                                "org.kde.plasma.volume"
                                "org.kde.plasma.battery"
                                "org.kde.networkmanagement"
                            ];
                        };
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
        powerdevil.AC = {
            powerProfile = "performance";

            autoSuspend.action = "nothing";
            dimDisplay.enable = false;
            turnOffDisplay.idleTimeout = null;
        };
        window-rules = [
            {
                description = "Remove window decorations";
                match = {
                    window-class = {
                        type = "regex";
                        value = ".+";
                    };
                    window-types = ["normal"];
                };

                apply.noborder = {
                    apply = "force";
                    value = true;
                };
            }
        ];
        workspace = {
            clickItemTo = "open";
            colorScheme = "DraculaPurple";
            iconTheme = "Dracula";
            lookAndFeel = "Dracula";
            theme = "Dracula-Solid";
            wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Milky Way/contents/images/1080x1920.png";
        };

        configFile.kwinrc.Desktops.Number = {
            immutable = true;
            value = 4;
        };
        hotkeys.commands = {
            "launch-terminal" = {
                command = "${pkgs.alacritty}/bin/alacritty";
                key = "Ctrl+Alt+T";
                name = "Launch terminal";
            };
            "launch-browser" = {
                command = "${pkgs.firefox}/bin/firefox";
                key = "Ctrl+Alt+B";
                name = "Launch web browser";
            };
        };
        input.keyboard = {
            repeatDelay = 150;
            repeatRate = 30;
        };
        kscreenlocker.timeout = 0;
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
        startup.startupScript."alacritty" = {
            runAlways = true;
            text = "${pkgs.alacritty}/bin/alacritty";
        };
    };
}
