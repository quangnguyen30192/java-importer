local fill_suggestions_from_current_project = require('java-importer.suggestions-strategies.find-suggestions-in-current-project').run
local fill_suggestions_from_sync_sources = require('java-importer.suggestions-strategies.find-suggestions-in-sync-sources').run
local has_value = require('java-importer.suggestions-strategies.helpers').has_value
local add_import = require('java-importer.suggestions-strategies.add-import').run

local result_cache = {}

local M = {}
function M.run(...)
  result_cache = {}
  local args = {...}
  local matches = {}
  local current_word = args[1] or vim.fn.expand('<cword>')

  fill_suggestions_from_current_project(matches, current_word)
  fill_suggestions_from_sync_sources(matches, current_word)
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
    coroutine.wrap(function()
      local result = require("fzf").fzf(selections, "--ansi", { width = 100, height = 30, })
      if result then
        for _, rs in ipairs(result) do
          table.insert(result_cache, rs)
        end
        for _, cache in ipairs(result_cache) do
          add_import(cache, current_word)
        end
      end
    end)()
  end
end
return M
