{
    services = {
        pipewire = {
            enable = true;

            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        pulseaudio.enable = false;
    };

    security.rtkit.enable = true;
}
