#!/usr/bin/env fish
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

if command -q starship &> /dev/null; and not pidof "code" 1> /dev/null
    function starship_transient_prompt_func
        starship module character
    end

    function starship_transient_rprompt_func
        starship module time
    end

    starship init fish | source
    enable_transience
else
    function fish_prompt
        echo (set_color cyan)(string replace --max-matches 1 "$HOME" "~" "$PWD")
        echo (set_color magenta)"> "(set_color normal)
    end
end

return 0
