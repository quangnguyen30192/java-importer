local split = require('java-importer.suggestions-strategies.helpers').split
local has_value = require('java-importer.suggestions-strategies.helpers').has_value
local build_importline = require('java-importer.suggestions-strategies.helpers').build_importline
local M = {}

M.run = function(matches, current_word)
  local filesAndPackagesMatched = vim.fn.systemlist("rg -U --with-filename -t java 'package '")

  for _, suggestion in ipairs(filesAndPackagesMatched) do
    local dirs = vim.fn.split(suggestion, "/")
    local arrayOfClassNameAndPackage = vim.fn.split(dirs[#dirs], ":")
    local classname = split(arrayOfClassNameAndPackage[1], ".")[1]

    if current_word == classname then
      local package_line = arrayOfClassNameAndPackage[2]
      local import_line = build_importline(package_line, classname)

      if not has_value(matches, import_line) then
        table.insert(matches, import_line)
      end
    end
  end
end

return M
