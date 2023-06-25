local split = require('java-importer.suggestions-strategies.helpers').split
local M = {}

M.run = function(matches, current_word)
  local project_data = vim.fn.system('rg -U --with-filename -t java package')
  local suggestions = split(project_data, '\n')

  for _, suggestion in ipairs(suggestions) do
    local tmp = vim.fn.split(suggestion, "/")
    local names = vim.fn.split(tmp[#tmp], ":")
    local classname = split(names[1], ".")[1]

    if current_word == classname then
      local import_line = string.gsub(names[2], "package ", "") .. "." .. classname

      local found = false
      for _, match in ipairs(matches) do
        if match == import_line then
          found = true
          break
        end
      end

      if not found then
        table.insert(matches, import_line)
      end
    end
  end
end

return M
