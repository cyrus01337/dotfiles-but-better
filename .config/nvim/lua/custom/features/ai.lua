return {
    {
        "codota/tabnine-nvim",
        dependencies = {
            "tzachar/cmp-tabnine",
        },
        build = "./dl_binaries.sh",
        config = function()
            local tabnine = require("tabnine")

            tabnine.setup({
                accept_keymap = "<Tab>",
                debounce_ms = 800,
                disable_auto_comment = true,
                dismiss_keymap = "<C-]>",
                exclude_filetypes = { "TelescopePrompt", "NvimTree", "Oil" },
                ignore_certificate_errors = false,
                log_file_path = nil,
                suggestion_color = { gui = "#808080", cterm = 244 },
            })
        end,
    },
}
