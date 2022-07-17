---@class stdlib.config
local config = {
  ---@class stdlib.config.errors
  error = {
    ["no_area"] = "require('__stdlib2__/area') before using this function",
    ["must_be_pos_table_or_vec"] = "position must be a position or vector table",
    ["params_must_be_ints"] = "x, y must be integers",
    ["no_assigning"] = "cannot assign %s to %s"
  }
}

return config
