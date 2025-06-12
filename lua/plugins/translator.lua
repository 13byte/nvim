return {
  "doodleEsc/translator.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("translator").setup({
      -- Translation engine configuration
      translate_engine = {
        base_url = "https://generativelanguage.googleapis.com/v1beta",
        api_key = os.getenv("GEMINI_API_KEY"), -- Set your OpenAI API key in environment variable
        model = "gemini-2.5-flash-preview-05-20",
        temperature = 0.8,
        streaming = true, -- Enable streaming translation
      },
      -- Language detection engine configuration
      detect_engine = {
        base_url = "https://generativelanguage.googleapis.com/v1beta",
        api_key = os.getenv("GEMINI_API_KEY"),
        model = "gemini-2.5-flash-preview-05-20",
      },
      -- UI configuration
      ui = {
        width = 0.8, -- Window width (80% of screen)
        height = 0.4, -- Window height (40% of screen)
        border = {
          style = "rounded",
          text = {
            top_source = " Source ",
            top_target = " Translation ",
            top_align = "center",
          },
        },
      },
      -- Translation settings
      proxy = nil, -- Set proxy if needed
      prompt = "Translate the following text from $SOURCE_LANG to $TARGET_LANG, no explanations.:\n```$TEXT\n```",
      source_language = "en", -- Set to "auto" for automatic detection
      target_language = "ko", -- Default target language
      -- Keymaps configuration
      keymaps = {
        enable = true,
        translate = "<leader>ts", -- Translation shortcut in visual mode
      },
    })
  end,
}
