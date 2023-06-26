local has_value = require('java-importer.suggestions-strategies.helpers').has_value
local add_import = require('java-importer.suggestions-strategies.add-import').run

local M = {}
local result_cache = {}
local pending_import = 0
function M.run(matches, current_word)
  local selections = {}
  for _, match in ipairs(matches) do
    if not has_value(selections, match) then
      table.insert(selections, match)
    end
  end

  if (#selections == 1) then
    add_import(selections[1], current_word)
  else
    if (#selections == 0) then
      return
    end
    pending_import = pending_import + 1
    result_cache = {}
    coroutine.wrap(function()
      local result = require("fzf").fzf(selections, "--ansi", { width = 100, height = 30, })
      if result then
        for _, rs in ipairs(result) do
          table.insert(result_cache, rs)
        end

        -- wait for picking enough results before import
        if pending_import == #result_cache then
          for _, cache in ipairs(result_cache) do
            add_import(cache, current_word)
          end
        end
      end
    end)()
  end

end

return M
