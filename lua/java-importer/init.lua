local fill_suggestions_from_current_project = require('java-importer.suggestions-strategies.find-suggestions-in-current-project').run
local fill_suggestion_from_current_project_with_name_matches = require('java-importer.suggestions-strategies.find-suggestion-in-current-project-with-name-matches').run
local fill_suggestions_from_sync_sources = require('java-importer.suggestions-strategies.find-suggestions-in-sync-sources').run
local has_value = require('java-importer.suggestions-strategies.helpers').has_value
local add_import = require('java-importer.suggestions-strategies.add-import').run
local picker = require('java-importer.pickers').picker

local M = {}

function M.run(...)
  local args = {...}
  local matches = {}
  local current_word = args[1] or vim.fn.expand('<cword>')

  fill_suggestion_from_current_project_with_name_matches(matches, current_word)
  if #matches > 0 then
    picker(matches, function(item, index)
      add_import(item, current_word)
    end)
    return
  end

  fill_suggestions_from_current_project(matches, current_word)
  fill_suggestions_from_sync_sources(matches, current_word)

  if (#matches == 0) then
    print("No candidates found")
    return
  end

  if (#matches == 1) then
    add_import(matches[1], current_word)
  else
    picker(matches, function(item, index)
      add_import(item, current_word)
    end)
  end
end

return M
