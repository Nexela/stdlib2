---@class PixelPositionClass: PositionClass, PixelPosition.0
---@field new fun(self: PixelPositionClass, position: AnyPosOrVec): PixelPositionClass
---@field construct fun(self: PixelPositionClass, x: integer, y: integer): PixelPositionClass
local PixelPositionClass = {}
PixelPositionClass.Class = PixelPositionClass
PixelPositionClass.__class = "PixelPosition"
local PositionClass = require("__stdlib2__/classes/PositionClass")

local math_floor = math.floor

-- ============================================================================
do ---@block PixelPosition

  ---@return MapPositionClass
  function PixelPositionClass:to_map_position()
    local map_pos = PositionClass.copy_as(self, PositionClass.MapPosition)
    map_pos.x, map_pos.y = map_pos.x / 32, map_pos.y / 32
    return map_pos
  end

  ---@return ChunkPositionClass
  function PixelPositionClass:to_chunk_position()
    local chunk_pos = PositionClass.copy_as(self, PositionClass.ChunkPosition)
    chunk_pos.x, chunk_pos.y = math_floor(chunk_pos.x / 32 / 32), math_floor(chunk_pos.y / 32 / 32)
    return chunk_pos
  end

  ---@return TilePositionClass
  function PixelPositionClass:to_tile_position()
    local tile_pos = PositionClass.copy_as(self, PositionClass.TilePosition)
    tile_pos.x, tile_pos.y = math_floor(tile_pos.x / 32), math_floor(tile_pos.y / 32)
    return tile_pos
  end

end
-- ============================================================================
do ---@block Metamethods


  PixelPositionClass.__index = function(self, key)
    return PixelPositionClass[key] or PositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil
  end

  for key, f in pairs(PositionClass) --[[@as fun():string, function)]]do
    if key:find("^__") and not PixelPositionClass[key] then
      PixelPositionClass[key] = f ---@diagnostic disable-line: no-unknown
    end
  end

end
-- ============================================================================
return PixelPositionClass

---@alias PixelPosition PixelPosition.0|PixelPosition.1
---@class PixelPosition.0
---@field x double
---@field y double
---@class PixelPosition.1
---@field [1] double
---@field [2] double
