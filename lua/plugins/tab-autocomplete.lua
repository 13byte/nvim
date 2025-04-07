return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- 기존 설정 추가
    opts.signature = { enabled = true }
    opts.keymap = {
      preset = "default",
      ["<Tab>"] = { "select_and_accept", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
    }

    -- Snacks.toggle()을 사용하여 토글 명령어 설정
    Snacks.toggle({
      name = "Completion",
      get = function()
        return vim.b.completion
      end,
      set = function(state)
        vim.b.completion = state
      end,
    }):map("<leader>uk")

    -- opts.enabled를 토글 상태에 따라 결정되도록 설정
    opts.enabled = function()
      return vim.b.completion ~= false
    end

    return opts
  end,
}
