---@class PositionClass
---@field private Map MapPositionClass
---@field private Chunk ChunkPositionClass
---@field private Tile TilePositionClass
---@field private Pixel PixelPositionClass
---@field private Area Area?
local PositionClass = {}

local Direction = require("__stdlib2__/direction")
local math = require("__stdlib2__/math") --[[@as mathlibext]]

local floor, ceil, round, abs = math.floored, math.ceiled, math.round, math.abs
local math_floor = math.floor
local atan2, deg, acos, sqrt = math.atan2, math.deg, math.acos, math.sqrt
local concat = table.concat
local setmetatable = setmetatable
local type = type
local pi = math.pi
local directions = defines.direction

-- =============================================================================
do ---@block Position
  do ---@block Constructors

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@param position AnyPosOrVec
    ---@param class Class
    ---@return Class
    ---@nodiscard
    function PositionClass:new(position, class)
      assert(type(position) == "table" and position.x or position[1], "PositionClass:new: position must be a Position")
      class = class or getmetatable(self)
      if class == PositionClass.Chunk or class == PositionClass.Tile then
        assert(math_floor(position.x) == position.x and math_floor(position.y) == position.y, "PositionClass.construct: x and y must be integers")
      end
      return setmetatable({ x = position.x or position[1], y = position.y or position[2] }, class)
    end

    ---@todo Needs overload generic support
    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@param x number
    ---@param y number
    ---@param class Class
    ---@return Class
    ---@nodiscard
    function PositionClass:construct(x, y, class)
      assert(x and y, "PositionClass.construct: x and y must be numbers")
      class = class or getmetatable(self)
      if class == PositionClass.Chunk or class == PositionClass.Tile then
        assert(math_floor(x) == x and math_floor(y) == y, "PositionClass.construct: x and y must be integers")
      end
      return setmetatable({ x = x, y = y }, class )
    end

    ---@todo Needs overload generic support
    ---@generic Class: AnyPositionClass
    ---@return Class
    ---@nodiscard
    function PositionClass:copy()
      return setmetatable({ x = self.x, y = self.y }, getmetatable(self))
    end

    ---@generic Class: AnyPositionClass
    ---@param class Class
    ---@return Class
    function PositionClass:copy_as(class)
      return setmetatable({ x = self.x, y = self.y }, class)
    end

  end
  do ---@block Methods

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@param x? number
    ---@param y? number
    ---@return Class
    function PositionClass:update(x, y)
      self.x, self.y = x or self.x, y or self.y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:normalize()
      self.x, self.y = (self.x * 0.00390625) / 0.00390625, (self.y * 0.00390625) / 0.00390625
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:floor(divisor)
      self.x, self.y = floor(self.x, divisor), floor(self.y, divisor)
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:ceil(divisor)
      self.x, self.y = ceil(self.x, divisor), ceil(self.y, divisor)
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:round(divisor)
      self.x, self.y = round(self.x, divisor), round(self.y, divisor)
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:abs()
      self.x, self.y = abs(self.x), abs(self.y)
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    ---@param other AnyPosOrVec
    function PositionClass:add(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      self.x, self.y = self.x + other_x, self.y + other_y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    ---@param other AnyPosOrVec
    function PositionClass:subtract(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      self.x, self.y = self.x - other_x, self.y - other_y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    ---@param other AnyPosOrVec
    function PositionClass:multiply(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      self.x, self.y = self.x * other_x, self.y * other_y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    ---@param other AnyPosOrVec
    function PositionClass:divide(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      self.x, self.y = self.x / other_x, self.y / other_y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    ---@param other AnyPosOrVec
    function PositionClass:modulo(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      self.x, self.y = self.x % other_x, self.y % other_y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:center()
      local ceil_x = ceil(self.x)
      local ceil_y = ceil(self.y)
      self.x = self.x >= 0 and floor(self.x) + 0.5 or (ceil_x == self.x and ceil_x + 0.5 or ceil_x - 0.5)
      self.y = self.y >= 0 and floor(self.y) + 0.5 or (ceil_y == self.y and ceil_y + 0.5 or ceil_y - 0.5)
      return self
    end

    --- Swap the x and y coordinates.
    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:swap()
      local x, y = self.y, self.x
      self.x, self.y = x, y
      return self
    end

    --- Flip the signs of the position.
    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:flip()
      self.x, self.y = -self.x, -self.y
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:flipx()
      self.x = -self.x
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return Class
    function PositionClass:flipy()
      self.y = -self.y
      return self
    end

    ---Trim the position to a length.
    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@param max_length number
    ---@return Class
    function PositionClass:trim(max_length)
      local s = max_length * max_length / (self.x * self.x + self.y * self.y)
      s = (s > 1 and 1) or sqrt(s)
      self.x, self.y = self.x * s, self.y * s
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@param other AnyPosOrVec
    ---@param alpha float
    ---@return Class
    function PositionClass:lerp(other, alpha)
      local other_x, other_y = PositionClass.as_tuple(other)
      self.x = self.x + (other_x - self.x) * alpha
      self.y = self.y + (other_y - self.y) * alpha
      return self
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@param dir defines.direction
    ---@param distance number
    ---@return Class
    function PositionClass:translate(dir, distance)
      return PositionClass.add(self, Direction.to_vector(dir, distance))
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Position Class Mutates

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return MapPositionClass
    function PositionClass:as_map_position()
      return setmetatable(self, PositionClass.Map)
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return ChunkPositionClass
    function PositionClass:as_chunk_position()
      return setmetatable(self, PositionClass.Chunk)
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return PixelPositionClass
    function PositionClass:as_pixel_position()
      return setmetatable(self, PositionClass.Pixel)
    end

    ---@generic Class: AnyPositionClass
    ---@param self Class
    ---@return TilePositionClass
    function PositionClass:as_tile_position()
      return setmetatable(self, PositionClass.Tile)
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Numbers

    ---Gets the squared length of a position
    function PositionClass:len_squared()
      return self.x * self.x + self.y * self.y
    end

    ---Gets the length of a position
    function PositionClass:len()
      return (self.x * self.x + self.y * self.y) ^ 0.5
    end

    ---Return the cross product of two positions.
    ---@param other AnyPosOrVec
    function PositionClass:cross(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      return self.x * other_y - self.y * other_x
    end

    ---Return the dot product of two positions.
    ---@param other AnyPosOrVec
    function PositionClass:dot(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      return self.x * other_x + self.y * other_y
    end

    ---@param other AnyPosOrVec
    ---@return defines.direction
    function PositionClass:direction_to(other)
      local other_x, other_y = PositionClass.as_tuple(other)
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
    function PositionClass:orientation_to(other)
      return (1 - (self:atan2(other) / pi)) / 2
    end

    ---Calculates the Euclidean distance between two positions.
    ---@param other AnyPosOrVec
    function PositionClass:distance(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      local ax_bx = self.x - other_x
      local ay_by = self.y - other_y
      return (ax_bx * ax_bx + ay_by * ay_by) ^ 0.5
    end

    ---Calculates the Euclidean distance squared between two positions, useful when sqrt is not needed.
    ---@param other AnyPosOrVec
    function PositionClass:distance_squared(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      local ax_bx = self.x - other_x
      local ay_by = self.y - other_y
      return ax_bx * ax_bx + ay_by * ay_by
    end

    ---Calculates the manhatten distance between two positions.
    -- @see https://en.wikipedia.org/wiki/Taxicab_geometry Taxicab geometry (manhatten distance)
    ---@param other AnyPosOrVec
    function PositionClass:manhattan_distance(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      return abs(other_x - self.x) + abs(other_y - self.y)
    end

    ---@param other AnyPosOrVec
    function PositionClass:atan2(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      return atan2(other_x - self.x, other_y - self.y)
    end

    ---@param other AnyPosOrVec
    function PositionClass:angle(other)
      local dist = self:distance(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      return dist ~= 0 and deg(acos((self.x * other_x + self.y * other_y) / dist)) or 0
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Booleans

    function PositionClass:inside(area)
      local lt = area.left_top
      local rb = area.right_bottom
      return self.x >= lt.x and self.y >= lt.y and self.x <= rb.x and self.y <= rb.y
    end

    function PositionClass:is_zero()
      return self.x == 0 and self.y == 0
    end

    ---@param other AnyPosOrVec
    function PositionClass:equals(other)
      local other_x, other_y = PositionClass.as_tuple(other)
      return self.x == other_x and self.y == other_y
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Other

    ---@return MapVector
    ---@nodiscard
    function PositionClass:pack()
      return { self.x, self.y }
    end

    ---@nodiscard
    function PositionClass:unpack()
      return self.x, self.y
    end

    ---@param pos AnyPosOrVec|number
    ---@return number, number
    ---@nodiscard
    function PositionClass.as_tuple_any(pos)
      if type(pos) == "number" then return pos, pos end
      return pos.x or pos[1], pos.y or pos[2]
    end

    ---@param pos AnyPosOrVec
    ---@return number, number
    ---@nodiscard
    function PositionClass.as_tuple(pos)
      return pos.x or pos[1], pos.y or pos[2]
    end

  end
  -------------------------------------------------------------------------------
  do ---@block Strings

    ---@param precision? float
    ---@nodiscard
    function PositionClass:to_string(precision)
      local f = precision and ("%" .. precision .. "f") or "%s"
      local tab = { "{ x = ", f, ", y = ", f, " }" }
      return concat(tab):format(self.x, self.y)
    end

    ---@param precision? float
    ---@nodiscard
    function PositionClass:to_string_vector(precision)
      local f = precision and ("%" .. precision .. "f") or "%s"
      local tab = { "{ ", f, ", ", f, " }" }
      return concat(tab):format(self.x, self.y)
    end

    ---@param precision? float
    ---@nodiscard
    function PositionClass:to_string_tuple(precision)
      local f = precision and ("%" .. precision .. "f") or "%s"
      local tab = { f, f }
      return concat(tab, ", "):format(self.x, self.y)
    end

  end
end

do ---@block Metatamethods

  PositionClass.__call = function(self) return PositionClass.copy(self) end
  PositionClass.__tostring = PositionClass.to_string
  PositionClass.__concat = function(self, other) return tostring(self) .. tostring(other) end
  PositionClass.__eq = function(self, other) return self.x == other.x and self.y == other.y end
  PositionClass.__unm = PositionClass.flip
  PositionClass.__newindex = function(self, key, value)
    if key == 1 then rawset(self, "x", value)
    elseif key == 2 then rawset(self, "y", value)
    else error("Invalid key: " .. tostring(key)) end
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionClass.__add = function(self, other)
    local metatable = getmetatable(self) or getmetatable(other)
    local self_x, self_y = PositionClass.as_tuple_any(self)
    local other_x, other_y = PositionClass.as_tuple_any(other)
    return PositionClass:construct(self_x + other_x, self_y + other_y, metatable)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionClass.__sub = function(self, other)
    local metatable = getmetatable(self) or getmetatable(other)
    local self_x, self_y = PositionClass.as_tuple_any(self)
    local other_x, other_y = PositionClass.as_tuple_any(other)
    return PositionClass:construct(self_x - other_x, self_y - other_y, metatable)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionClass.__mul = function(self, other)
    local metatable = getmetatable(self) or getmetatable(other)
    local self_x, self_y = PositionClass.as_tuple_any(self)
    local other_x, other_y = PositionClass.as_tuple_any(other)
    return PositionClass:construct(self_x * other_x, self_y * other_y, metatable)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionClass.__div = function(self, other)
    local metatable = getmetatable(self) or getmetatable(other)
    local self_x, self_y = PositionClass.as_tuple_any(self)
    local other_x, other_y = PositionClass.as_tuple_any(other)
    return PositionClass:construct(self_x / other_x, self_y / other_y, metatable)
  end

  ---@param self AnyPosOrVec|number
  ---@param other AnyPosOrVec|number
  PositionClass.__mod = function(self, other)
    local metatable = getmetatable(self) or getmetatable(other)
    local self_x, self_y = PositionClass.as_tuple_any(self)
    local other_x, other_y = PositionClass.as_tuple_any(other)
    return PositionClass:construct(self_x % other_x, self_y % other_y, metatable)
  end
end

return PositionClass
