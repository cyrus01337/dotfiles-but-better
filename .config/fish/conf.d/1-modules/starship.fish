#!/usr/bin/env fish
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

if command -q starship; and not pidof "code" 1> /dev/null
    function starship_transient_prompt_func
        starship module character
    end

    function starship_transient_rprompt_func
        starship module time
    end

    starship init fish | source
    enable_transience
end

return 0
