---@class Area
---@operator call(AnyArea): AreaClass
local Area = {}

---@class AreaClass
local AreaClass = {}
local area_meta = {}

local Orientation = require("__stdlib2__/orientation")
local Position = require("__stdlib2__/position")
Position.Area = Area
require("__stdlib2__/classes/PositionClass").Area = Area
Area.Position = Position

local as_pos_tuple_any = Position.as_tuple_any ---@diagnostic disable-line: unused-local
local as_pos_tuple = Position.as_tuple
local setmetatable = setmetatable
local abs = math.abs
local concat = table.concat

-- ============================================================================
---@param ltx number
---@param lty number
---@param rbx number
---@param rby number
---@param ori? float
---@param metatable? table
---@return AreaClass
---@nodiscard
local function new(ltx, lty, rbx, rby, ori, metatable)
  local lt, rb = Position:construct(ltx, lty), Position:construct(rbx, rby)
  local area = setmetatable({ left_top = lt, right_bottom = rb, orientation = ori }, metatable or area_meta)
  assert(AreaClass.is_normal(area), "Area is not normalized.")
  return area
end

---@param ltx number
---@param lty number
---@param rbx number
---@param rby number
---@param ori? float
---@param metatable? table
---@return AreaClass
---@nodiscard
local function new_unsafe(ltx, lty, rbx, rby, ori, metatable)
  local lt, rb = Position:load { x = ltx, y = lty }, Position:load { x = rbx, y = rby }
  local area = setmetatable({ left_top = lt, right_bottom = rb, orientation = ori }, metatable or area_meta)
  return area
end

---@param self AnyBox
---@return number, number, number, number, RealOrientation?
---@nodiscard
local function as_tuple(self)
  local lt, rb = self.left_top or self[1], self.right_bottom or self[2]
  return lt.x or lt[1], lt.y or lt[2], rb.x or rb[1], rb.y or rb[2], self.orientation or self[3] --[[@as RealOrientation|nil]]
end

---@param self AnyBox
---@return Vector.1, Vector.1, RealOrientation?
local function as_vector_tuple(self)
  local lt, rb = self.left_top or self[1], self.right_bottom or self[2]
  return { lt.x or lt[1], lt.y or lt[2] }, { rb.x or rb[1], rb.y or rb[2] }, self.orientation or self[3] --[[@as RealOrientation|nil]]
end

--luacheck: ignore 211/as_tuple_any
---@param self AnyBox|number
---@return number, number, number, number, RealOrientation??
---@diagnostic disable-next-line: unused-local
local function as_tuple_any(self)
  local typeof = type(self)
  if typeof == "number" then return self, self, self, self
  elseif typeof == "table" then
    ---@type MapPosition, MapPosition
    local lt, rb = self.left_top or self[1], self.right_bottom or self[2]
    return lt.x or lt[1], lt.y or lt[2], rb.x or rb[1], rb.y or rb[2], self.orientation or self[3]
  else error("Invalid type for area: " .. typeof) end
end

-- ============================================================================
do ---@block Area Constructors

  ---@return AreaClass
  ---@nodiscard
  function AreaClass:copy()
    local lt, rb = self.left_top:copy_as(Position.MapPosition), self.right_bottom:copy_as(Position.MapPosition)
    return setmetatable({ left_top = lt, right_bottom = rb, orientation = rawget(self, "ori") }, getmetatable(self))
  end

end
-------------------------------------------------------------------------------
do ---@block Position Conversions

  ---@return MapPositionClass
  ---@nodiscard
  function AreaClass:center()
    local lt = self.left_top
    local width, height = self:dimensions()
    return Position:construct_unsafe(lt.x + width / 2, lt.y + height / 2)
  end

  ---@return MapPositionClass
  ---@nodiscard
  function AreaClass:get_left_bottom()
    local lt = self.left_top
    return Position:construct_unsafe(lt.x, lt.y + self:get_height())
  end

  ---@return MapPositionClass
  ---@nodiscard
  function AreaClass:get_right_top()
    local lt = self.left_top
    return Position:construct_unsafe(lt.x + self:get_width(), lt.y)
  end

end
-------------------------------------------------------------------------------
do ---@block Area Methods

  ---@param ltx? number
  ---@param lty? number
  ---@param rbx? number
  ---@param rby? number
  ---@param ori? float
  ---@return AreaClass
  function AreaClass:update(ltx, lty, rbx, rby, ori)
    self.left_top:update(ltx, lty)
    self.right_bottom:update(rbx, rby)
    self.orientation = ori and ori or self.orientation
    return self
  end

  function AreaClass:normalize()
    return self
  end

  function AreaClass:round(divisor)
    self.left_top:round(divisor)
    self.right_bottom:round(divisor)
    return self
  end

  function AreaClass:floor(divisor)
    self.left_top:floor(divisor)
    self.right_bottom:floor(divisor)
    return self
  end

  function AreaClass:ceil(divisor)
    self.left_top:ceil(divisor)
    self.right_bottom:ceil(divisor)
    return self
  end

  function AreaClass:adjust()
    return self
  end

  function AreaClass:rotate()
    return self
  end

  function AreaClass:offset(position)
    self.left_top:add(position)
    self.right_bottom:add(position)
    return self
  end

  function AreaClass:translate(direction, distance)
    self.left_top:translate(direction, distance)
    self.right_bottom:translate(direction, distance)
    return self
  end

  function AreaClass:add(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:add(other)
      self.right_bottom:add(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:add(lt)
      self.right_bottom:add(rb)
      local ori_result = Orientation.add(self.orientation --[[@as RealOrientation]] or 0.0, ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function AreaClass:subtract(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:subtract(other)
      self.right_bottom:subtract(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:subtract(lt)
      self.right_bottom:subtract(rb)
      local ori_result = Orientation.add(self.orientation --[[@as RealOrientation]] or 0.0, -ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function AreaClass:multiply(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:multiply(other)
      self.right_bottom:multiply(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:multiply(lt)
      self.right_bottom:multiply(rb)
      local ori_result = Orientation.multiply(self.orientation --[[@as RealOrientation]] or 0.0, ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function AreaClass:divide(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:divide(other)
      self.right_bottom:divide(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:divide(lt)
      self.right_bottom:divide(rb)
      local ori_result = Orientation.multiply(self.orientation --[[@as RealOrientation]] or 0.0, -ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function AreaClass:modulo(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:modulo(other)
      self.right_bottom:modulo(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:modulo(lt)
      self.right_bottom:modulo(rb)
      local ori_result = ((self.orientation or 0) % (ori or 0)) % 1
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

end
-------------------------------------------------------------------------------
do ---@block Numbers

  ---@return number
  ---@nodiscard
  function AreaClass:get_width()
    return abs(self.left_top.x - self.right_bottom.x)
  end

  ---@return number
  ---@nodiscard
  function AreaClass:get_height()
    return abs(self.left_top.y - self.right_bottom.y)
  end

  ---@return number
  ---@nodiscard
  function AreaClass:size()
    return self:get_width() * self:get_height()
  end

  ---@return number, number
  ---@nodiscard
  function AreaClass:dimensions()
    return self:get_width(), self:get_height()
  end

  ---@return number
  ---@nodiscard
  function AreaClass:perimeter()
    return 2 * self:get_width() + 2 * self:get_height()
  end

end
-------------------------------------------------------------------------------
do ---@block Booleans

  ---@param position AnyPosOrVec
  ---@return boolean
  ---@nodiscard
  function AreaClass:contains(position)
    local lt, rb = self.left_top, self.right_bottom
    local x, y = as_pos_tuple(position)
    return x >= lt.x and x <= rb.x and y >= lt.y and y <= rb.y
  end

  ---@param other AnyArea
  ---@return boolean
  ---@nodiscard
  function AreaClass:inside(other)
    local ltx, rbx, lty, rby = self:unpack()
    local o_ltx, o_rbx, o_lty, o_rby = as_tuple(other)
    return ltx >= o_ltx and rbx <= o_rbx and lty >= o_lty and rby <= o_rby
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:equals(other)
    local lt, rb = self.left_top, self.right_bottom
    local other_ltx, other_lty, other_rbx, other_rby = as_tuple(other)
    return lt.x == other_ltx and lt.y == other_lty and rb.x == other_rbx and rb.y == other_rby
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:is_zero()
    return self:size() == 0
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:is_square()
    return self:get_width() == self:get_height()
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:is_chunk_area()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x % 32 == 0 and lt.y % 32 == 0 and rb.x == lt.x + 32 and rb.y == lt.y + 32
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:is_chunk_tile_area()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x % 32 == 0 and lt.y % 32 == 0 and rb.x == lt.x + 31 and rb.y == lt.y + 31
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:is_tile_area()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x % 1 == 0 and lt.y % 1 == 0 and rb.x == lt.x + 1 and rb.y == lt.y + 1
  end

  ---@return boolean
  ---@nodiscard
  function AreaClass:is_normal()
    local lt, rb = self.left_top, self.right_bottom
    return rb.x >= lt.x and rb.y >= lt.y
  end

end
-------------------------------------------------------------------------------
do ---@block Strings

  --- { left_top = { y = 0, y = 0 }, right_bottom = { x = 0, y = 0 } }
  ---
  --- { left_top = { y = 0, y = 0 }, right_bottom = { x = 0, y = 0 }, orientation = 0 }
  ---@param precision? float
  ---@return string
  ---@nodiscard
  function AreaClass:to_string(precision)
    local lt, rb = self.left_top:to_string(precision), self.right_bottom:to_string(precision)
    local f_str = precision and ("%" .. precision .. "f") or "%s"
    local o_str = self.orientation and (", orientation = " .. f_str) or ""
    local tab = { "{ left_top = ", lt, ", right_bottom = ", rb, o_str, " }" }
    return concat(tab):format(self.orientation)
  end

  --- { { 0, 0 }, { 0, 0 } }
  ---
  --- { { 0, 0 }, { 0, 0 }, 0 }
  ---@param precision? float
  ---@return string
  ---@nodiscard
  function AreaClass:to_string_vector_box(precision)
    precision = precision or .3
    local lt, rb = self.left_top:to_string_vector(precision), self.right_bottom:to_string_vector(precision)
    local f_str = precision and ("%" .. precision .. "f") or "%s"
    local o_str = self.orientation and (", " .. f_str) or ""
    local tab = { "{ ", lt, ", ", rb, o_str, " }" }
    return concat(tab):format(self.orientation)
  end

  --- { 0, 0 }, { 0, 0 }
  ---
  --- { 0, 0 }, { 0, 0 }, 0
  ---@param precision? float
  ---@return string
  ---@nodiscard
  function AreaClass:to_string_vector_tuple(precision)
    precision = precision or .3
    local lt, rb = self.left_top:to_string_vector(precision), self.right_bottom:to_string_vector(precision)
    local f_str = precision and ("%" .. precision .. "f") or "%s"
    local o_str = self.orientation and (", " .. f_str) or ""
    local tab = { lt, ", ", rb, o_str }
    return concat(tab):format(self.orientation)
  end

  --- 0, 0, 0, 0
  ---
  --- 0, 0, 0, 0, 0
  ---@param precision? float
  ---@return string
  ---@nodiscard
  function AreaClass:to_string_tuple(precision)
    precision = precision or .3
    local lt, rb = self.left_top:to_string_tuple(precision), self.right_bottom:to_string_tuple(precision)
    local f_str = precision and ("%" .. precision .. "f") or "%s"
    local o_str = self.orientation and (", " .. f_str) or ""
    local tab = { lt, ", ", rb, o_str }
    return concat(tab):format(self.orientation)
  end

end
-------------------------------------------------------------------------------
do ---@block Other

  ---@return AreaArray
  ---@nodiscard
  function AreaClass:pack()
    local lt, rb = self.left_top, self.right_bottom
    return { lt.x, lt.y, rb.x, rb.y }
  end

  ---@return number, number, number, number
  ---@nodiscard
  function AreaClass:unpack()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x, lt.y, rb.x, rb.y
  end

  ---@return BoundingBox.1
  ---@nodiscard
  function AreaClass:unpack_bounding_box()
    local lt, rb = self.left_top, self.right_bottom
    return { { lt.x, lt.y }, { rb.x, rb.y } }
  end

end
-- ============================================================================
do ---@block Metamethods

  ---@param self AreaClass
  area_meta.__call = function(self) return self:copy() end

  ---@param self AreaClass
  area_meta.__index = function(self, key)
    if AreaClass[key] then return AreaClass[key]
    elseif key == 1 then return rawget(self, "left_top")
    elseif key == 2 then return rawget(self, "right_bottom")
    elseif key == 3 then return rawget(self, "orientation")
    elseif key == "right_top" then return AreaClass.get_right_top(self)
    elseif key == "left_bottom" then return AreaClass.get_left_bottom(self)
    elseif key == "width" then return AreaClass.get_width(self)
    elseif key == "height" then return AreaClass.get_height(self)
    else return nil end
  end

  ---@param self AreaClass
  area_meta.__newindex = function(self, key, value)
    if key == 1 then rawset(self, "left_top", Position.new(value))
    elseif key == 2 then rawset(self, "right_bottom", Position.new(value))
    elseif key == 3 then rawset(self, "orientation", value)
    else rawset(self, key, value) end
  end

  area_meta.__tostring = AreaClass.to_string

  area_meta.__concat = function(a, b) return tostring(a) .. tostring(b) end

  area_meta.__eq = function(a, b) return a.left_top == b.left_top and a.right_bottom == b.right_bottom and a.orientation == b.orientation end

end
-- ============================================================================
do ---@block Area Constructors

  ---@param area? AnyArea
  ---@return AreaClass
  ---@nodiscard
  function Area:new(area)
    if not area then return self:zero() end
    local lt = Position:new(area.left_top or area[1])
    local rb = Position:new(area.right_bottom or area[2])
    local o = area.orientation or area[3]
    return setmetatable({ left_top = lt, right_bottom = rb, orientation = o }, area_meta)
  end

  ---@param ltx number
  ---@param lty number
  ---@param rbx number
  ---@param rby number
  ---@param ori? float
  ---@return AreaClass
  ---@nodiscard
  function Area:construct(ltx, lty, rbx, rby, ori)
    return new(ltx, lty, rbx, rby, ori)
  end

  ---@param arr AreaArray
  ---@return AreaClass
  ---@nodiscard
  function Area:from_array(arr)
    return new(arr[1], arr[2], arr[3], arr[4], arr[5])
  end

  ---@param vecbox BoundingBox.1
  ---@return AreaClass
  ---@nodiscard
  function Area:from_vector_box(vecbox)
    return new(vecbox[1][1], vecbox[1][2], vecbox[2][1], vecbox[2][2], vecbox[3])
  end

  ---@param left_top AnyPosOrVec
  ---@param right_bottom AnyPosOrVec
  ---@return AreaClass
  ---@nodiscard
  function Area:from_positions(left_top, right_bottom)
    local ltx, lty = as_pos_tuple(left_top)
    local rbx, rby = as_pos_tuple(right_bottom)
    return new(ltx, lty, rbx, rby)
  end

  ---@param position AnyPosOrVec
  ---@param vector? AnyPosOrVec|number
  ---@return AreaClass
  ---@nodiscard
  function Area:from_position(position, vector)
    local x, y = as_pos_tuple(position)
    local vec_x, vec_y = 0, 0
    if vector then vec_x, vec_y = as_pos_tuple_any(vector) end
    vec_x, vec_y = abs(vec_x / 2), abs(vec_y / 2)
    return new(x - vec_x, y - vec_y, x + vec_x, y + vec_y)
  end

  ---@param left_top AnyPosOrVec
  ---@param vector? AnyPosOrVec|number
  ---@return AreaClass
  ---@nodiscard
  function Area:from_left_top(left_top, vector)
    local x, y = as_pos_tuple(left_top)
    local vec_x, vec_y = 0, 0
    if vector then vec_x, vec_y = as_pos_tuple_any(vector) end
    return new(x, y, x + vec_x, y + vec_y)
  end

  ---@return AreaClass
  ---@nodiscard
  function Area:from_string()
    error("Not implemented")
  end

  ---@return AreaClass
  ---@nodiscard
  function Area:zero()
    return new_unsafe(0, 0, 0, 0)
  end

  ---@return AreaClass
  ---@nodiscard
  function Area:one()
    return new_unsafe(0, 0, 1, 1)
  end

  ---@return AreaClass
  ---@nodiscard
  function Area:two()
    return new_unsafe(-1, -1, 1, 1)
  end

  ---@param left_top MapPositionClass
  ---@param right_bottom MapPositionClass
  ---@return AreaClass
  ---@nodiscard
  function Area:load_from_positions(left_top, right_bottom)
    return setmetatable({ left_top = left_top, right_bottom = right_bottom }, area_meta)
  end

  ---@param area AnyArea
  ---@return AreaClass
  function Area:load(area)
    Position:load(area.left_top)
    Position:load(area.right_bottom)
    return setmetatable(area, area_meta) --[[@as AreaClass]]
  end

  ---@param area AnyArea
  ---@return AreaClass
  local function __call(self, area)
    return self:load(area)
  end

  setmetatable(Area, { __call = __call })

end

-- ============================================================================

return Area

---@class AreaClass
---@field left_top MapPositionClass
---@field right_bottom MapPositionClass
---@field right_top MapPositionClass
---@field left_bottom MapPositionClass
---@field orientation RealOrientation?
---@field width double
---@field height double

---@alias AnyArea AreaClass
---@alias AnyBox AnyArea|BoundingBox
---@alias FuncTable {[string]: function}

---@class AreaArray
---@field [1] number
---@field [2] number
---@field [3] number
---@field [4] number
---@field [5] float?
