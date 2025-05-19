local function pick_script()
    local pilot = require("package-pilot")
  
    local current_dir = vim.fn.getcwd()
    local package = pilot.find_package_file({ dir = current_dir })
  
    if not package then
      vim.notify("No package.json found", vim.log.levels.ERROR)
      return require("dap").ABORT
    end
  
    local scripts = pilot.get_all_scripts(package)
  
    local label_fn = function(script)
      return script
    end
  
    local co, ismain = coroutine.running()
    local ui = require("dap.ui")
    local pick = (co and not ismain) and ui.pick_one or ui.pick_one_sync
    local result = pick(scripts, "Select script", label_fn)
    return result or require("dap").ABORT
  end
  
  return {
    "mfussenegger/nvim-dap",
    dependencies = { "banjo/package-pilot.nvim" },
    keys = {
        {
          "<leader>dB",
          function()
            require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
          end,
          desc = "Breakpoint Condition",
        },
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
        },
        {
          "<leader>dc",
          function()
            require("dap").continue()
          end,
          desc = "Run/Continue",
        },
        {
          "<leader>da",
          function()
            require("dap").continue { before = get_args }
          end,
          desc = "Run with Args",
        },
        {
          "<leader>dC",
          function()
            require("dap").run_to_cursor()
          end,
          desc = "Run to Cursor",
        },
        {
          "<leader>dg",
          function()
            require("dap").goto_()
          end,
          desc = "Go to Line (No Execute)",
        },
        {
          "<leader>di",
          function()
            require("dap").step_into()
          end,
          desc = "Step Into",
        },
        {
          "<leader>dj",
          function()
            require("dap").down()
          end,
          desc = "Down",
        },
        {
          "<leader>dk",
          function()
            require("dap").up()
          end,
          desc = "Up",
        },
        {
          "<leader>dl",
          function()
            require("dap").run_last()
          end,
          desc = "Run Last",
        },
        {
          "<leader>do",
          function()
            require("dap").step_out()
          end,
          desc = "Step Out",
        },
        {
          "<leader>dO",
          function()
            require("dap").step_over()
          end,
          desc = "Step Over",
        },
        {
          "<leader>dP",
          function()
            require("dap").pause()
          end,
          desc = "Pause",
        },
        {
          "<leader>dr",
          function()
            require("dap").repl.toggle()
          end,
          desc = "Toggle REPL",
        },
        {
          "<leader>ds",
          function()
            require("dap").session()
          end,
          desc = "Session",
        },
        {
          "<leader>dt",
          function()
            require("dap").terminate()
          end,
          desc = "Terminate",
        },
        {
          "<leader>dw",
          function()
            require("dap.ui.widgets").hover()
          end,
          desc = "Widgets",
        },
    },
    opts = function(_, opts)
      local dap = require("dap")
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
  
      local current_file = vim.fn.expand("%:t")
      for _, language in ipairs(js_filetypes) do
        dap.configurations[language] = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
            },
            {
                name = "tsx (" .. current_file .. ")",
                type = "node",
                request = "launch",
                program = "${file}",
                runtimeExecutable = "tsx",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
                skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
            },
            {
                type = "node",
                request = "launch",
                name = "pick script (pnpm)",
                runtimeExecutable = "pnpm",
                runtimeArgs = { "run", pick_script },
                cwd = "${workspaceFolder}",
            },
            {
                type= "node-terminal",
                name= "Run Script: start:debug",
                request= "launch",
                command= "npm run start:debug",
                cwd = "${workspaceFolder}"
            }
        }
      end
    end,
  }