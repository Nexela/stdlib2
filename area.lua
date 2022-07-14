---@class AreaClass
---@operator call(AnyArea): Area
local AreaClass = {}

---@class Area: BoundingBox
local Area = {}
local area_meta = {}

local Position = require("__stdlib2__/position")
local Orientation = require("__stdlib2__/orientation")
Position.AreaClass = AreaClass
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
---@return Area
---@nodiscard
local function new(ltx, lty, rbx, rby, ori, metatable)
  local lt, rb = Position.construct(ltx, lty), Position.construct(rbx, rby)
  local area = setmetatable({ left_top = lt, right_bottom = rb, orientation = ori }, metatable or area_meta)
  assert(Area.is_normal(area), "Area is not normalized.")
  return area
end

---@param ltx number
---@param lty number
---@param rbx number
---@param rby number
---@param ori? float
---@param metatable? table
---@return Area
---@nodiscard
local function new_safe(ltx, lty, rbx, rby, ori, metatable)
  local lt, rb = Position.load { x = ltx, y = lty }, Position.load { x = rbx, y = rby }
  local area = setmetatable({ left_top = lt, right_bottom = rb, orientation = ori }, metatable or area_meta)
  return area
end

---@param self AnyBox
---@return number, number, number, number, float
---@nodiscard
local function as_tuple(self)
  local lt, rb = self.left_top or self[1], self.right_bottom or self[2]
  return lt.x or lt[1], lt.y or lt[2], rb.x or rb[1], rb.y or rb[2], self.orientation or self[3]
end

---@param self AnyBox
---@return MapVector, MapVector, float
local function as_vector_tuple(self)
  local lt, rb = self.left_top or self[1], self.right_bottom or self[2]
  return { lt.x or lt[1], lt.y or lt[2] }, { rb.x or rb[1], rb.y or rb[2] }, self.orientation or self[3]
end

---@param self AnyBox|number
---@diagnostic disable-next-line: unused-local
local function as_tuple_any(self)
  local typeof = type(self)
  if typeof == "number" then return self, self, self, self
  elseif typeof == "table" then
    local lt, rb = self.left_top or self[1], self.right_bottom or self[2]
    return lt.x or lt[1], lt.y or lt[2], rb.x or rb[1], rb.y or rb[2]
  else error("Invalid type for area: " .. typeof) end
end

-- ============================================================================
do ---@block Area Constructors

  ---@return Area
  ---@nodiscard
  function Area:copy()
    local lt, rb = self.left_top:copy(), self.right_bottom:copy()
    return setmetatable({ left_top = lt, right_bottom = rb, orientation = rawget(self, "ori") }, getmetatable(self))
  end

end
-------------------------------------------------------------------------------
do ---@block Position Conversions

  ---@return Position
  ---@nodiscard
  function Area:center()
    local width, height = Area.dimensions(self)
    return Position.construct_safe(width / 2, height / 2)
  end

  ---@return Position
  ---@nodiscard
  function Area:get_left_bottom()
    local lt = self.left_top
    return Position.construct_safe(lt.x, lt.y + Area.get_height(self))
  end

  ---@return Position
  ---@nodiscard
  function Area:get_right_top()
    local lt = self.left_top
    return Position.construct_safe(lt.x + Area.get_width(self), lt.y)
  end

end
-------------------------------------------------------------------------------
do ---@block Area Methods

  ---@param ltx? number
  ---@param lty? number
  ---@param rbx? number
  ---@param rby? number
  ---@param ori? float
  ---@return Area
  function Area:update(ltx, lty, rbx, rby, ori)
    self.left_top:update(ltx, lty)
    self.right_bottom:update(rbx, rby)
    self.orientation = ori and ori or self.orientation
    return self
  end

  function Area:normalize()
    return self
  end

  function Area:round(divisor)
    self.left_top:round(divisor)
    self.right_bottom:round(divisor)
    return self
  end

  function Area:floor(divisor)
    self.left_top:floor(divisor)
    self.right_bottom:floor(divisor)
    return self
  end

  function Area:ceil(divisor)
    self.left_top:ceil(divisor)
    self.right_bottom:ceil(divisor)
    return self
  end

  function Area:adjust()
    return self
  end

  function Area:rotate()
    return self
  end

  function Area:offset(position)
    self.left_top:add(position)
    self.right_bottom:add(position)
    return self
  end

  function Area:translate(direction, distance)
    self.left_top:translate(direction, distance)
    self.right_bottom:translate(direction, distance)
    return self
  end

  function Area:add(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:add(other)
      self.right_bottom:add(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:add(lt)
      self.right_bottom:add(rb)
      local ori_result = Orientation.add(self.orientation or 0.0, ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function Area:subtract(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:subtract(other)
      self.right_bottom:subtract(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:subtract(lt)
      self.right_bottom:subtract(rb)
      local ori_result = Orientation.add(self.orientation or 0.0, -ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function Area:multiply(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:multiply(other)
      self.right_bottom:multiply(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:multiply(lt)
      self.right_bottom:multiply(rb)
      local ori_result = Orientation.multiply(self.orientation or 0.0, ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function Area:divide(other)
    if other.x or type(other[1]) == "number" then
      self.left_top:divide(other)
      self.right_bottom:divide(other)
    else
      local lt, rb, ori = as_vector_tuple(other)
      self.left_top:divide(lt)
      self.right_bottom:divide(rb)
      local ori_result = Orientation.multiply(self.orientation or 0.0, -ori or 0.0)
      self.orientation = ori_result ~= 0 and ori_result or nil
    end
    return self
  end

  function Area:modulo(other)
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
  function Area:get_width()
    return abs(self.left_top.x - self.right_bottom.x)
  end

  ---@return number
  ---@nodiscard
  function Area:get_height()
    return abs(self.left_top.y - self.right_bottom.y)
  end

  ---@return number
  ---@nodiscard
  function Area:size()
    return Area.get_width(self) * Area.get_height(self)
  end

  ---@return number, number
  ---@nodiscard
  function Area:dimensions()
    return Area.get_width(self), Area.get_height(self)
  end

  ---@return number
  ---@nodiscard
  function Area:perimeter()
    return 2 * Area.get_width(self) + 2 * Area.get_height(self)
  end

end
-------------------------------------------------------------------------------
do ---@block Booleans

  ---@param position AnyPosOrVec
  ---@return boolean
  ---@nodiscard
  function Area:contains(position)
    local lt, rb = self.left_top, self.right_bottom
    local x, y = as_pos_tuple(position)
    return x >= lt.x and x <= rb.x and y >= lt.y and y <= rb.y
  end

  ---@param other AnyArea
  ---@return boolean
  ---@nodiscard
  function Area:inside(other)
    local ltx, rbx, lty, rby = Area.unpack(self)
    local oltx, orbx, olty, orby = as_tuple(other)
    return ltx >= oltx and rbx <= orbx and lty >= olty and rby <= orby
  end

  ---@return boolean
  ---@nodiscard
  function Area:equals(other)
    local lt, rb = self.left_top, self.right_bottom
    local other_ltx, other_lty, other_rbx, other_rby = as_tuple(other)
    return lt.x == other_ltx and lt.y == other_lty and rb.x == other_rbx and rb.y == other_rby
  end

  ---@return boolean
  ---@nodiscard
  function Area:is_zero()
    return Area.size(self) == 0
  end

  ---@return boolean
  ---@nodiscard
  function Area:is_square()
    return Area.get_width(self) == Area.get_height(self)
  end

  ---@return boolean
  ---@nodiscard
  function Area:is_chunk_area()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x % 32 == 0 and lt.y % 32 == 0 and rb.x == lt.x + 32 and rb.y == lt.y + 32
  end

  ---@return boolean
  ---@nodiscard
  function Area:is_chunk_tile_area()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x % 32 == 0 and lt.y % 32 == 0 and rb.x == lt.x + 31 and rb.y == lt.y + 31
  end

  ---@return boolean
  ---@nodiscard
  function Area:is_tile_area()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x % 1 == 0 and lt.y % 1 == 0 and rb.x == lt.x + 1 and rb.y == lt.y + 1
  end

  ---@return boolean
  ---@nodiscard
  function Area:is_normal()
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
  function Area:to_string(precision)
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
  function Area:to_string_vector_box(precision)
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
  function Area:to_string_vector_tuple(precision)
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
  function Area:to_string_tuple(precision)
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
  function Area:pack()
    local lt, rb = self.left_top, self.right_bottom
    return { lt.x, lt.y, rb.x, rb.y }
  end

  ---@return number, number, number, number
  ---@nodiscard
  function Area:unpack()
    local lt, rb = self.left_top, self.right_bottom
    return lt.x, lt.y, rb.x, rb.y
  end

  ---@return VectorBox
  ---@nodiscard
  function Area:unpack_vector_box()
    local lt, rb = self.left_top, self.right_bottom
    return { { lt.x, lt.y }, { rb.x, rb.y } }
  end

end
-- ============================================================================
do ---@block Metamethods

  ---@param self Area
  area_meta.__call = function(self) return Area.copy(self) end

  ---@param self Area
  area_meta.__index = function(self, key)
    if Area[key] then return Area[key]
    elseif key == 1 then return rawget(self, "left_top")
    elseif key == 2 then return rawget(self, "right_bottom")
    elseif key == 3 then return rawget(self, "orientation")
    elseif key == "right_top" then return Area.get_right_top(self)
    elseif key == "left_bottom" then return Area.get_left_bottom(self)
    elseif key == "width" then return Area.get_width(self)
    elseif key == "height" then return Area.get_height(self)
    else return nil end
  end

  ---@param self Area
  area_meta.__newindex = function(self, key, value)
    if key == 1 then rawset(self, "left_top", Position.new(value))
    elseif key == 2 then rawset(self, "right_bottom", Position.new(value))
    elseif key == 3 then rawset(self, "orientation", value)
    else rawset(self, key, value) end
  end

  area_meta.__tostring = Area.to_string

  area_meta.__concat = function(a, b) return tostring(a) .. tostring(b) end

  area_meta.__eq = function(a, b) return a.left_top == b.left_top and a.right_bottom == b.right_bottom and a.orientation == b.orientation end

end
-- ============================================================================
do ---@block AreaClass Constructors

  ---@param area AnyArea
  ---@return Area
  ---@nodiscard
  function AreaClass.new(area)
    if not area then return AreaClass.zero() end
    local lt = Position.new(area.left_top or area[1])
    local rb = Position.new(area.right_bottom or area[2])
    local o = area.orientation or area[3]
    return setmetatable({ left_top = lt, right_bottom = rb, orientation = o }, area_meta)
  end

  ---@param ltx number
  ---@param lty number
  ---@param rbx number
  ---@param rby number
  ---@param ori? float
  ---@return Area
  ---@nodiscard
  function AreaClass.construct(ltx, lty, rbx, rby, ori)
    return new(ltx, lty, rbx, rby, ori)
  end

  ---@param arr AreaArray
  ---@return Area
  ---@nodiscard
  function AreaClass.from_array(arr)
    return new(arr[1], arr[2], arr[3], arr[4], arr[5])
  end

  ---@param vecbox VectorBox
  ---@return Area
  ---@nodiscard
  function AreaClass.from_vector_box(vecbox)
    return new(vecbox[1][1], vecbox[1][2], vecbox[2][1], vecbox[2][2], vecbox[3])
  end

  ---@param left_top AnyPosOrVec
  ---@param right_bottom AnyPosOrVec
  ---@return Area
  ---@nodiscard
  function AreaClass.from_positions(left_top, right_bottom)
    local ltx, lty = as_pos_tuple(left_top)
    local rbx, rby = as_pos_tuple(right_bottom)
    return new(ltx, lty, rbx, rby)
  end

  ---@param position AnyPosOrVec
  ---@param vector? AnyPosOrVec|number
  ---@return Area
  ---@nodiscard
  function AreaClass.from_position(position, vector)
    local x, y = as_pos_tuple(position)
    local vecx, vecy = 0, 0
    if vector then vecx, vecy = as_pos_tuple_any(vector) end
    vecx, vecy = abs(vecx / 2), abs(vecy / 2)
    return new(x - vecx, y - vecy, x + vecx, y + vecy)
  end

  ---@param left_top AnyPosOrVec
  ---@param vector? AnyPosOrVec|number
  ---@return Area
  ---@nodiscard
  function AreaClass.from_left_top(left_top, vector)
    local x, y = as_pos_tuple(left_top)
    local vecx, vecy = 0, 0
    if vector then vecx, vecy = as_pos_tuple_any(vector) end
    return new(x, y, x + vecx, y + vecy)
  end

  ---@return Area
  ---@nodiscard
  function AreaClass.from_string()
    error("Not implemented")
  end

  ---@return Area
  ---@nodiscard
  function AreaClass.zero()
    return new_safe(0, 0, 0, 0)
  end

  ---@return Area
  ---@nodiscard
  function AreaClass.one()
    return new_safe(0, 0, 1, 1)
  end

  ---@return Area
  ---@nodiscard
  function AreaClass.two()
    return new_safe(-1, -1, 1, 1)
  end

  ---@param left_top Position
  ---@param right_bottom Position
  ---@return Area
  ---@nodiscard
  function AreaClass.load_from_positions(left_top, right_bottom)
    return setmetatable({ left_top = left_top, right_bottom = right_bottom }, area_meta)
  end

  ---@param area AnyArea
  ---@return Area
  function AreaClass.load(area)
    Position.load(area.left_top)
    Position.load(area.right_bottom)
    return setmetatable(area, area_meta) --[[@as Area]]
  end

  ---@param area AnyArea
  ---@return Area
  local function __call(_, area)
    return AreaClass.load(area)
  end

  setmetatable(AreaClass, { __call = __call })

end

-- ============================================================================

return AreaClass

---@class Area
---@field left_top Position
---@field right_bottom Position
---@field right_top Position
---@field left_bottom Position
---@field orientation float? RealOrientation
---@field width number
---@field height number

---@alias AnyArea Area|BoundingBox
---@alias AnyBox AnyArea|VectorBox
---@alias FuncTable {[string]: function}

---@class VectorBox
---@field [1] MapVector
---@field [2] MapVector
---@field [3] float?

---@class AreaArray
---@field [1] number
---@field [2] number
---@field [3] number
---@field [4] number
---@field [5] float?
