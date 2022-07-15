---@class MapPositionClass: MapPosition
local MapPositionClass = {}
local PositionClass = require("__stdlib2__/classes/PositionClass")

local math_floor = math.floor

-- ============================================================================
do ---@block MapPosition

  for key, func in pairs(PositionClass) do
    if key:find("^__") then
      MapPositionClass[key] = func
    end
  end
  MapPositionClass.__index = function(self, key) return MapPositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  MapPositionClass.__class = "MapPositionClass"

  -- MapPositionClass.new = PositionClass.new
  MapPositionClass.copy = PositionClass.copy
  MapPositionClass.normalize = PositionClass.normalize
  MapPositionClass.manhattan_distance = PositionClass.manhattan_distance
  MapPositionClass.abs = PositionClass.abs
  MapPositionClass.flipy = PositionClass.flipy
  MapPositionClass.inside = PositionClass.inside
  MapPositionClass.subtract = PositionClass.subtract
  MapPositionClass.flip = PositionClass.flip
  MapPositionClass.trim = PositionClass.trim
  MapPositionClass.as_chunk_position = PositionClass.as_chunk_position
  MapPositionClass.swap = PositionClass.swap
  MapPositionClass.translate = PositionClass.translate
  MapPositionClass.as_pixel_position = PositionClass.as_pixel_position
  MapPositionClass.equals = PositionClass.equals
  MapPositionClass.to_string_tuple = PositionClass.to_string_tuple
  MapPositionClass.to_string_vector = PositionClass.to_string_vector
  MapPositionClass.floor = PositionClass.floor
  MapPositionClass.round = PositionClass.round
  MapPositionClass.to_string = PositionClass.to_string
  MapPositionClass.cross = PositionClass.cross
  MapPositionClass.ceil = PositionClass.ceil
  MapPositionClass.multiply = PositionClass.multiply
  MapPositionClass.angle = PositionClass.angle
  MapPositionClass.len = PositionClass.len
  MapPositionClass.atan2 = PositionClass.atan2
  MapPositionClass.distance_squared = PositionClass.distance_squared
  MapPositionClass.to_gps_tag = PositionClass.to_gps_tag
  MapPositionClass.unpack = PositionClass.unpack
  MapPositionClass.center = PositionClass.center
  MapPositionClass.pack = PositionClass.pack
  MapPositionClass.is_zero = PositionClass.is_zero
  MapPositionClass.as_map_position = PositionClass.as_map_position
  MapPositionClass.distance = PositionClass.distance
  MapPositionClass.direction_to = PositionClass.direction_to
  MapPositionClass.update = PositionClass.update
  MapPositionClass.orientation_to = PositionClass.orientation_to
  MapPositionClass.flipx = PositionClass.flipx
  MapPositionClass.divide = PositionClass.divide
  MapPositionClass.len_squared = PositionClass.len_squared
  MapPositionClass.modulo = PositionClass.modulo
  MapPositionClass.as_tile_position = PositionClass.as_tile_position
  MapPositionClass.lerp = PositionClass.lerp
  MapPositionClass.add = PositionClass.add
  MapPositionClass.dot = PositionClass.dot
  MapPositionClass.as_tuple = PositionClass.as_tuple
  MapPositionClass.as_tuple_any = PositionClass.as_tuple_any

  if __POSITION_DEBUG__ then
    for key in pairs(PositionClass) do
      if not key:find("PositionClass$") and not MapPositionClass[key] then
        print("MapPositionClass Missing Key: " .. key)
      end
    end
  end

  ---@generic Class: AnyPositionClass
  ---@return Class
  function MapPositionClass:chunk_position()
    self.x, self.y = math_floor(self.x / 32), math_floor(self.y / 32)
    return self
  end

  ---@generic Class: AnyPositionClass
  ---@return Class
  function MapPositionClass:pixel_position()
    self.x, self.y = self.x * 32, self.y * 32
    return self
  end

  ---@generic Class: AnyPositionClass
  ---@return Class
  function MapPositionClass:tile_position()
    self.x, self.y = math_floor(self.x), math_floor(self.y)
    return self
  end

  ---@return ChunkPositionClass
  function MapPositionClass:to_chunk_position()
    return MapPositionClass.chunk_position(PositionClass.copy(self, PositionClass.ChunkPositionClass))
  end

  ---@return TilePositionClass
  function MapPositionClass:to_tile_position()
    return MapPositionClass.tile_position(PositionClass.copy(self, PositionClass.TilePositionClass))
  end

  ---@return PixelPositionClass
  function MapPositionClass:to_pixel_position()
    return MapPositionClass.pixel_position(PositionClass.copy(self, PositionClass.PixelPositionClass))
  end

  ---Expands from the center outwards towards the vector
  ---@param vector? AnyPosOrVec|number
  function MapPositionClass:to_area(vector)
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    return PositionClass.Area.from_position(self, vector)
  end

  ---Expands from the position outwards towards the vector
  ---@param vector? AnyPosOrVec|number
  function MapPositionClass:to_area_left_top(vector)
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    return PositionClass.Area.from_left_top(self, vector)
  end

  --- Turn a position into a chunks area
  function MapPositionClass:to_chunk_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x, self.y
    ltx, lty = ltx - ltx % 32, lty - lty % 32
    local rbx, rby = ltx + 32, lty + 32
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

  function MapPositionClass:to_chunk_tile_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x, self.y
    ltx, lty = ltx - ltx % 32, lty - lty % 32
    local rbx, rby = ltx + 31, lty + 31
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

end

return MapPositionClass

---@class MapPositionClass
---@operator call(MapPositionClass):MapPositionClass
---@operator add (double|AnyPosOrVec):MapPositionClass
---@operator unm (MapPositionClass):MapPositionClass
---@operator mul (double|AnyPosOrVec):MapPositionClass
---@operator sub (double|AnyPosOrVec):MapPositionClass
---@operator div (double|AnyPosOrVec):MapPositionClass
---@operator mod (MapPositionClass):MapPositionClass

---@class MapVector
---@field [1] double
---@field [2] double
