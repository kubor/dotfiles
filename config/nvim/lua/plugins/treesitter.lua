return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    -- neovim 0.12+ uses vim.treesitter natively
    -- nvim-treesitter provides parser installation and management
    require("nvim-treesitter").setup()

    -- Install parsers via :TSInstall command
    -- Pre-installed parsers: bash, css, go, html, javascript, json, lua,
    -- markdown, markdown_inline, python, r, ruby, rust, toml, typescript, vue, yaml
  end,
}
