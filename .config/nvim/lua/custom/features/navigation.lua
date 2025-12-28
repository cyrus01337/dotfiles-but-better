local os = require("os")

local home_directory = os.getenv("XDG_CONFIG_HOME")
local NEOVIM_CONFIGURATION_DIRECTORY = home_directory and (home_directory .. "/nvim") or vim.fn.expand("~/.config/nvim")

---@param name "shell" | "web-development"
---
---@return string
local function get_nonglobal_rgignore_filepath(name)
    return NEOVIM_CONFIGURATION_DIRECTORY .. "/ripgrep/" .. name .. ".rgignore"
end

return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateUp",
            "TmuxNavigateDown",
            "TmuxNavigateLeft",
            "TmuxNavigateRight",
        },
        keys = {
            { "<leader><Up>", "<CMD>TmuxNavigateUp<CR>" },
            { "<leader><Down>", "<CMD>TmuxNavigateDown<CR>" },
            { "<leader><Left>", "<CMD>TmuxNavigateLeft<CR>" },
            { "<leader><Right>", "<CMD>TmuxNavigateRight<CR>" },
        },
        config = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>ff", "<CMD>Telescope find_files<CR>" },
            { "<leader>fg", "<CMD>Telescope live_grep<CR>" },
            { "<leader>fb", "<CMD>Telescope buffers<CR>" },
            { "<leader>fh", "<CMD>Telescope help_tags<CR>" },
            { "<leader>fs", "<CMD>Telescope treesitter<CR>" },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local configuration = require("telescope.config")
            local TSLayout = require("telescope.pickers.layout")
            local Layout = require("nui.layout")
            local Popup = require("nui.popup")

            local vimgrep_arguments = { unpack(configuration.values.vimgrep_arguments) }
            local extra_arguments = { "--hidden", "--glob", "!**/.git/*" }

            local function make_popup(options)
                local popup = Popup(options)

                function popup.border:change_title(title)
                    popup.border.set_text(popup.border, "top", title)
                end

                return TSLayout.Window(popup)
            end

            for _, argument in ipairs(extra_arguments) do
                table.insert(vimgrep_arguments, argument)
            end

            telescope.setup({
                defaults = {
                    create_layout = function(picker)
                        local border = {
                            results = {
                                top_left = "┌",
                                top = "─",
                                top_right = "┬",
                                right = "│",
                                bottom_right = "",
                                bottom = "",
                                bottom_left = "",
                                left = "│",
                            },
                            results_patch = {
                                minimal = {
                                    top_left = "┌",
                                    top_right = "┐",
                                },
                                horizontal = {
                                    top_left = "┌",
                                    top_right = "┬",
                                },
                                vertical = {
                                    top_left = "├",
                                    top_right = "┤",
                                },
                            },
                            prompt = {
                                top_left = "├",
                                top = "─",
                                top_right = "┤",
                                right = "│",
                                bottom_right = "┘",
                                bottom = "─",
                                bottom_left = "└",
                                left = "│",
                            },
                            prompt_patch = {
                                minimal = {
                                    bottom_right = "┘",
                                },
                                horizontal = {
                                    bottom_right = "┴",
                                },
                                vertical = {
                                    bottom_right = "┘",
                                },
                            },
                            preview = {
                                top_left = "┌",
                                top = "─",
                                top_right = "┐",
                                right = "│",
                                bottom_right = "┘",
                                bottom = "─",
                                bottom_left = "└",
                                left = "│",
                            },
                            preview_patch = {
                                minimal = {},
                                horizontal = {
                                    bottom = "─",
                                    bottom_left = "",
                                    bottom_right = "┘",
                                    left = "",
                                    top_left = "",
                                },
                                vertical = {
                                    bottom = "",
                                    bottom_left = "",
                                    bottom_right = "",
                                    left = "│",
                                    top_left = "┌",
                                },
                            },
                        }

                        local results = make_popup({
                            focusable = false,
                            border = {
                                style = border.results,
                                text = {
                                    top = picker.results_title,
                                    top_align = "center",
                                },
                            },
                            win_options = {
                                winhighlight = "Normal:Normal",
                            },
                        })

                        local prompt = make_popup({
                            enter = true,
                            border = {
                                style = border.prompt,
                                text = {
                                    top = picker.prompt_title,
                                    top_align = "center",
                                },
                            },
                            win_options = {
                                winhighlight = "Normal:Normal",
                            },
                        })

                        local preview = make_popup({
                            focusable = false,
                            border = {
                                style = border.preview,
                                text = {
                                    top = picker.preview_title,
                                    top_align = "center",
                                },
                            },
                        })

                        local box_by_kind = {
                            vertical = Layout.Box({
                                Layout.Box(preview, { grow = 1 }),
                                Layout.Box(results, { grow = 1 }),
                                Layout.Box(prompt, { size = 3 }),
                            }, { dir = "col" }),
                            horizontal = Layout.Box({
                                Layout.Box({
                                    Layout.Box(results, { grow = 1 }),
                                    Layout.Box(prompt, { size = 3 }),
                                }, { dir = "col", size = "50%" }),
                                Layout.Box(preview, { size = "50%" }),
                            }, { dir = "row" }),
                            minimal = Layout.Box({
                                Layout.Box(results, { grow = 1 }),
                                Layout.Box(prompt, { size = 3 }),
                            }, { dir = "col" }),
                        }

                        local function get_box()
                            local strategy = picker.layout_strategy

                            if strategy == "vertical" or strategy == "horizontal" then
                                return box_by_kind[strategy], strategy
                            end

                            local height, width = vim.o.lines, vim.o.columns
                            local box_kind = "horizontal"

                            if width < 100 then
                                box_kind = "vertical"
                                if height < 40 then
                                    box_kind = "minimal"
                                end
                            end

                            return box_by_kind[box_kind], box_kind
                        end

                        local function prepare_layout_parts(layout, box_type)
                            layout.results = results

                            results.border:set_style(border.results_patch[box_type])

                            layout.prompt = prompt

                            prompt.border:set_style(border.prompt_patch[box_type])

                            if box_type == "minimal" then
                                layout.preview = nil
                            else
                                layout.preview = preview

                                preview.border:set_style(border.preview_patch[box_type])
                            end
                        end

                        local function get_layout_size(box_kind)
                            return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
                        end

                        local box, box_kind = get_box()
                        local layout = Layout({
                            relative = "editor",
                            position = "50%",
                            size = get_layout_size(box_kind),
                        }, box)
                        layout.picker = picker

                        prepare_layout_parts(layout, box_kind)

                        local layout_update = layout.update

                        function layout:update()
                            local box, box_kind = get_box()

                            prepare_layout_parts(layout, box_kind)
                            layout_update(self, { size = get_layout_size(box_kind) }, box)
                        end

                        return TSLayout(layout)
                    end,

                    layout_strategy = "flex",
                    layout_config = {
                        horizontal = {
                            size = {
                                height = "100%",
                                width = "100%",
                            },
                        },
                        vertical = {
                            size = {
                                height = "100%",
                                width = "100%",
                            },
                        },
                    },
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                            ["<C-u>"] = false,
                        },
                    },
                    vimgrep_arguments = vimgrep_arguments,
                },
                pickers = {
                    find_files = {
                        find_command = {
                            "rg",
                            "--files",
                            "--follow",
                            "--hidden",
                            "--ignore",
                            "--ignore-file",
                            get_nonglobal_rgignore_filepath("shell"),
                            "--ignore-file",
                            get_nonglobal_rgignore_filepath("web-development"),
                        },
                    },
                    live_grep = {
                        find_command = {
                            "rg",
                            "--follow",
                            "--hidden",
                            "--ignore",
                            "--ignore-file",
                            get_nonglobal_rgignore_filepath("shell"),
                            "--ignore-file",
                            get_nonglobal_rgignore_filepath("web-development"),
                        },
                    },
                },
            })
        end,
    },
}
