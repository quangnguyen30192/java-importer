local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

local encode_items = function(items)
  local items_list_temp = {}
  for _, element in ipairs(items) do
    local encoded_element = string.gsub(element, "%.", "/")
    table.insert(items_list_temp, encoded_element)
  end

  return items_list_temp
end

local decode_item = function(item)
  return string.gsub(item, "/", "%.")
end

M.picker = function(items, on_choice)
  local topts = require("telescope.themes").get_dropdown({
    winblend = 10,
    prompt_prefix = " ⚡",
    results_height = vim.fn.float2nr(vim.api.nvim_get_option("lines") * 0.75),
  })


  pickers
    .new(topts, {
      prompt_title = "Importer",
      finder = finders.new_table({
        results = encode_items(items),
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if selection == nil then
            print("no selection")
            return
          end
          actions.close(prompt_bufnr)

          local selected_item = nil
          local selected_index = nil
          for idx, item in ipairs(selection) do
            selected_index = idx
            selected_item = decode_item(item)
          end
          on_choice(selected_item, selected_index)
        end)
        return true
      end,
      sorter = telescope_config.generic_sorter(topts),
    })
    :find()
end

return M
