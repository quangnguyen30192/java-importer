local split = require('java-importer.suggestions-strategies.helpers').split
local M = {}

local function buildImportLine(package, classname)
  local removedPackage = string.gsub(package, "package ", "")
  local removedSemicolon = string.gsub(removedPackage, ";", "")

  return removedSemicolon .. "." .. classname .. ";"
end

M.run = function(matches, current_word)
  local project_data = vim.fn.system("rg -U --with-filename -t java 'package '")
  local suggestions = split(project_data, '\n')

  for _, suggestion in ipairs(suggestions) do
    local dirs = vim.fn.split(suggestion, "/")
    local arrayOfClassNameAndPackage = vim.fn.split(dirs[#dirs], ":")
    local classname = split(arrayOfClassNameAndPackage[1], ".")[1]

    if current_word == classname then
      local package = arrayOfClassNameAndPackage[2]
      local import_line = buildImportLine(package, classname)

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
