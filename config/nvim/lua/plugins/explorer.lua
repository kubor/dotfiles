return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<Space>f", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
  },
  opts = {
    window = {
      position = "left",
      width = 40,
    },
  },
}
