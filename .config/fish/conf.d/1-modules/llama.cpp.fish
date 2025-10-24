#!/usr/bin/env fish
set LLAMA_CPP_DIRECTORY "/opt/llama.cpp"

if test -d $LLAMA_CPP_DIRECTORY
    fish_add_path "$LLAMA_CPP_DIRECTORY/build/bin"
end
