---@class PositionClass
---@operator call (AnyPosOrVec):MapPositionClass
---@field Area AreaClass?
local PositionClass = {}

---@class Position
local Position = {}
local PositionMeta = {}

---@class MapPositionClass: MapPosition
local MapPosition = {}
local MapPositionMeta = { __class = MapPosition }

---@class ChunkPositionClass: ChunkPosition
local ChunkPosition = {}
local ChunkPositionMeta = { __class = ChunkPosition }

---@class TilePositionClass: TilePosition
local TilePosition = {}
local TilePositionMeta = { __class = TilePosition }

---@class PixelPositionClass: PixelPosition
local PixelPosition = {}
local PixelPositionMeta = { __class = PixelPosition }

local Direction = require("__stdlib2__/direction")
local math = require("__stdlib2__/math") --[[@as mathlibext]]

local floor, ceil, round, abs = math.floored, math.ceiled, math.round, math.abs
local atan2, deg, acos, sqrt = math.atan2, math.deg, math.acos, math.sqrt
local concat = table.concat
local setmetatable = setmetatable
local pi = math.pi
local directions = defines.direction

-- ============================================================================

---@param pos AnyPosOrVec|double
---@return double, double
---@nodiscard
local function as_tuple_any(pos)
  return pos.x or pos[1] or pos, pos.y or pos[2] or pos
end

---@param pos AnyPosOrVec
---@return double, double
---@nodiscard
local function as_tuple(pos)
  return pos.x or pos[1], pos.y or pos[2]
end

-- ============================================================================

---@generic Position: MapPosition|ChunkPositionClass|TilePositionClass|PixelPositionClass
---@param x double
---@param y double
---@param metatable? table
---@return Position
---@nodiscard
local function new(x, y, metatable)
  assert(x and y)
  return setmetatable({ x = x, y = y }, metatable or MapPositionMeta)
end

---@generic Position: MapPosition|ChunkPositionClass|TilePositionClass|PixelPositionClass
---@param x double
---@param y double
---@param metatable? table
---@return Position
---@nodiscard
local function new_safe(x, y, metatable)
  return setmetatable({ x = x, y = y }, metatable or MapPositionMeta)
end

-- =============================================================================
do ---@block Position
  do ---@block Constructors

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@param metatable? PositionMetatable
    ---@return Position
    ---@nodiscard
    function Position:copy(metatable)
      ---@diagnostic disable-next-line: undefined-field
      return setmetatable({ x = self.x, y = self.y }, metatable or getmetatable(self))
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Methods

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@param x? double
    ---@param y? double
    ---@return Position
    function Position:update(x, y)
      self.x, self.y = x or self.x, y or self.y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:normalize()
      self.x, self.y = (self.x * 0.00390625) / 0.00390625, (self.y * 0.00390625) / 0.00390625
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:floor(divisor)
      self.x, self.y = floor(self.x, divisor), floor(self.y, divisor)
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:ceil(divisor)
      self.x, self.y = ceil(self.x, divisor), ceil(self.y, divisor)
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:round(divisor)
      self.x, self.y = round(self.x, divisor), round(self.y, divisor)
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:abs()
      self.x, self.y = abs(self.x), abs(self.y)
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param other AnyPosOrVec
    function Position:add(other)
      local other_x, other_y = as_tuple(other)
      self.x, self.y = self.x + other_x, self.y + other_y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param other AnyPosOrVec
    function Position:subtract(other)
      local other_x, other_y = as_tuple(other)
      self.x, self.y = self.x - other_x, self.y - other_y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param other AnyPosOrVec
    function Position:multiply(other)
      local other_x, other_y = as_tuple(other)
      self.x, self.y = self.x * other_x, self.y * other_y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param other AnyPosOrVec
    function Position:divide(other)
      local other_x, other_y = as_tuple(other)
      self.x, self.y = self.x / other_x, self.y / other_y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param other AnyPosOrVec
    function Position:modulo(other)
      local other_x, other_y = as_tuple(other)
      self.x, self.y = self.x % other_x, self.y % other_y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:center()
      local ceil_x = ceil(self.x)
      local ceil_y = ceil(self.y)
      self.x = self.x >= 0 and floor(self.x) + 0.5 or (ceil_x == self.x and ceil_x + 0.5 or ceil_x - 0.5)
      self.y = self.y >= 0 and floor(self.y) + 0.5 or (ceil_y == self.y and ceil_y + 0.5 or ceil_y - 0.5)
      return self
    end

    --- Swap the x and y coordinates.
    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:swap()
      local x, y = self.y, self.x
      self.x, self.y = x, y
      return self
    end

    --- Flip the signs of the position.
    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:flip()
      self.x, self.y = -self.x, -self.y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:flipx()
      self.x = -self.x
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    function Position:flipy()
      self.y = -self.y
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---Trim the position to a length.
    ---@param max_length double
    function Position:trim(max_length)
      local s = max_length * max_length / (self.x * self.x + self.y * self.y)
      s = (s > 1 and 1) or sqrt(s)
      self.x, self.y = self.x * s, self.y * s
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param other AnyPosOrVec
    ---@param alpha float
    function Position:lerp(other, alpha)
      local other_x, other_y = as_tuple(other)
      self.x = self.x + (other_x - self.x) * alpha
      self.y = self.y + (other_y - self.y) * alpha
      return self
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return Position
    ---@param dir defines.direction
    ---@param distance double
    function Position:translate(dir, distance)
      return Position.add(self, Direction.to_vector(dir, distance))
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Position Class Mutates

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return MapPositionClass
    function Position:as_map_position()
      return setmetatable(self, MapPositionMeta)
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return ChunkPositionClass
    function Position:as_chunk_position()
      return setmetatable(self, ChunkPositionMeta)
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return PixelPositionClass
    function Position:as_pixel_position()
      return setmetatable(self, PixelPositionMeta)
    end

    ---@generic Position: AnyPositionClass
    ---@param self Position
    ---@return TilePositionClass
    function Position:as_tile_position()
      return setmetatable(self, TilePositionMeta)
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Numbers

    ---Gets the squared length of a position
    function Position:len_squared()
      return self.x * self.x + self.y * self.y
    end

    ---Gets the length of a position
    function Position:len()
      return (self.x * self.x + self.y * self.y) ^ 0.5
    end

    ---Return the cross product of two positions.
    function Position:cross(other)
      local other_x, other_y = as_tuple(other)
      return self.x * other_y - self.y * other_x
    end

    ---Return the dot product of two positions.
    function Position:dot(other)
      local other_x, other_y = as_tuple(other)
      return self.x * other_x + self.y * other_y
    end

    ---@return defines.direction
    function Position:direction_to(other)
      local other_x, other_y = as_tuple(other)
      local dx = self.x - other_x
      local dy = self.y - other_y
      if dx == 0 then return dy > 0 and directions.north or directions.south end
      if dy == 0 then return dx > 0 and directions.west or directions.east end

      local adx, ady = abs(dx), abs(dy)
      if adx > ady then return dx > 0 and directions.north or directions.south end
      return dy > 0 and directions.west or directions.east
    end

    ---@return RealOrientation
    ---@param other AnyPosOrVec
    function Position:orientation_to(other)
      return (1 - (self:atan2(other) / pi)) / 2
    end

    ---Calculates the Euclidean distance between two positions.
    ---@param other AnyPosOrVec
    function Position:distance(other)
      local other_x, other_y = as_tuple(other)
      local ax_bx = self.x - other_x
      local ay_by = self.y - other_y
      return (ax_bx * ax_bx + ay_by * ay_by) ^ 0.5
    end

    ---Calculates the Euclidean distance squared between two positions, useful when sqrt is not needed.
    ---@param other AnyPosOrVec
    function Position:distance_squared(other)
      local other_x, other_y = as_tuple(other)
      local ax_bx = self.x - other_x
      local ay_by = self.y - other_y
      return ax_bx * ax_bx + ay_by * ay_by
    end

    ---Calculates the manhatten distance between two positions.
    -- @see https://en.wikipedia.org/wiki/Taxicab_geometry Taxicab geometry (manhatten distance)
    ---@param other AnyPosOrVec
    function Position:manhattan_distance(other)
      local other_x, other_y = as_tuple(other)
      return abs(other_x - self.x) + abs(other_y - self.y)
    end

    ---@param other AnyPosOrVec
    function Position:atan2(other)
      local other_x, other_y = as_tuple(other)
      return atan2(other_x - self.x, other_y - self.y)
    end

    ---@param other AnyPosOrVec
    function Position:angle(other)
      local dist = self:distance(other)
      local other_x, other_y = as_tuple(other)
      return dist ~= 0 and deg(acos((self.x * other_x + self.y * other_y) / dist)) or 0
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Booleans

    function Position:inside(area)
      local lt = area.left_top
      local rb = area.right_bottom
      return self.x >= lt.x and self.y >= lt.y and self.x <= rb.x and self.y <= rb.y
    end

    function Position:is_Zero() return self.x == 0 and self.y == 0 end

    ---@param other AnyPosOrVec
    function Position:equals(other)
      local other_x, other_y = as_tuple(other)
      return self.x == other_x and self.y == other_y
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Other

    ---@return MapVector
    function Position:pack()
      return { self.x, self.y }
    end

    function Position:unpack()
      return self.x, self.y
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Strings

    ---@param surface_name? string
    function Position:to_gps_tag(surface_name)
      return concat { "[gps=", self.x, ",", self.y, surface_name and ("," .. surface_name) or "", "]" }
    end

    ---@param precision? float
    function Position:to_string(precision)
      local f = precision and ("%" .. precision .. "f") or "%s"
      local tab = { "{ x = ", f, ", y = ", f, " }" }
      return concat(tab):format(self.x, self.y)
    end

    ---@param precision? float
    function Position:to_string_vector(precision)
      local f = precision and ("%" .. precision .. "f") or "%s"
      local tab = { "{ ", f, ", ", f, " }" }
      return concat(tab):format(self.x, self.y)
    end

    ---@param precision? float
    function Position:to_string_tuple(precision)
      local f = precision and ("%" .. precision .. "f") or "%s"
      local tab = { f, f }
      return concat(tab, ", "):format(self.x, self.y)
    end

  end
end
-- ============================================================================
do ---@block MapPosition

  MapPosition.copy = Position.copy
  MapPosition.normalize = Position.normalize
  MapPosition.manhattan_distance = Position.manhattan_distance
  MapPosition.abs = Position.abs
  MapPosition.flipy = Position.flipy
  MapPosition.inside = Position.inside
  MapPosition.subtract = Position.subtract
  MapPosition.flip = Position.flip
  MapPosition.trim = Position.trim
  MapPosition.as_chunk_position = Position.as_chunk_position
  MapPosition.swap = Position.swap
  MapPosition.translate = Position.translate
  MapPosition.as_pixel_position = Position.as_pixel_position
  MapPosition.equals = Position.equals
  MapPosition.to_string_tuple = Position.to_string_tuple
  MapPosition.to_string_vector = Position.to_string_vector
  MapPosition.floor = Position.floor
  MapPosition.round = Position.round
  MapPosition.to_string = Position.to_string
  MapPosition.cross = Position.cross
  MapPosition.ceil = Position.ceil
  MapPosition.multiply = Position.multiply
  MapPosition.angle = Position.angle
  MapPosition.len = Position.len
  MapPosition.atan2 = Position.atan2
  MapPosition.distance_squared = Position.distance_squared
  MapPosition.to_gps_tag = Position.to_gps_tag
  MapPosition.unpack = Position.unpack
  MapPosition.center = Position.center
  MapPosition.pack = Position.pack
  MapPosition.is_Zero = Position.is_Zero
  MapPosition.as_map_position = Position.as_map_position
  MapPosition.distance = Position.distance
  MapPosition.direction_to = Position.direction_to
  MapPosition.update = Position.update
  MapPosition.orientation_to = Position.orientation_to
  MapPosition.flipx = Position.flipx
  MapPosition.divide = Position.divide
  MapPosition.len_squared = Position.len_squared
  MapPosition.modulo = Position.modulo
  MapPosition.as_tile_position = Position.as_tile_position
  MapPosition.lerp = Position.lerp
  MapPosition.add = Position.add
  MapPosition.dot = Position.dot


  function MapPosition:chunk_position()
    self.x, self.y = floor(self.x / 32), floor(self.y / 32)
    return self
  end

  function MapPosition:pixel_position()
    self.x, self.y = self.x * 32, self.y * 32
    return self
  end

  MapPosition.tile_position = MapPosition.floor

  ---@return ChunkPositionClass
  function MapPosition:to_chunk_position()
    return MapPosition.chunk_position(Position.copy(self, ChunkPositionMeta)) --[[@as ChunkPositionClass]]
  end

  ---@return TilePositionClass
  function MapPosition:to_tile_position()
    return MapPosition.tile_position(Position.copy(self, TilePositionMeta)) --[[@as TilePositionClass]]
  end

  ---@return PixelPositionClass
  function MapPosition:to_pixel_position()
    return MapPosition.pixel_position(Position.copy(self, PixelPositionMeta)) --[[@as PixelPositionClass]]
  end

  ---Expands from the center outwards towards the vector
  ---@param vector? AnyPosOrVec|number
  function MapPosition:to_area(vector)
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    return PositionClass.Area.from_position(self, vector)
  end

  ---Expands from the position outwards towards the vector
  ---@param vector? AnyPosOrVec|number
  function MapPosition:to_area_left_top(vector)
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    return PositionClass.Area.from_left_top(self, vector)
  end

  --- Turn a position into a chunks area
  function MapPosition:to_chunk_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x, self.y
    ltx, lty = ltx - ltx % 32, lty - lty % 32
    local rbx, rby = ltx + 32, lty + 32
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

  function MapPosition:to_chunk_tile_area()
    if not PositionClass.Area then error("'Area' must be required before 'PositionClass'") end
    local ltx, lty = self.x, self.y
    ltx, lty = ltx - ltx % 32, lty - lty % 32
    local rbx, rby = ltx + 31, lty + 31
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

end
-- ============================================================================
do ---@block ChunkPosition

  ChunkPosition.copy = Position.copy
  ChunkPosition.normalize = Position.normalize
  ChunkPosition.manhattan_distance = Position.manhattan_distance
  ChunkPosition.abs = Position.abs
  ChunkPosition.flipy = Position.flipy
  ChunkPosition.inside = Position.inside
  ChunkPosition.subtract = Position.subtract
  ChunkPosition.flip = Position.flip
  ChunkPosition.trim = Position.trim
  ChunkPosition.as_chunk_position = Position.as_chunk_position
  ChunkPosition.swap = Position.swap
  ChunkPosition.translate = Position.translate
  ChunkPosition.as_pixel_position = Position.as_pixel_position
  ChunkPosition.equals = Position.equals
  ChunkPosition.to_string_tuple = Position.to_string_tuple
  ChunkPosition.to_string_vector = Position.to_string_vector
  ChunkPosition.floor = Position.floor
  ChunkPosition.round = Position.round
  ChunkPosition.to_string = Position.to_string
  ChunkPosition.cross = Position.cross
  ChunkPosition.ceil = Position.ceil
  ChunkPosition.multiply = Position.multiply
  ChunkPosition.angle = Position.angle
  ChunkPosition.len = Position.len
  ChunkPosition.atan2 = Position.atan2
  ChunkPosition.distance_squared = Position.distance_squared
  ChunkPosition.to_gps_tag = Position.to_gps_tag
  ChunkPosition.unpack = Position.unpack
  ChunkPosition.center = Position.center
  ChunkPosition.pack = Position.pack
  ChunkPosition.is_Zero = Position.is_Zero
  ChunkPosition.as_map_position = Position.as_map_position
  ChunkPosition.distance = Position.distance
  ChunkPosition.direction_to = Position.direction_to
  ChunkPosition.update = Position.update
  ChunkPosition.orientation_to = Position.orientation_to
  ChunkPosition.flipx = Position.flipx
  ChunkPosition.divide = Position.divide
  ChunkPosition.len_squared = Position.len_squared
  ChunkPosition.modulo = Position.modulo
  ChunkPosition.as_tile_position = Position.as_tile_position
  ChunkPosition.lerp = Position.lerp
  ChunkPosition.add = Position.add
  ChunkPosition.dot = Position.dot

  function ChunkPosition:map_position()
    self.x, self.y = self.x * 32, self.y * 32
    return self
  end

  ChunkPosition.tile_position = ChunkPosition.map_position

  function ChunkPosition:pixel_position()
    self.x, self.y = self.x * 32 * 32, self.y * 32 * 32
    return self
  end

  ChunkPosition.tile_position = ChunkPosition.floor

  ---@return MapPositionClass
  function ChunkPosition:to_map_position()
    return ChunkPosition.map_position(Position.copy(self, MapPositionMeta)) --[[@as MapPositionClass]]
  end

  ---@return TilePositionClass
  function ChunkPosition:to_tile_position()
    return ChunkPosition.tile_position(Position.copy(self, TilePositionMeta)) --[[@as TilePositionClass]]
  end

  ---@return PixelPositionClass
  function ChunkPosition:to_pixel_position()
    return ChunkPosition.pixel_position(Position.copy(self, PixelPositionMeta)) --[[@as PixelPositionClass]]
  end

  function ChunkPosition:to_chunk_area()
    local ltx, lty = self.x * 32, self.y * 32
    local rbx, rby = ltx + 32, lty + 32
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

  function ChunkPosition:to_chunk_tile_area()
    local ltx, lty = self.x * 32, self.y * 32
    local rbx, rby = ltx + 31, lty + 31
    return PositionClass.Area.construct(ltx, lty, rbx, rby)
  end

end
-- ============================================================================
do ---@block Metatamethods

  PositionMeta.__call = function(self) return Position.copy(self) end
  PositionMeta.__tostring = Position.to_string
  PositionMeta.__concat = function(self, other) return tostring(self) .. tostring(other) end
  PositionMeta.__eq = function(self, other) return self.x == other.x and self.y == other.y end
  PositionMeta.__unm = Position.flip
  PositionMeta.__newindex = function(self, key, value)
    if key == 1 then rawset(self, "x", value)
    elseif key == 2 then rawset(self, "y", value)
    else error("Invalid key: " .. tostring(key)) end
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionMeta.__add = function(self, other)
    local self_x, self_y = as_tuple_any(self)
    local other_x, other_y = as_tuple_any(other)
    return new(self_x + other_x, self_y + other_y)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionMeta.__sub = function(self, other)
    local self_x, self_y = as_tuple_any(self)
    local other_x, other_y = as_tuple_any(other)
    return new(self_x - other_x, self_y - other_y)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionMeta.__mul = function(self, other)
    local self_x, self_y = as_tuple_any(self)
    local other_x, other_y = as_tuple_any(other)
    return new(self_x * other_x, self_y * other_y)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionMeta.__div = function(self, other)
    local self_x, self_y = as_tuple_any(self)
    local other_x, other_y = as_tuple_any(other)
    return new(self_x / other_x, self_y / other_y)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionMeta.__mod = function(self, other)
    local self_x, self_y = as_tuple_any(self)
    local other_x, other_y = as_tuple_any(other)
    return new(self_x % other_x, self_y % other_y)
  end

  for key, func in pairs(PositionMeta) do
    MapPositionMeta[key] = func
    ChunkPositionMeta[key] = func
    TilePositionMeta[key] = func
    PixelPositionMeta[key] = func
  end

  MapPositionMeta.__index = function(self, key) return MapPosition[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  ChunkPositionMeta.__index = function(self, key) return ChunkPosition[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  TilePositionMeta.__index = function(self, key) return TilePosition[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  PixelPositionMeta.__index = function(self, key) return PixelPosition[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end

end
-- ============================================================================
do ---@block PositionClass Constructors

  ---@param position? AnyPosOrVec
  ---@return MapPositionClass
  PositionClass.new = function(position)
    if not position then return PositionClass.zero() end
    assert(type(position) == "table", "PositionClass.new: position must be a table")
    return new(position.x or position[1], position.y or position[2])
  end

  ---@param x double
  ---@param y double
  ---@return MapPositionClass
  PositionClass.construct = function(x, y)
    return new(x, y)
  end

  ---@param x double
  ---@param y double
  ---@return MapPositionClass
  PositionClass.construct_safe = function(x, y)
    return new_safe(x, y)
  end

  ---@param position AnyPositionClass
  ---@return MapPositionClass
  PositionClass.copy = function(position)
    return new_safe(position.x, position.y)
  end

  ---@return MapPositionClass
  PositionClass.zero = function()
    return new_safe(0, 0)
  end

  PositionClass.as_tuple = as_tuple
  PositionClass.as_tuple_any = as_tuple_any

  ---@param position AnyPosition
  ---@return MapPositionClass
  PositionClass.load = function(position)
    return setmetatable(position, MapPositionMeta) --[[@as MapPositionClass]]
  end

  ---@param position AnyPosition
  local __call = function(_, position)
    return PositionClass.load(position)
  end

  setmetatable(PositionClass, { __call = __call })

end
-- ============================================================================

return PositionClass

---@alias AnyPositionClass MapPositionClass|ChunkPositionClass|TilePositionClass|PixelPositionClass
---@alias AnyPosition AnyPositionClass|MapPosition|ChunkPosition|TilePosition|PixelPosition
---@alias AnyVector MapVector|ChunkVector|TileVector|PixelVector
---@alias AnyPosOrVec AnyPosition|AnyVector
---@alias PositionMetatable `MapPositionMeta`|`ChunkPositionMeta`|`TilePositionMeta`|`PixelPositionMeta`

---@class MapPositionClass
---@operator call(MapPositionClass):MapPositionClass
---@operator add (double|AnyPosOrVec):MapPositionClass
---@operator unm (MapPositionClass):MapPositionClass
---@operator mul (double|AnyPosOrVec):MapPositionClass
---@operator sub (double|AnyPosOrVec):MapPositionClass
---@operator div (double|AnyPosOrVec):MapPositionClass
---@operator mod (MapPositionClass):MapPositionClass

---@class PixelPosition
---@field x double
---@field y double
---@field [1] double
---@field [2] double

---@class MapVector
---@field [1] double
---@field [2] double

---@class ChunkVector
---@field [1] integer
---@field [2] integer

---@class TileVector
---@field [1] integer
---@field [2] integer

---@class PixelVector
---@field [1] double
---@field [2] double
