---@class ChunkPositionClass: ChunkPosition
---@class ChunkPositionClass: PositionClass
---@field new fun(self: ChunkPositionClass, position: AnyPosOrVec): ChunkPositionClass
---@field construct fun(self: ChunkPositionClass, x: integer, y: integer): ChunkPositionClass
local ChunkPositionClass = {}
local PositionClass = require("__stdlib2__/classes/PositionClass")

-- ============================================================================
do ---@block ChunkPosition

  ---@return MapPositionClass
  function ChunkPositionClass:to_map_position()
    local map_pos = PositionClass.copy_as(self, PositionClass.Map)
    map_pos.x, map_pos.y = map_pos.x * 32, map_pos.y * 32
    return map_pos
  end

  ---@return TilePositionClass
  function ChunkPositionClass:to_tile_position()
    local tile_pos = PositionClass.copy_as(self, PositionClass.Tile)
    tile_pos.x, tile_pos.y = tile_pos.x * 32, tile_pos.y * 32
    return tile_pos
  end

  ---@return PixelPositionClass
  function ChunkPositionClass:to_pixel_position()
    local pixel_pos = PositionClass.copy_as(self, PositionClass.Pixel)
    pixel_pos.x, pixel_pos.y = pixel_pos.x * 32 * 32, pixel_pos.y * 32 * 32
    return pixel_pos
  end

  ---@return AreaClass
  function ChunkPositionClass:to_chunk_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x * 32, self.y * 32
    local rbx, rby = ltx + 32, lty + 32
    return PositionClass.Area:construct(ltx, lty, rbx, rby)
  end

  ---@return AreaClass
  function ChunkPositionClass:to_chunk_tile_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x * 32, self.y * 32
    local rbx, rby = ltx + 31, lty + 31
    return PositionClass.Area:construct(ltx, lty, rbx, rby)
  end

end
-- ============================================================================
do ---@block Metamethods

  ChunkPositionClass.__class = "ChunkPositionClass"

  ChunkPositionClass.__index = function(self, key)
    return ChunkPositionClass[key] or PositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil
  end

  for key, func in pairs(PositionClass) do
    if key:find("^__") and not ChunkPositionClass[key] then
      ChunkPositionClass[key] = func
    end
  end

end
-- ============================================================================
return ChunkPositionClass

---@class ChunkPositionClass
---@operator call(ChunkPositionClass):ChunkPositionClass
---@operator unm (ChunkPositionClass):ChunkPositionClass
---@operator add (integer|AnyPosOrVec):ChunkPositionClass
---@operator mul (integer|AnyPosOrVec):ChunkPositionClass
---@operator sub (integer|AnyPosOrVec):ChunkPositionClass
---@operator div (integer|AnyPosOrVec):ChunkPositionClass
---@operator mod (integer|AnyPosOrVec):ChunkPositionClass

---@class ChunkVector
---@field [1] integer
---@field [2] integer
