local M = {}
local has_value = require('java-importer.suggestions-strategies.helpers').has_value
local build_importline = require('java-importer.suggestions-strategies.helpers').build_importline

M.run = function(matches, current_word)
  local files_matched = vim.fn.systemlist("rg -t java --files-with-matches '(enum|class|interface) " .. current_word .." '")

  for _, file_matched in ipairs(files_matched) do
    local package_lines = vim.fn.systemlist("grep 'package' " .. file_matched)
    local import_line = build_importline(package_lines[1], current_word)

    if not has_value(matches, import_line) then
      table.insert(matches, import_line)
    end
  end
end

return M

