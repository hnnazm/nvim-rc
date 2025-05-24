return {
  cmd = { "vue-language-server", "--stdio" },
  root_markers = { "package.json", "vue.config.js" },
  init_options = {
    typescript = {
      tsdk = ""
    },
    before_init = function(params, config)
      local lib_path = vim.fs.find('node_modules/typescript/lib', { path = new_root_dir, upward = true })[1]
      if lib_path then
        config.init_options.typescript.tsdk = lib_path
      end
    end
  },
  filetypes = { "vue" }
}
