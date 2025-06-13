return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "gemini",
    providers = {
      gemini = {
        endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
        model = "gemini-2.5-flash-preview-05-20",
        timeout = 30000,
        extra_request_body = {
          generationConfig = {
            temperature = 0.75,
            topK = 40,
            topP = 0.95,
          },
          safetySettings = {
            {
              category = "HARM_CATEGORY_DANGEROUS_CONTENT",
              threshold = "BLOCK_NONE",
            },
          },
        },
      },
    },
    code_block = {
      enable_copy = true,
      enable_run = true,
      run_commands = {
        python = "python3",
        sh = "bash",
      },
    },
    ui = {
      theme = "auto",
      show_token_count = true,
      show_model_info = true,
      auto_suggestions = true,
      diff_mode = true,
    },
    context = {
      include_diagnostics = true,
      include_treesitter = true,
      include_git_diff = true,
    },
    post_process = {
      format_code = true,
      organize_imports = true,
      add_type_hints = true,
    },
    input = {
      provider = "snacks",
      provider_opts = {
        title = "Avante Input",
        icon = "󰌌 ",
      },
    },
    system_prompt = function()
      local hub = require("mcphub").get_hub_instance()
      return hub and hub:get_active_servers_prompt() or ""
    end,

    custom_tools = function()
      return {
        require("mcphub.extensions.avante").mcp_tool(),
      }
    end,
  },
  build = "make",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "stevearc/dressing.nvim", -- for input provider dressing
    "folke/snacks.nvim", -- for input provider snacks
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
