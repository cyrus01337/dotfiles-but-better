return {
    "barrett-ruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop" },
    config = true,
    opts = {
        args = { "--no-browser", "--port=3000" },
        install_path = "$FNM_DIR/aliase/default/bin",
    },
}
