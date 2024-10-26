#!/usr/bin/env fish
set P_PACKAGE_MANAGER ""
set PX_COMMAND ""

function detect_javascript
    if [ -f "package-lock.json" ]
        set P_PACKAGE_MANAGER "npm"
        set PX_COMMAND "npx"
    else if [ -f "yarn.lock" ]
        set P_PACKAGE_MANAGER "yarn"
        set PX_COMMAND "yarn dlx"
    else if [ -f "pnpm-lock.yaml" ]
        set P_PACKAGE_MANAGER "pnpm"
        set PX_COMMAND "pnpx"
    else if [ -f "deno.lock" ]
        set P_PACKAGE_MANAGER "deno"
        set PX_COMMAND "deno run"
    else if [ -f "bun.lockb" ]
        set P_PACKAGE_MANAGER "bun"
        set PX_COMMAND "bunx"
    end

    if [ $P_PACKAGE_MANAGER != "" ]; and [ $PX_COMMAND != "" ]
        echo $P_PACKAGE_MANAGER
        echo $PX_COMMAND

        return 0
    end

    return 127
end
