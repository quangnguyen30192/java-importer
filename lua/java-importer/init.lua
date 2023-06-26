local fill_suggestions_from_current_project = require('java-importer.suggestions-strategies.find-suggestions-in-current-project').run
local fill_suggestion_from_current_project_with_name_matches = require('java-importer.suggestions-strategies.find-suggestion-in-current-project-with-name-matches').run
local fill_suggestions_from_sync_sources = require('java-importer.suggestions-strategies.find-suggestions-in-sync-sources').run
local add_import_from_matches = require('java-importer.suggestions-strategies.add-import-from-matches').run

local M = {}
function M.run(...)
  local args = {...}
  local matches = {}
  local current_word = args[1] or vim.fn.expand('<cword>')

  fill_suggestion_from_current_project_with_name_matches(matches, current_word)
  if matches[1] then
    add_import_from_matches(matches, current_word)
  else
    fill_suggestions_from_current_project(matches, current_word)
    fill_suggestions_from_sync_sources(matches, current_word)
    add_import_from_matches(matches, current_word)
  end
end

return M
