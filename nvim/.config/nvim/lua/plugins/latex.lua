return {
  "lervag/vimtex",
  lazy = false, -- disable lazy-loading for VimTeX (optional)
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_latexmk = {
      executable = "latexmk",
      options = {
        "-xelatex",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
      },
    }
  end,
}
