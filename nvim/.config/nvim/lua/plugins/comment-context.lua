return {
  "JoosepAlviste/nvim-ts-context-commentstring",
  event = "VeryLazy",
  config = function()
    vim.g.skip_ts_context_commentstring_module = true
    -- Explicitly support multi-line block comments for JSX/TSX
    require("Comment").setup({
      pre_hook = function(ctx)
        local U = require("Comment.utils")
        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        -- Set up block comment string for multiline block comments in JSX
        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
          location = location,
        })
      end,
    })
  end,
}
