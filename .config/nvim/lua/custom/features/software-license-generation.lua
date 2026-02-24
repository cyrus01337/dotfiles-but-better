local mode = require("custom.lib.mode")

return {
    "chip/telescope-software-licenses.nvim",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local telescope = require("telescope")

        telescope.load_extension("software_licenses")
        vim.keymap.set(mode.NORMAL, "<leader>gl", "<CMD>Telescope software_licenses find<CR>")
    end,
}
