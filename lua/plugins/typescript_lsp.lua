-- lua/plugins/typescript_lsp.lua

return {
  {
    "neovim/nvim-lspconfig",
    -- 将 opts 从一个表改为一个函数
    -- opts: 接收 LazyVim 传递进来的现有 opts 配置
    opts = function(_, opts)
      -- 这是一个包含您提供的 TypeScript/JavaScript 配置的局部变量
      local ts_config = {
        -- make sure mason installs the server
        servers = {
          --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
          --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
          tsserver = {
            enabled = false,
          },
          ts_ls = {
            enabled = false,
          },
          vtsls = {
            -- explicitly add default filetypes, so that we can extend
            -- them in related extras
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
            },
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  maxInlayHintLength = 30,
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
            keys = {
              {
                "gD",
                function()
                  local params = vim.lsp.util.make_position_params()
                  require("lazyvim.util").lsp.execute({
                    command = "typescript.goToSourceDefinition",
                    arguments = { params.textDocument.uri, params.position },
                    open = true,
                  })
                end,
                desc = "Goto Source Definition",
              },
              {
                "gR",
                function()
                  require("lazyvim.util").lsp.execute({
                    command = "typescript.findAllFileReferences",
                    arguments = { vim.uri_from_bufnr(0) },
                    open = true,
                  })
                end,
                desc = "File References",
              },
              {
                "<leader>co",
                require("lazyvim.util").lsp.action["source.organizeImports"],
                desc = "Organize Imports",
              },
              {
                "<leader>cM",
                require("lazyvim.util").lsp.action["source.addMissingImports.ts"],
                desc = "Add missing imports",
              },
              {
                "<leader>cu",
                require("lazyvim.util").lsp.action["source.removeUnused.ts"],
                desc = "Remove unused imports",
              },
              {
                "<leader>cD",
                require("lazyvim.util").lsp.action["source.fixAll.ts"],
                desc = "Fix all diagnostics",
              },
              {
                "<leader>cV",
                function()
                  require("lazyvim.util").lsp.execute({ command = "typescript.selectTypeScriptVersion" })
                end,
                desc = "Select TS workspace version",
              },
            },
          },
        },
        setup = {
          --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
          --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
          tsserver = function()
            -- disable tsserver
            return true
          end,
          ts_ls = function()
            -- disable tsserver
            return true
          end,
          vtsls = function(_, opts)
            if vim.lsp.config.denols and vim.lsp.config.vtsls then
              ---@param server string
              local resolve = function(server)
                local markers, root_dir = vim.lsp.config[server].root_markers, vim.lsp.config[server].root_dir
                vim.lsp.config(server, {
                  root_dir = function(bufnr, on_dir)
                    local is_deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) ~= nil
                    if is_deno == (server == "denols") then
                      if root_dir then
                        return root_dir(bufnr, on_dir)
                      elseif type(markers) == "table" then
                        local root = vim.fs.root(bufnr, markers)
                        return root and on_dir(root)
                      end
                    end
                  end,
                })
              end
              resolve("denols")
              resolve("vtsls")
            end

            require("lazyvim.util").lsp.on_attach(function(client, buffer)
              client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
                ---@type string, string, lsp.Range
                local action, uri, range = unpack(command.arguments)

                local function move(newf)
                  client:request("workspace/executeCommand", {
                    command = command.command,
                    arguments = { action, uri, range, newf },
                  })
                end

                local fname = vim.uri_to_fname(uri)
                client:request("workspace/executeCommand", {
                  command = "typescript.tsserverRequest",
                  arguments = {
                    "getMoveToRefactoringFileSuggestions",
                    {
                      file = fname,
                      startLine = range.start.line + 1,
                      startOffset = range.start.character + 1,
                      endLine = range["end"].line + 1,
                      endOffset = range["end"].character + 1,
                    },
                  },
                }, function(_, result)
                  ---@type string[]
                  local files = result.body.files
                  table.insert(files, 1, "Enter new path...")
                  vim.ui.select(files, {
                    prompt = "Select move destination:",
                    format_item = function(f)
                      return vim.fn.fnamemodify(f, ":~:.")
                    end,
                  }, function(f)
                    if f and f:find("^Enter new path") then
                      vim.ui.input({
                        prompt = "Enter move destination:",
                        default = vim.fn.fnamemodify(fname, ":h") .. "/",
                        completion = "file",
                      }, function(newf)
                        return newf and move(newf)
                      end)
                    elseif f then
                      move(f)
                    end
                  end)
                end)
              end
            end, "vtsls")
            -- copy typescript settings to javascript
            opts.settings.javascript =
              vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
          end,
        },
      }

      -- 使用 vim.tbl_deep_extend("force", ...) 将现有配置 (opts) 和新的 TS 配置 (ts_config) 合并
      -- 确保所有配置 (包括 Python) 都被保留
      return vim.tbl_deep_extend("force", opts, ts_config)
    end,
  },
}
