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
        abbr p "npm"
        abbr pa "npm install"
        abbr pad "npm install --save-dev"
        abbr pb "npm run build"
        abbr pci "npm ci"
        abbr pd "npm run dev"
        abbr pf "npm run format"
        abbr pini "npm init"
        abbr pins "npm install"
        abbr pl "npm run lint"
        abbr prm "npm remove"
        abbr prt "npm run test"
        abbr pst "npm run start"
        abbr pt "npm run test"
        abbr pup "npm update"
        abbr px "npx"
    else if test -f "bun.lockb"; or test -f "bun.lock"
        abbr p "bun"
        abbr pa "bun add"
        abbr pad "bun add --dev"
        abbr pb "bun run build"
        abbr pci "bun install --frozen-lockfile"
        abbr pd "bun run dev"
        abbr pf "bun run format"
        abbr pini "bun init"
        abbr pins "bun install"
        abbr pl "bun run lint"
        abbr prm "bun remove"
        abbr prt "bun run test"
        abbr pst "bun run start"
        abbr pt "bun test"
        abbr pup "bun update"
        abbr px "bunx"
    else
        return 127
    end

    return 0
end

function p_teardown
    abbr --erase p pa pad pb pci pd pf pini pins pl prm prt pst pt px

    return 0
end
