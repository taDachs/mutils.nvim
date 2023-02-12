local util = {}

function util.delay_function_call(f, delay)
  local timer = vim.loop.new_timer()
  timer:start(delay, 0, vim.schedule_wrap(f))
end

function util.strsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end


---------------------------------------------------------------------------------------------------
------------------------------------ FILE STUFF ---------------------------------------------------
---------------------------------------------------------------------------------------------------

-- ignores hidden paths
function util.find_files_in_dir(path, type)
  local find_command = "find " .. path .. " -not -path '*/.*/*'"
  if type == "f" then
    find_command = find_command .. " -type f"
  elseif type == "d" then
    find_command = find_command .. " -type d"
  end
  local files = io.popen(find_command):read('*all')
  files = util.strsplit(files, "\n")
  return files
end

function util.get_basename(path)
  local regex = "^/?.*/(.*)$"
  local basename = string.match(path, regex)
  return basename
end

function util.get_dirname(path)
  local regex = "^(/?.*/).*$"
  local dirname = string.match(path, regex)
  return dirname
end

function util.is_subdir(child, parent)
  child = string.sub(child, 1, #parent)
  return parent == child
end

function util.len(table)
  local len = 0
  for _, _ in pairs(table) do
    len = len + 1
  end
  return len
end

function util.keys(table)
  local keys = {}
  for k, _ in pairs(table) do
    keys[#keys + 1] = k
  end
  return keys
end

function util.map(table, f)
  local mapped = {}
  for k, v in pairs(table) do
    mapped[k] = f(v)
  end
  return mapped
end

-- both must me absolute
function util.relative_path(path, parent)
  local path_split = util.strsplit(path, "/")
  local parent_split = util.strsplit(parent, "/")
  local len_parent = 0
  for i, _ in ipairs(parent_split) do len_parent = i end
  local relative_split = { unpack(path_split, len_parent + 1) }
  return table.concat(relative_split, "/")
end

function util.update_table(a, b)
  for k,v in pairs(b) do
    if type(v) == "table" then
        if type(a[k] or false) == "table" then
            util.update_table(a[k] or {}, b[k] or {})
        else
            a[k] = v
        end
    else
        a[k] = v
    end
  end
  return a
end

return util
