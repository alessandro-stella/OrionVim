require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<C-f>", "/", { desc = "Find in document" })

-- Easy exit from terminal mode
map("t", "<esc><esc>", "<c-\\><c-n>")

-- Generate getter and setter for private field of java class
function GenerateJavaGetterSetter()
  local filename = vim.api.nvim_buf_get_name(0)
  if not filename:match "%.java$" then
    print "Only works in Java files"
    return
  end

  local line = vim.api.nvim_get_current_line()

  local type, name = string.match(line, "%s*private%s+([%w<>%[%]]+)%s+([%w_]+)%s*;")
  if not type or not name then
    print "Invalid line: need private field with type and name"
    return
  end

  local capitalizedName = name:sub(1, 1):upper() .. name:sub(2)
  local getterName = "get" .. capitalizedName
  local setterName = "set" .. capitalizedName

  local block = {}
  table.insert(block, "")
  table.insert(block, "public " .. type .. " " .. getterName .. "() {")
  table.insert(block, "    return this." .. name .. ";")
  table.insert(block, "}")
  table.insert(block, "")
  table.insert(block, "public void " .. setterName .. "(" .. type .. " " .. name .. ") {")
  table.insert(block, "    this." .. name .. " = " .. name .. ";")
  table.insert(block, "}")

  local last_line = vim.api.nvim_buf_line_count(0)
  local insert_row = last_line
  for i = last_line, 1, -1 do
    local l = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if l:match "^%s*}%s*$" then
      insert_row = i - 1
      break
    end
  end

  vim.api.nvim_buf_set_lines(0, insert_row, insert_row, false, block)
  print("Getter and setter generated for: " .. name)
end

-- Generate toString() method for classes in java
function GenerateJavaToString()
  local filename = vim.api.nvim_buf_get_name(0)
  if not filename:match "%.java$" then
    print "Only works in Java files"
    return
  end

  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local fields = {}

  for _, line in ipairs(buf_lines) do
    line = line:match "^%s*(.-)%s*$"

    if line:sub(-1) == ";" and not line:find "=" and not line:find "this%." and line ~= "" then
      local words = {}
      for w in line:gmatch "%S+" do
        table.insert(words, w)
      end
      if #words >= 2 then
        local name = words[#words]:gsub(";$", "")
        table.insert(fields, name)
      end
    end
  end

  if #fields == 0 then
    print "No fields found in the class"
    return
  end

  local className = vim.fn.expand("%:t"):gsub("%.java$", "")
  local block = {}
  table.insert(block, "")
  table.insert(block, "@Override")
  table.insert(block, "public String toString() {")

  local str = 'return "' .. className .. '[" + '
  for i, name in ipairs(fields) do
    str = str .. '"' .. name .. '=" + ' .. name
    if i < #fields then
      str = str .. ' + ", " + '
    end
  end
  str = str .. ' + "]";'
  table.insert(block, "    " .. str)
  table.insert(block, "}")

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, block)
  print "toString() generated for all fields"
end

-- Generate constructor for java class
function GenerateJavaConstructor()
  local filename = vim.api.nvim_buf_get_name(0)
  if not filename:match "%.java$" then
    print "Only works in Java files"
    return
  end

  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local fields = {}

  for _, line in ipairs(buf_lines) do
    line = line:match "^%s*(.-)%s*$"
    if line:find "%a" then
      if
        line:sub(-1) == ";"
        and not line:find "="
        and not line:find "this%."
        and not line:find "%("
        and not line:find "{"
      then
        local words = {}
        for w in line:gmatch "%S+" do
          table.insert(words, w)
        end
        if #words >= 2 then
          local type_name = words[#words - 1]
          local var_name = words[#words]:gsub(";$", "")
          table.insert(fields, { type = type_name, name = var_name })
        end
      end
    end
  end

  if #fields == 0 then
    print "No fields found in the class"
    return
  end

  print "Fields found:"
  for _, f in ipairs(fields) do
    print(f.type .. " " .. f.name)
  end

  local confirm = vim.fn.input "Insert constructor? (y/n): "
  if confirm:lower() ~= "y" then
    print "\nConstructor generation cancelled"
    return
  end

  local className = vim.fn.expand("%:t"):gsub("%.java$", "")
  local block = {}
  table.insert(block, "")
  table.insert(block, "public " .. className .. "(")

  local params = {}
  for _, field in ipairs(fields) do
    table.insert(params, field.type .. " " .. field.name)
  end
  table.insert(block, "    " .. table.concat(params, ", "))
  table.insert(block, ") {")

  for _, field in ipairs(fields) do
    table.insert(block, "    this." .. field.name .. " = " .. field.name .. ";")
  end

  table.insert(block, "}")

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, block)
  print "\nConstructor generated for all fields"
end

-- Registering commands to get suggestions
local wk = require "which-key"

wk.add {
  { "<leader>j" },
  { "<leader>jc", ":lua GenerateJavaConstructor()<CR>", desc = "Generate constructor", mode = "n" },
  { "<leader>js", ":lua GenerateJavaGetterSetter()<CR>", desc = "Generate getter and setter", mode = "n" },
  { "<leader>jt", ":lua GenerateJavaToString()<CR>", desc = "Generate toString()", mode = "n" },
}
