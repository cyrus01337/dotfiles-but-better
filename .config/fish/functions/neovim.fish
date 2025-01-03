#!/usr/bin/env fish
if command -q nvim
    function n --wraps nvim
        set target $argv[1]
        set previous_directory $PWD

        if not [ $target ]
            cd $HOME/.config/nvim
            nvim .
        else
            if test -d $target
                cd $target
                nvim .
            else
                set directory (dirname $target)
                set filename (basename $target)

                cd $directory
                nvim $filename
            end
        end

        cd $previous_directory
    end
else if command -q docker
    function n --wraps "zsh"
        set target $argv[1]
        set default_flags -it --rm
        set default_volumes -v $HOME/.gitconfig:/home/developer/.gitconfig -v $HOME/.git-credentials:/home/developer/.git-credentials -v neovim-data:/home/developer/.local/share/nvim
        set arguments $argv[2..]

        if not [ $target ]
            docker run $default_flags --name neovim-configuration $default_volumes -v $HOME/.config/nvim:/workspace cyrus01337/neovim-devcontainer:latest -c "nvim . $arguments"

            return 0
        end

        set absolute_path_to_target (realpath $target)
        set filename (basename $absolute_path_to_target)
        set default_flags $default_flags --name $filename

        if [ -d $target ]
            docker run $default_flags $default_volumes -v $absolute_path_to_target:/workspace cyrus01337/neovim-devcontainer:latest $arguments
        else
            docker run $default_flags $default_volumes -v $absolute_path_to_target:/workspace/$filename cyrus01337/neovim-devcontainer:latest -c "nvim $filename" $arguments
        end
    end
end
