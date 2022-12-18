--- @class stdlib.config
local config = {
  --- @class stdlib.config.errors
  error = {
    ["no_area"] = "require('__stdlib2__/area') before using this function",
    ["called_without_self"] = "called without self as the first argument",

    ["not_position_table"] = "must be a position or vector table",
    ["invalid_values_integers"] = "table must contain integers",
    ["invalid_values_numbers"] = "table must contain numbers",
    ["not_position_class"] = "must be a `MapPosition`, `ChunkPosition`, `TilePosition`, or `PixelPosition`",

    ["not_integers"] = "x, y must be integers",
    ["not_numbers"] = "x, y must be numbers",

    ["no_assigning"] = "cannot assign %s to %s",
    -- ["must_be_pos_table_or_vec"] = "position must be a position or vector table",
    -- ["must_be_map_position"] = "position must be a MapPosition {x = x, y = y}",
  }
}

return config
