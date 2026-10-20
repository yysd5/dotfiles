return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")

    -- マルチモジュールプロジェクトのルートディレクトリを見つける関数
    local function get_project_root()
      local markers = { "pom.xml", "build.gradle", "settings.gradle", ".git" }
      local current_dir = vim.fn.expand("%:p:h")

      -- 親pom.xml（modulesを含む）を優先的に探す
      local function find_parent_pom(path)
        local current = path
        while current ~= "/" do
          local pom_path = current .. "/pom.xml"
          if vim.fn.filereadable(pom_path) == 1 then
            local content = vim.fn.readfile(pom_path)
            for _, line in ipairs(content) do
              if string.match(line, "<modules>") or string.match(line, "<module>") then
                return current
              end
            end
          end
          current = vim.fn.fnamemodify(current, ":h")
        end
        return nil
      end

      local parent_root = find_parent_pom(current_dir)
      if parent_root then
        return parent_root
      end

      -- fallback: 通常のマーカーファイルを探す
      return vim.fs.dirname(vim.fs.find(markers, { upward = true })[1]) or vim.fn.getcwd()
    end

    local project_root = get_project_root()
    local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. vim.fn.fnamemodify(project_root, ":t")

    local config = {
      cmd = {
        "jdtls",
        "-data",
        workspace_dir,
      },
      root_dir = project_root,
      settings = {
        java = {
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org",
            },
          },
          eclipse = { downloadSources = true },
          format = {
            enabled = true,
          },
          implementationsCodeLens = { enabled = true },
          inlayHints = { parameterNames = { enabled = "all" } },
          maven = { downloadSources = true },
          referencesCodeLens = { enabled = true },
          references = { includeDecompiledSources = true },
          saveActions = {
            organizeImports = false,
          },
          signatureHelp = { enabled = true },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },
      on_attach = function(client, bufnr)
        -- 共通のLSPキーマップを設定
        require("yyossy.lsp_keymaps").setup_lsp_keymaps(bufnr)

        -- Java固有のキーマップ
        local opts = { buffer = bufnr, silent = true }

        opts.desc = "Organize imports"
        vim.keymap.set("n", "<leader>jo", function()
          vim.lsp.buf.code_action({
            context = { only = { "source.organizeImports" } },
            apply = true,
          })
        end, opts)

        opts.desc = "Add missing imports"
        vim.keymap.set("n", "<leader>ji", function()
          vim.lsp.buf.code_action({
            filter = function(action)
              return action.kind
                and (
                  string.match(action.kind, "quickfix")
                  or string.match(action.kind, "source")
                  or string.match(action.title, "[Ii]mport")
                )
            end,
          })
        end, opts)
      end,
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }

    jdtls.start_or_attach(config)
  end,
}
