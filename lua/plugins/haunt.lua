return {
  "TheNoeTrevino/haunt.nvim",
  -- default config: change to your liking, or remove it to use defaults
  ---@class HauntConfig
  opts = {
    sign = "󱙝",
    sign_hl = "DiagnosticInfo",
    virt_text_hl = "HauntAnnotation",
    annotation_prefix = " 󰆉 ",
    line_hl = nil,
    virt_text_pos = "eol",
    data_dir = nil,
    picker_keys = {
      delete = { key = "d", mode = { "n" } },
      edit_annotation = { key = "a", mode = { "n" } },
    },
  },

  init = function()
    local haunt = require("haunt.api")
    local haunt_picker = require("haunt.picker")
    local wk = require("which-key")

    local map = vim.keymap.set
    local prefix = "<leader>h"

    wk.add({
      { prefix, group = "haunt", icon = {
        icon = "󱙝",
        color = "blue",
      } },
    })

    -- annotations
    map("n", prefix .. "a", function()
      haunt.annotate()
    end, { desc = "Annotate" })

    map("n", prefix .. "t", function()
      haunt.toggle_annotation()
    end, { desc = "Toggle annotation" })

    map("n", prefix .. "T", function()
      haunt.toggle_all_lines()
    end, { desc = "Toggle all annotations" })

    map("n", prefix .. "d", function()
      haunt.delete()
    end, { desc = "Delete bookmark" })

    map("n", prefix .. "D", function()
      haunt.clear_all()
    end, { desc = "Delete all bookmarks" })

    -- move
    map("n", prefix .. "p", function()
      haunt.prev()
    end, { desc = "Previous bookmark" })

    map("n", prefix .. "n", function()
      haunt.next()
    end, { desc = "Next bookmark" })

    -- picker
    map("n", prefix .. "l", function()
      haunt_picker.show()
    end, { desc = "Show Picker" })

    -- quickfix
    map("n", prefix .. "q", function()
      haunt.to_quickfix()
    end, { desc = "Send Hauntings to QF Lix (buffer)" })

    map("n", prefix .. "Q", function()
      haunt.to_quickfix({ current_buffer = true })
    end, { desc = "Send Hauntings to QF Lix (all)" })

    -- yank
    map("n", prefix .. "y", function()
      haunt.yank_locations({ current_buffer = true })
    end, { desc = "Send Hauntings to Clipboard (buffer)" })

    map("n", prefix .. "Y", function()
      haunt.yank_locations()
    end, { desc = "Send Hauntings to Clipboard (all)" })

    map("n", prefix .. "c", function()
      local line = vim.api.nvim_get_current_line()
      local cms = vim.bo.commentstring
      if not cms or cms == "" or not cms:find("%%s") then
        vim.notify("No valid commentstring defined", vim.log.levels.WARN)
        return
      end

      local escaped_cms = cms:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
      local pattern = escaped_cms:gsub("%%%%s", "(.*)")
      pattern = "%s*" .. pattern .. "$"

      local comment_text = line:match(pattern)
      if comment_text then
        comment_text = vim.trim(comment_text)
        if comment_text == "" then
          return
        end

        local delimiter_pattern = "%s*" .. escaped_cms:gsub("%%%%s", ".*") .. "$"
        local s, _ = line:find(delimiter_pattern)
        if s then
          local new_line = line:sub(1, s - 1):gsub("%s*$", "")
          vim.api.nvim_set_current_line(new_line)

          local success = haunt.annotate(comment_text)
          if not success then
            vim.api.nvim_set_current_line(line)
            vim.notify("Haunt: Failed to create annotation", vim.log.levels.ERROR)
          end
        end
      else
        vim.notify("No comment found", vim.log.levels.INFO)
      end
    end, { desc = "Convert comment to Haunt" })

    -- convert haunt to comment
    map("n", prefix .. "C", function()
      local bookmarks = haunt.get_bookmarks()
      local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
      local current_file = vim.fs.normalize(vim.api.nvim_buf_get_name(0))

      local current_note = nil

      for _, bm in ipairs(bookmarks) do
        if vim.fs.normalize(bm.file) == current_file and bm.line == cursor_line then
          current_note = bm.note
          break
        end
      end

      if current_note then
        local cms = vim.bo.commentstring
        if not cms or cms == "" then
          vim.notify("No commentstring defined, cannot restore", vim.log.levels.WARN)
          return
        end
        if not cms:find("%%s") then
          cms = cms .. " %s"
        end

        local line_content = vim.api.nvim_get_current_line()
        line_content = line_content:gsub("%s*$", "")
        local comment = cms:format(current_note)

        local sep = (line_content == "") and "" or " "
        vim.api.nvim_set_current_line(line_content .. sep .. comment)

        haunt.delete()
      else
        vim.notify("No Haunt annotation found on this line", vim.log.levels.INFO)
      end
    end, { desc = "Restore Haunt to comment" })
  end,
}
