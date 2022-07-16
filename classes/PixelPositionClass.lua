---@class PixelPositionClass: PixelPosition
---@class PixelPositionClass: PositionClass
---@field new fun(self: PixelPositionClass, position: AnyPosOrVec): PixelPositionClass
---@field construct fun(self: PixelPositionClass, x: integer, y: integer): PixelPositionClass
local PixelPositionClass = {}
local PositionClass = require("__stdlib2__/classes/PositionClass")

local math_floor = math.floor

-- ============================================================================
do ---@block PixelPosition

  ---@return MapPositionClass
  function PixelPositionClass:to_map_position()
    local map_pos = PositionClass.copy_as(self, PositionClass.Map)
    map_pos.x, map_pos.y = map_pos.x / 32, map_pos.y / 32
    return map_pos
  end

  ---@return ChunkPositionClass
  function PixelPositionClass:to_chunk_position()
    local chunk_pos = PositionClass.copy_as(self, PositionClass.Chunk)
    chunk_pos.x, chunk_pos.y = math_floor(chunk_pos.x / 32 / 32), math_floor(chunk_pos.y / 32 / 32)
    return chunk_pos
  end

  ---@return TilePositionClass
  function PixelPositionClass:to_tile_position()
    local tile_pos = PositionClass.copy_as(self, PositionClass.Tile)
    tile_pos.x, tile_pos.y = math_floor(tile_pos.x / 32), math_floor(tile_pos.y / 32)
    return tile_pos
  end

end
-- ============================================================================
do ---@block Metamethods

  PixelPositionClass.__class = "PixelPositionClass"

  PixelPositionClass.__index = function(self, key)
    return PixelPositionClass[key] or PositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil
  end

  for key, func in pairs(PositionClass) do
    if key:find("^__") and not PixelPositionClass[key] then
      PixelPositionClass[key] = func
    end
  end

end
-- ============================================================================
return PixelPositionClass

---@class PixelPosition
---@field x double
---@field y double
---@field [1] double
---@field [2] double

---@class PixelVector
---@field [1] double
---@field [2] double
