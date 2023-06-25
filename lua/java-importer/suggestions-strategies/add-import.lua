local M = {}

local function has_line_already_imported(line)
  for i = 1, vim.fn.line('$'), 1 do
    local l = vim.fn.getbufline(vim.fn.bufnr(), i)[1]

    if l == 'import ' .. line then
      print('line already imported')
      return true
    end
  end

  return false
end

local function is_import_same_package(line, current_word)
  local first_line = vim.fn.getbufline(vim.fn.bufnr(), 1)[1]
  local package_name = string.gsub(first_line, "package ", "")

  if line == package_name .. "." .. current_word then
    print("Skip import class on same package")
    return true
  end

  return false
end

function M.run(line, current_word)
  if has_line_already_imported(line) or is_import_same_package(line, current_word) then return end
  if line == '' or line == nil then return end

  local second_line = vim.fn.getbufline(vim.fn.bufnr(), 2)[1]
  local third_line = vim.fn.getbufline(vim.fn.bufnr(), 3)[1]
  local start_index = string.find(third_line, 'import')
  local has_import_before = start_index == 1

  -- need one blank line after package a.b.c
  if second_line ~= '' then
    vim.fn.appendbufline(vim.fn.bufnr(), 1, '')
  end

  -- make sure has one blank line after import block
  if third_line == '' or has_import_before then
    vim.fn.appendbufline(vim.fn.bufnr(), 2, 'import ' .. line)
  else
    vim.fn.appendbufline(vim.fn.bufnr(), 2, '')
    vim.fn.appendbufline(vim.fn.bufnr(), 2, 'import ' .. line)
  end
end

return M
