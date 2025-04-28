#!/usr/bin/env fish
function p_detect
    if begin
        [ -f "package-lock.json" ]
        # or [ -f "yarn.lock" ]
        # or [ -f "pnpm-lock.yaml" ]
        # or [ -f "deno.lock" ]
        or [ -f "bun.lockb" ]; or [ -f "bun.lock" ]
    end
        return 0
    end

    return 127
end

function p_setup
    if [ -f "package-lock.json" ]
        alias p "npm"
        alias pa "npm install"
        alias pad "npm install --save-dev"
        alias pb "npm run build"
        alias pci "npm ci"
        alias pd "npm run dev"
        alias pf "npm run format"
        alias pi "npm install"
        alias pin "npm init"
        alias pl "npm run lint"
        alias prm "npm remove"
        alias pst "npm run start"
        alias px "npx"
    else if [ -f "bun.lockb" ]; or [ -f "bun.lock" ]
        alias p "bun"
        alias pa "bun add"
        alias pad "bun add --dev"
        alias pb "bun run build"
        alias pci "bun install --frozen-lockfile"
        alias pd "bun run dev"
        alias pf "bun run format"
        alias pi "bun install"
        alias pin "bun init"
        alias pl "bun run lint"
        alias prm "bun remove"
        alias pst "bun run start"
        alias px "bunx"
    else
        return 127
    end

    return 0
end

function p_teardown
    functions --erase p pa pad pb pci pd pf pi pin pl prm pst px

    return 0
end
