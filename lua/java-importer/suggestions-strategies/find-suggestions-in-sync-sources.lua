local M = {}

local helpers = require('java-importer.suggestions-strategies.helpers')
local import_cache_path = vim.env.HOME .. '/.import.lib'

local function is_import_line_invalid(line)
  return helpers.startswith(line, "/") or
    helpers.startswith(line, " ")
end

local function getSymbolName(line)
  local words = helpers.split(line, ".")
  local last_word = words[#words]

  return string.gsub(last_word, ";", "")
end

M.run = function(matches, current_word)
  for line in io.lines(import_cache_path) do
    if is_import_line_invalid(line) then goto continue end

    local symbolName = getSymbolName(line)
    if symbolName == current_word then
      table.insert(matches, line)
    end

    ::continue::
  end
end

return M
