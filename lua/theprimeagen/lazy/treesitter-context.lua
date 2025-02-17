return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    enable = true,    -- Enable this plugin (Can be toggled later)
    max_lines = 3,    -- Max number of context lines
    trim_scope = "inner", -- How context is trimmed (outer/inner)
    min_window_height = 10, -- Min editor height to show context
    mode = "cursor",  -- Show context for cursor or top-line
    separator = nil,  -- Separator between context and normal text
    multiline_threshold = 20, -- Max lines before hiding multiline context
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
  end,
}

