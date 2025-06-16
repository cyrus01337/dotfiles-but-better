#!/usr/bin/env fish
function p_detect
    if begin
        test -f "package-lock.json"
        # or test -f "yarn.lock"
        # or test -f "pnpm-lock.yaml"
        # or test -f "deno.lock"
        or test -f "bun.lockb" ; or test -f "bun.lock"
    end
        return 0
    end

    return 127
end

function p_setup
    if test -f "package-lock.json"
        alias p "npm"
        alias pa "npm install"
        alias pad "npm install --save-dev"
        alias pb "npm run build"
        alias pci "npm ci"
        alias pd "npm run dev"
        alias pf "npm run format"
        alias pini "npm init"
        alias pins "npm install"
        alias pl "npm run lint"
        alias prm "npm remove"
        alias pst "npm run start"
        alias px "npx"
    else if test -f "bun.lockb"; or test -f "bun.lock"
        alias p "bun"
        alias pa "bun add"
        alias pad "bun add --dev"
        alias pb "bun run build"
        alias pci "bun install --frozen-lockfile"
        alias pd "bun run dev"
        alias pf "bun run format"
        alias pini "bun init"
        alias pins "bun install"
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
    functions --erase p pa pad pb pci pd pf pini pins pl prm pst px

    return 0
end
