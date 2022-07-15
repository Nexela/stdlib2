---@class TilePositionClass: TilePosition
---@class TilePositionClass: PositionClass
local TilePositionClass = {}
local PositionClass = require("__stdlib2__/classes/PositionClass")

-- ============================================================================
do ---@block TilePosition

  ---@return MapPositionClass
  function TilePositionClass:to_map_position()
    return PositionClass.copy_as(self, PositionClass.Map)
  end

  ---@return ChunkPositionClass
  function TilePositionClass:to_chunk_position()
    local chunk_pos = PositionClass.copy_as(self, PositionClass.Chunk)
    chunk_pos.x, chunk_pos.y = chunk_pos.x / 32, chunk_pos.y / 32
    return chunk_pos
  end

  ---@return PixelPositionClass
  function TilePositionClass:to_pixel_position()
    local pixel_pos = PositionClass.copy_as(self, PositionClass.Pixel)
    pixel_pos.x, pixel_pos.y = pixel_pos.x * 32, pixel_pos.y * 32
    return pixel_pos
  end

end
-- ============================================================================
do ---@block Metamethods

  TilePositionClass.__class = "TilePositionClass"

  TilePositionClass.__index = function(self, key)
    return TilePositionClass[key] or PositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil
  end

  for key, func in pairs(PositionClass) do
    if key:find("^__") and not TilePositionClass[key] then
      TilePositionClass[key] = func
    end
  end

end
-- ============================================================================
return TilePositionClass

---@class TileVector
---@field [1] integer
---@field [2] integer
