local M = {}

function M.split(inputstr, delimiter)
  if delimiter == nil then
    delimiter = "%s"
  end

  local t={}

  for str in string.gmatch(inputstr, "([^"..delimiter.."]+)") do
    table.insert(t, str)
  end

  return t
end

function M.startswith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

function M.has_value(table, val)
    for _, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

function M.build_importline(package_line, classname)
  local removedPackage = string.gsub(package_line, "package ", "")
  local removedSemicolon = string.gsub(removedPackage, ";", "")

  return removedSemicolon .. "." .. classname .. ";"
end

return M
