---@class Position
local Position = {}
__POSITION_DEBUG__ = __POSITION_DEBUG__ or nil

local PositionClass = require("__stdlib2__/classes/PositionClass")
PositionClass.MapPosition = require("__stdlib2__/classes/MapPositionClass")
PositionClass.ChunkPosition = require("__stdlib2__/classes/ChunkPositionClass")
PositionClass.TilePosition = require("__stdlib2__/classes/TilePositionClass")
PositionClass.PixelPosition = require("__stdlib2__/classes/PixelPositionClass")

Position.MapPosition = PositionClass.MapPosition
Position.ChunkPosition = PositionClass.ChunkPosition
Position.TilePosition = PositionClass.TilePosition
Position.PixelPosition = PositionClass.PixelPosition

local math_floor = math.floor

-- ============================================================================

---@generic Class: AnyPositionClass
---@param x double|integer
---@param y double|integer
---@param class Class
---@return Class
---@nodiscard
---@overload fun(x: double, y: double): MapPositionClass
local function new(x, y, class)
  class = class or Position.MapPosition
  return setmetatable({ x = x, y = y }, class)
end

-- ============================================================================
do ---@block Position Constructors

  Position.as_tuple = PositionClass.as_tuple
  Position.as_tuple_any = PositionClass.as_tuple_any

  ---@generic Class: AnyPositionClass
  ---@param position? AnyPosOrVec
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(position?: AnyPosOrVec): MapPositionClass
  function Position:new(position, class)
    if not position then return self:zero(class) end
    assert(type(position) == "table", "Position.new: position must be a MapPosition")
    if class == self.ChunkPosition or class == self.TilePosition then
      assert(math_floor(position.x) == position.x and math_floor(position.y) == position.y, "PositionClass.construct: x and y must be integers")
    end
    return new(position.x or position[1], position.y or position[2], class)
  end

  ---@generic Class: AnyPositionClass
  ---@param position? AnyPosOrVec
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(position?: AnyPosOrVec): MapPositionClass
  function Position:new_unsafe(position, class)
    if not position then return self:zero(class) end
    return new(position.x or position[1], position.y or position[2], class)
  end

  ---@generic Class: AnyPositionClass
  ---@param x double|integer
  ---@param y double|integer
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(x: double, y: double): MapPositionClass
  function Position:construct(x, y, class)
    assert(x and y, "PositionClass.construct: x and y must be numbers")
    if class == self.ChunkPosition or class == self.TilePosition then
      assert(math_floor(x) == x and math_floor(y) == y, "PositionClass.construct: x and y must be integers")
    end
    return new(x, y, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param x double|integer
  ---@param y double|integer
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(x: double, y: double): MapPositionClass
  function Position:construct_unsafe(x, y, class)
    return new(x, y, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(): MapPositionClass
  function Position:zero(class)
    return new(0, 0, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param position AnyPositionClass
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(position: MapPositionClass): MapPositionClass
  ---@overload fun(position: ChunkPositionClass): ChunkPositionClass
  ---@overload fun(position: TilePositionClass): TilePositionClass
  ---@overload fun(position: PixelPositionClass): PixelPositionClass
  function Position:copy(position, class)
    class = class and class or self[position.__class]
    assert(class, "Position.copy: position must be a MapPosition, ChunkPosition, TilePosition, or PixelPosition")
    return new(position.x, position.y, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param position AnyPosition
  ---@param class Class
  ---@return Class
  ---@overload fun(position: AnyPosition): MapPositionClass
  function Position:load(position, class)
    class = class or self.MapPosition
    return setmetatable(position, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param position AnyPosition
  ---@param class Class
  ---@return Class
  ---@overload fun(self: Position, position: AnyPosition): MapPositionClass
  local __call = function(self, position, class)
    return self:load(position, class)
  end

  setmetatable(Position, { __call = __call })

end
-- ============================================================================

return Position

---@class Position
---@field Area Area?
---@operator call(AnyPosition):AnyPositionClass

---@alias AnySimplePosition MapPosition.0|ChunkPosition.0|TilePosition.0|PixelPosition.0|Vector.0
---@alias AnyPositionClass MapPositionClass|ChunkPositionClass|TilePositionClass|PixelPositionClass
---@alias AnyVector MapPosition.1|ChunkPosition.1|TilePosition.1|PixelPosition.1|Vector.1|IntVector.1

---@alias AnyPosition AnyPositionClass|AnySimplePosition
---@alias AnyPosOrVec AnyPosition|AnyVector
---@alias AnyIntPos ChunkPosition.0|TilePosition.0|IntVector.0|ChunkPositionClass|TilePositionClass|
---@alias AnyIntVec ChunkPosition.1|TilePosition.1|IntVector.1
---@alias AnyIntPosOrVec ChunkPosition|TilePosition|IntVector|ChunkPositionClass|TilePositionClass

---@alias IntVector IntVector.0|IntVector.1
---@class IntVector.0
---@field x integer
---@field y integer
---@class IntVector.1
---@field [1] integer
---@field [2] integer
