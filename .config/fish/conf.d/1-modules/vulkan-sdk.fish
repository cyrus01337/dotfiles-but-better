#!/usr/bin/env fish
set --export VULKAN_SDK "/opt/vulkan/1.4.328.1/x86_64"

if test -d $VULKAN_SDK
    fish_add_path --prepend "$VULKAN_SDK/bin"

    if test "$LD_LIBRARY_PATH" = ""
        set --export LD_LIBRARY_PATH "$VULKAN_SDK/lib"
    else
        set --prepend --export LD_LIBRARY_PATH "$VULKAN_SDK/lib"
    end

    if test "$PKG_CONFIG_PATH" = ""
        set --export PKG_CONFIG_PATH "$VULKAN_SDK/share/pkgconfig:$VULKAN_SDK/lib/pkgconfig"
    else
        set --prepend --export PKG_CONFIG_PATH "$VULKAN_SDK/share/pkgconfig:$VULKAN_SDK/lib/pkgconfig"
    end
end
