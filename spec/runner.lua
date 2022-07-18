do
  local paths = {}
  for str in string.gmatch(package.path, "([^;]+)") do table.insert(paths, str) end
  paths[#paths + 1] = "/home/nexela/Media/Develop/Lua/libs/?.lua"
  paths[#paths + 1] = "/home/nexela/Media/Develop/Lua/libs/?/init.lua"
  package.path = table.concat(paths, ";")
end

require("faketorio")

local say = require("say")
local assert = require("luassert") ---@type assert
local function raw_equal(_, arguments)
  if #arguments ~= 2 then
    return false
  end
  return rawequal(arguments[1], arguments[2])
end

say:set("assertion.rawequal.positive", "Expected:\n%s\nto be rawequal to:\n%s")
say:set("assertion.rawequal.negative", "Expected:\n%s\nto not be rawequal to:\n%s")
assert:register("assertion", "rawequal", raw_equal, "assertion.rawequal.positive", "assertion.rawequal.negative")
return require("busted.runner")
