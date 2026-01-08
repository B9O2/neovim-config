function GetOSInfo()
  if vim.fn.has("macunix") == 1 then
    return "MACOS DARWIN"
  end
  if vim.fn.has("win32") == 1 then
    return "WINDOWS NT"
  end
  local f = io.open("/etc/os-release", "r")
  if f then
    local content = f:read("*a")
    f:close()
    local name = content:match('NAME="([^"]+)"') or content:match("NAME=([^\n]+)")
    if name then
      return string.upper(name)
    end
  end
  return "GNU/LINUX"
end

return {
  "nvimdev/dashboard-nvim",
  lazy = false,
  opts = function()
    -- 1. Aperture Science ASCII Logo (保持之前的配置)
    local aperture_logo = {
      [[              .,-:;//;:=,               ]],
      [[          . :H@@@MM@M#H/.,+%;,          ]],
      [[       ,/X+ +M@@M@MM%=,-%HMMM@X/,       ]],
      [[     -+@MM; $M@@MH+-,;XMMMM@MMMM@+-     ]],
      [[    ;@M@@M- XM@X;. -+XXXXXHHH@M@M#@/.   ]],
      [[  ,%MM@@MH ,@%=             .---=-=:=,. ]],
      [[  =@#@@@MX.,                -%HX$$%%%:; ]],
      [[ =-./@M@M$                   .;@MMMM@MM:]],
      [[ X@/ -$MM/                    . +MM@@@M$]],
      [[ ,@M@H: :@:                    . =X#@@@@-]],
      [[ ,@@@MMX, .                    /H- ;@M@M=]],
      [[ .H@@@@M@+,                    %MM+..%#$.]],
      [[  /MMMM@MMH/.                  XM@MH; =;]],
      [[   /%+%$XHH@$=              , .H@@@@MX, ]],
      [[    .=--------.           -%H.,@@@@@MX, ]],
      [[    .%MM@@@HHHXX$$$%+- .:$MMX =M@@MM%.  ]],
      [[      =XMMM@MM@MM#H;,-+HMM@M+ /MMMX=    ]],
      [[        =%@M@M#@$-.=$@MM@@@M; %M%=      ]],
      [[          ,:+$+-,/H#MMMMMMM@= =,        ]],
      [[                =++%%%%+/:-.            ]],
    }

    -- 留白控制
    local top_padding = 5
    local bottom_padding = 3
    for _ = 1, top_padding do
      table.insert(aperture_logo, 1, "")
    end
    for _ = 1, bottom_padding do
      table.insert(aperture_logo, "")
    end

    local opts = {
      theme = "doom",
      hide = { statusline = false },
      config = {
        header = aperture_logo,
        -- 2. 按钮配置 (保持不变)
        center = {
          {
            action = "lua LazyVim.pick()()",
            desc = " Acquire Subject Data",
            icon = " ",
            key = "f",
          },
          {
            action = "ene | startinsert",
            desc = " Init New Protocol",
            icon = " ",
            key = "n",
          },
          {
            action = 'lua LazyVim.pick("oldfiles")()',
            desc = " Previous Attempts",
            icon = " ",
            key = "r",
          },
          {
            action = 'lua LazyVim.pick("live_grep")()',
            desc = " Data Mining",
            icon = " ",
            key = "g",
          },
          {
            action = "lua LazyVim.pick.config_files()()",
            desc = " Facility Settings",
            icon = " ",
            key = "c",
          },
          {
            action = 'lua require("persistence").load()',
            desc = " Restore Consciousness",
            icon = " ",
            key = "s",
          },
          {
            action = "LazyExtras",
            desc = " Enrichment Add-ons",
            icon = " ",
            key = "x",
          },
          {
            action = "Lazy",
            desc = " Core Management",
            icon = "󰒲 ",
            key = "l",
          },
          {
            action = function()
              vim.api.nvim_input("<cmd>qa<cr>")
            end,
            desc = " Cease Operations",
            icon = " ",
            key = "q",
          },
        },

        -- 3. 动态 Footer
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

          -- 调用函数获取真实的 OS 名称

          local quotes = {
            "The cake is a lie.",
            "This was a triumph. I'm making a note here: HUGE SUCCESS.",
            "Please note that we have added a consequence for failure.",
            "Science isn't about WHY. It's about WHY NOT.",
            "The Enrichment Center reminds you that the Companion Cube will never threaten to stab you.",
            "Unbelievable. You, [SUBJECT NAME HERE], must be the pride of [SUBJECT HOMETOWN HERE].",
            "Quit now and cake will be served immediately.",
          }
          math.randomseed(os.time())
          local random_quote = quotes[math.random(#quotes)]

          return {
            "",
            "┌─ [ SYSTEM STATUS ] ──────────────────────┐",
            "│  Test Subject   : FELIX                  │",
            -- 这里使用 detected_os 变量，并且用 string.format 控制长度
            "│  Chamber OS     : "
              .. string.format("%-23s", GetOSInfo())
              .. "│",
            "│  Startup Latency: " .. string.format("%-23s", ms .. "ms") .. "│",
            "│  Active Modules : " .. string.format("%-23s", stats.loaded .. "/" .. stats.count) .. "│",
            "└──────────────────────────────────────────┘",
            "",
            "> " .. random_quote,
          }
        end,
      },
    }

    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
}
