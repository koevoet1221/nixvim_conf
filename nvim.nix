{
  inputs,
  pkgs,
  ...
}:
{
  keymaps = [
    # --- Refactoring ----------------------------
    # --- Visual Mode (Selection Required) ---
    {
      mode = "x";
      key = "<leader>re";
      action = ":Refactor extract ";
      options = {
        desc = "Refactor: Extract Function";
        silent = false;
      };
    }
    {
      mode = "x";
      key = "<leader>rf";
      action = ":Refactor extract_to_file ";
      options = {
        desc = "Refactor: Extract to File";
        silent = false;
      };
    }
    {
      mode = "x";
      key = "<leader>rv";
      action = ":Refactor extract_var ";
      options = {
        desc = "Refactor: Extract Variable";
        silent = false;
      };
    }

    # --- Normal & Visual Mode ---
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>ri";
      action = ":Refactor inline_var";
      options = {
        desc = "Refactor: Inline Variable";
        silent = true;
      };
    }

    # --- Normal Mode (Cursor Context) ---
    {
      mode = "n";
      key = "<leader>rI";
      action = ":Refactor inline_func";
      options = {
        desc = "Refactor: Inline Function";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>rb";
      action = ":Refactor extract_block";
      options = {
        desc = "Refactor: Extract Block";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>rbf";
      action = ":Refactor extract_block_to_file";
      options = {
        desc = "Refactor: Extract Block to File";
        silent = true;
      };
    }
    # ── File pickers ─────────────────────
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options.desc = "Find files (respect .gitignore)";
    }
    {
      mode = "n";
      key = "<leader>fF";
      action = "<cmd>Telescope find_files hidden=true no_ignore=true<CR>";
      options.desc = "Find all files (including ignored)";
    }
    {
      mode = "n";
      key = "<leader>fo";
      action = "<cmd>Telescope oldfiles<CR>";
      options.desc = "Recent files";
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.desc = "Buffers";
    }

    # ── Grep / search in files ───────────
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep (ripgrep)";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action = "<cmd>Telescope live_grep<CR>";
      options.desc = "Live grep (ripgrep)";
    }
    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
      options.desc = "Fuzzy find in current buffer";
    }

    # ── Vim / help ───────────────────────
    {
      mode = "n";
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.desc = "Help tags";
    }
    {
      mode = "n";
      key = "<leader>fk";
      action = "<cmd>Telescope keymaps<CR>";
      options.desc = "Keymaps";
    }
  ];

  plugins.refactoring = {
    enable = true;
    enableTelescope = true;
  };

  plugins.schemastore = {
    enable = true;
    json.enable = true;
  };

  colorschemes.catppuccin.enable = true;
  plugins.cmp_luasnip.enable = true;
  plugins.treesitter-context.enable = true;

  plugins.lualine.enable = true;

  plugins.luasnip.enable = true;

  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };
  };

  plugins.web-devicons.enable = true;

  plugins.friendly-snippets.enable = true;

  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 500;
        lsp_fallback = true;
      };
      formatters_by_ft = {
        java = {
          lsp_format = "prefer";
        };
        python = [ "ruff_format" ];
        html = [ "prettier" ];
        javascript = [ "prettier" ];
        css = [ "prettier" ];
        json = [ "prettier" ];
      };
    };
  };

  plugins.nvim-autopairs = {
    enable = true;
    settings = {
      disable_filetype = [
        "TelescopePrompt"
        "vim"
      ];
      break_undo = true;
      check_ts = true;
    };
  };

  plugins.treesitter = {
    enable = true;
  };

  plugins.nvim-tree = {
    enable = true;
    actions = {
      openFile = {
        quitOnOpen = true;
        resizeWindow = true;
      };
    };
  };

  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "luasnip"; }
      ];
      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<C-space>" = "cmp.mapping.complete()";

        "<Tab>" = ''
          cmp.mapping(function(fallback)
            local luasnip = require('luasnip')
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            elseif luasnip.in_snippet() and luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';

        "<S-Tab>" = ''
          cmp.mapping(function(fallback)
            local luasnip = require('luasnip')
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" })
        '';
      };
    };
  };

  plugins.lsp = {
    enable = true;

    servers = {
      html.enable = true;
      cssls.enable = true;
      ts_ls = {
        enable = true;
        filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
        ];
      };
      emmet_ls = {
        enable = true;
        filetypes = [
          "html"
          "css"
          "javascriptreact"
          "typescriptreact"
        ];
        extraOptions = {
          init_options = {
            html.options."bem.enabled" = true;
          };
        };
      };
      tailwindcss = {
        enable = true;
        filetypes = [
          "html"
          "css"
          "javascriptreact"
          "typescriptreact"
        ];
      };
      lua_ls = {
        enable = true;
        settings.telemetry.enable = false;
      };
      pyright = {
        enable = true;
      };
      ruff = {
        enable = true;
      };
      nixd = {
        enable = true;
      };
      jdtls = {
        enable = true;
        settings = {
          java = {
            configuration = {
              runtimes = [
                {
                  name = "JavaSE-1.8";
                  path = "${pkgs.openjdk8}/lib/openjdk";
                }
                {
                  name = "JavaSE-17";
                  path = "${pkgs.openjdk17}/lib/openjdk";
                }
                {
                  name = "JavaSE-21";
                  path = "${pkgs.openjdk21}/lib/openjdk";
                  default = true;
                }
              ];
            };
            eclipse.downloadSources = true;
            maven.downloadSources = true;
            implementationsCodeLens.enabled = true;
            referencesCodeLens.enabled = true;
            references.includeDecompiledSources = true;
            format = {
              enabled = true;
              settings = {
                tabSize = 2;
              };
            };
          };
        };
        rootMarkers = [
          ".git"
          "mvnw"
          "gradlew"
          "pom.xml"
        ];
      };
      rust_analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };
      jsonls = {
        enable = true;
        settings = {
          json = {
            schemas = {
              __raw = "require('schemastore').json.schemas()";
            };
            validate = {
              enable = true;
            };
          };
        };
      };
    };
  };

  # Keymaps
  extraConfigLua = ''
    require("ts-node-action").setup({})
        -- Auto-build on save (customize per project/type if you want)
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*.java", "pom.xml" },        -- trigger on Java files or pom changes
        callback = function()
          -- For Maven projects
          if vim.fn.filereadable("pom.xml") == 1 then
            vim.cmd("silent !mvn clean package -q &")   -- background, no output spam
            print("Maven compile triggered")
          end
        end,
      })
                -- LSP keymaps on attach
                vim.api.nvim_create_autocmd("LspAttach", {
                  callback = function(args)
                    local opts = { buffer = args.buf, silent = true }
                    -- Diagnostics
                    vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
                    vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
                    -- Code actions
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    -- Go to
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "rn", vim.lsp.buf.rename, opts)
                    -- Hover and signature
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
                    -- Workspace
                    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
                  end,
                })

                -- Auto-format Java on save
                -- vim.api.nvim_create_autocmd("BufWritePre", {
                --   pattern = "*.java",
                --   callback = function()
                --     vim.lsp.buf.format({ async = false })
                --   end,
                -- })
          -- Enforce tab/indent settings for Java buffers (ensures LSP request sends tabSize=2)
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "java",
              callback = function()
                vim.bo.shiftwidth = 2
                vim.bo.tabstop = 2
                vim.bo.expandtab = true  -- Use spaces (aligns with JDTLS default insertSpaces=true)
              end,
            })
                -- Highlight on yank
                vim.api.nvim_create_autocmd("TextYankPost", {
                  callback = function() vim.highlight.on_yank({ timeout = 100 }) end,
                })



                	    -- Toggle nvim-tree
                	    local nvimtree = require('nvim-tree.api').tree
                	    vim.keymap.set('n', '<C-n>', nvimtree.toggle, { desc = 'Toggle nvim-tree' })

                	    -- Optional: Auto-open on startup if no file
                	    vim.api.nvim_create_autocmd({ "VimEnter" }, {
                		callback = function()
                		local stat = vim.loop.fs_stat(vim.loop.cwd())
                		if stat and stat.type == "directory" then
                		require("nvim-tree.api").tree.open()
                		end
                		end,
                		})

                	    local keymap = vim.keymap.set
                            keymap('n', '<leader>g', '<cmd>Telescope live_grep<CR>')
                            keymap('i', 'jj', '<Esc>', { noremap = true })

                            vim.api.nvim_create_autocmd("VimEnter", {
                      	  callback = function()
                      	  vim.defer_fn(function()
                      	      vim.cmd("silent !kitty @ set-spacing padding=0 margin=0")
                      	      end, 100)
                      	  end,
                      	  })

                          vim.api.nvim_create_autocmd("VimLeave", {
                      	callback = function()
                      	vim.cmd("silent !kitty @ set-spacing padding=0 margin=15")
                      	end,
                      	})
  '';

  extraConfigLuaPre = ''
    vim.api.nvim_set_hl(0, 'Comment', {
      fg = '#ff00ff',
      bg = '#000000',
      underline = true,
      bold = true
    })
  '';

  globals.mapleader = " ";

  opts = {
    number = true; # Show line numbers
    relativenumber = true;
    shiftwidth = 2;
  };
}
