return {
  {
    "zbirenbaum/copilot.lua",
    init = function()
      local show_message_request = vim.lsp.handlers["window/showMessageRequest"]

      vim.lsp.handlers["window/showMessageRequest"] = function(err, params, ctx, config)
        local client = ctx and vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == "copilot" and params and params.message:match("^Your account's billing is currently locked") then
          return vim.NIL
        end

        return show_message_request(err, params, ctx, config)
      end
    end,
  },
}
