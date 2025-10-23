-- local options = {
--     formatters_by_ft = {
--         lua = { "stylua" },
--         css = { "prettier" },
--         html = { "prettier" },
--         cpp = { "clang-format" },
--     },
--
--     format_on_save = {
--         -- These options will be passed to conform.format()
--         timeout_ms = 500,
--         lsp_fallback = true,
--     },
-- }
--
-- require("conform").setup(options)
local conform = require "conform"

conform.setup {
    formatters_by_ft = {
        lua = { "stylua" },
        css = { "prettier" },
        html = { "prettier" },
        cpp = { "clang-format" },
        python = { "black" }, -- Add Python formatter if needed
    },

    format_on_save = {
        -- Enable format-on-save
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

-- Explicitly register format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        conform.format { timeout_ms = 500, lsp_fallback = true }
    end,
})
