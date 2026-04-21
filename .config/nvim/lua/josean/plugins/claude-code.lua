return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true,
  keys = {
    { "<C-,>",       "<cmd>ClaudeCode<cr>",              desc = "Toggle Claude" },
    { "<leader>cc",  "<cmd>ClaudeCode<cr>",              desc = "Toggle Claude" },
    { "<leader>cf",  "<cmd>ClaudeCodeFocus<cr>",         desc = "Focus Claude" },
    { "<leader>cr",  "<cmd>ClaudeCode --resume<cr>",     desc = "Resume Claude" },
    { "<leader>cC",  "<cmd>ClaudeCode --continue<cr>",   desc = "Continue Claude" },
    { "<leader>cb",  "<cmd>ClaudeCodeAdd %<cr>",         desc = "Add current buffer" },
    { "<leader>cs",  "<cmd>ClaudeCodeSend<cr>",          mode = "v", desc = "Send selection" },
    { "<leader>ca",  "<cmd>ClaudeCodeDiffAccept<cr>",    desc = "Accept diff" },
    { "<leader>cd",  "<cmd>ClaudeCodeDiffDeny<cr>",      desc = "Deny diff" },
  },
}
