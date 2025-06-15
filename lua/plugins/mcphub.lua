return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
    require("mcphub").setup({
      auto_approve = true, -- 선택사항: 자동 승인
      extensions = {
        avante = {
          make_slash_commands = true,
        },
      },
    })
  end,
}
