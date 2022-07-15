---@class ChunkPositionClass: ChunkPosition
local ChunkPositionClass = {}
local PositionClass = require("__stdlib2__/classes/PositionClass")

-- ============================================================================
do ---@block ChunkPosition

  for key, func in pairs(PositionClass) do
    if key:find("^__") then
      ChunkPositionClass[key] = func
    end
  end
  ChunkPositionClass.__index = function(self, key) return ChunkPositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  ChunkPositionClass.__class = "ChunkPositionClass"

  -- ChunkPositionClass.new = PositionClass.new
  ChunkPositionClass.copy = PositionClass.copy
  ChunkPositionClass.normalize = PositionClass.normalize
  ChunkPositionClass.manhattan_distance = PositionClass.manhattan_distance
  ChunkPositionClass.abs = PositionClass.abs
  ChunkPositionClass.flipy = PositionClass.flipy
  ChunkPositionClass.inside = PositionClass.inside
  ChunkPositionClass.subtract = PositionClass.subtract
  ChunkPositionClass.flip = PositionClass.flip
  ChunkPositionClass.trim = PositionClass.trim
  ChunkPositionClass.as_chunk_position = PositionClass.as_chunk_position
  ChunkPositionClass.swap = PositionClass.swap
  ChunkPositionClass.translate = PositionClass.translate
  ChunkPositionClass.as_pixel_position = PositionClass.as_pixel_position
  ChunkPositionClass.equals = PositionClass.equals
  ChunkPositionClass.to_string_tuple = PositionClass.to_string_tuple
  ChunkPositionClass.to_string_vector = PositionClass.to_string_vector
  ChunkPositionClass.floor = PositionClass.floor
  ChunkPositionClass.round = PositionClass.round
  ChunkPositionClass.to_string = PositionClass.to_string
  ChunkPositionClass.cross = PositionClass.cross
  ChunkPositionClass.ceil = PositionClass.ceil
  ChunkPositionClass.multiply = PositionClass.multiply
  ChunkPositionClass.angle = PositionClass.angle
  ChunkPositionClass.len = PositionClass.len
  ChunkPositionClass.atan2 = PositionClass.atan2
  ChunkPositionClass.distance_squared = PositionClass.distance_squared
  ChunkPositionClass.unpack = PositionClass.unpack
  ChunkPositionClass.center = PositionClass.center
  ChunkPositionClass.pack = PositionClass.pack
  ChunkPositionClass.is_zero = PositionClass.is_zero
  ChunkPositionClass.as_map_position = PositionClass.as_map_position
  ChunkPositionClass.distance = PositionClass.distance
  ChunkPositionClass.direction_to = PositionClass.direction_to
  ChunkPositionClass.update = PositionClass.update
  ChunkPositionClass.orientation_to = PositionClass.orientation_to
  ChunkPositionClass.flipx = PositionClass.flipx
  ChunkPositionClass.divide = PositionClass.divide
  ChunkPositionClass.len_squared = PositionClass.len_squared
  ChunkPositionClass.modulo = PositionClass.modulo
  ChunkPositionClass.as_tile_position = PositionClass.as_tile_position
  ChunkPositionClass.lerp = PositionClass.lerp
  ChunkPositionClass.add = PositionClass.add
  ChunkPositionClass.dot = PositionClass.dot
  ChunkPositionClass.as_tuple = PositionClass.as_tuple
  ChunkPositionClass.as_tuple_any = PositionClass.as_tuple_any

  if __POSITION_DEBUG__ then
    for key in pairs(PositionClass) do
      if not key:find("PositionClass$") and not ChunkPositionClass[key] then
        print("ChunkPositionClass Missing Key: " .. key)
      end
    end
  end

  ---@generic Class: AnyPositionClass
  ---@return Class
  function ChunkPositionClass:map_position()
    self.x, self.y = self.x * 32, self.y * 32
    return self
  end

  ---@generic Class: AnyPositionClass
  ---@return Class
  function ChunkPositionClass:pixel_position()
    self.x, self.y = self.x * 32 * 32, self.y * 32 * 32
    return self
  end

  ChunkPositionClass.tile_position = ChunkPositionClass.map_position

  ---@return MapPositionClass
  function ChunkPositionClass:to_map_position()
    return ChunkPositionClass.map_position(PositionClass.copy(self, PositionClass.MapPositionClass))
  end

  ---@return TilePositionClass
  function ChunkPositionClass:to_tile_position()
    return ChunkPositionClass.tile_position(PositionClass.copy(self, PositionClass.TilePositionClass))
  end

  ---@return PixelPositionClass
  function ChunkPositionClass:to_pixel_position()
    return ChunkPositionClass.pixel_position(PositionClass.copy(self, PositionClass.ChunkPositionClass))
  end

  function ChunkPositionClass:to_chunk_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x * 32, self.y * 32
    local rbx, rby = ltx + 32, lty + 32
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

  function ChunkPositionClass:to_chunk_tile_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x * 32, self.y * 32
    local rbx, rby = ltx + 31, lty + 31
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

end

return ChunkPositionClass

---@class ChunkPositionClass
---@operator call(ChunkPositionClass):ChunkPositionClass
---@operator add (double|AnyPosOrVec):ChunkPositionClass
---@operator unm (ChunkPositionClass):ChunkPositionClass
---@operator mul (double|AnyPosOrVec):ChunkPositionClass
---@operator sub (double|AnyPosOrVec):ChunkPositionClass
---@operator div (double|AnyPosOrVec):ChunkPositionClass
---@operator mod (ChunkPositionClass):ChunkPositionClass

---@class ChunkVector
---@field [1] integer
---@field [2] integer
