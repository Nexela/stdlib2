---@class Position
local Position = {}
__POSITION_DEBUG__ = __POSITION_DEBUG__ or nil

local PositionClass = require("__stdlib2__/classes/PositionClass")
PositionClass.MapPositionClass = require("__stdlib2__/classes/MapPositionClass")
PositionClass.ChunkPositionClass = require("__stdlib2__/classes/ChunkPositionClass")
PositionClass.TilePositionClass = require("__stdlib2__/classes/TilePositionClass")
PositionClass.PixelPositionClass = require("__stdlib2__/classes/PixelPositionClass")

Position.MapPositionClass = PositionClass.MapPositionClass
Position.ChunkPositionClass = PositionClass.ChunkPositionClass
Position.TilePositionClass = PositionClass.TilePositionClass
Position.PixelPositionClass = PositionClass.PixelPositionClass

-- ============================================================================

---@generic Class: AnyPositionClass
---@param x double|integer
---@param y double|integer
---@param class Class
---@return Class
---@nodiscard
---@overload fun(x: double, y: double): MapPositionClass
local function new(x, y, class)
  class = class or Position.MapPositionClass
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
  Position.new = function(position, class)
    if not position then return Position.zero(class) end
    assert(type(position) == "table", "Position.new: position must be a MapPosition")
    return new(position.x or position[1], position.y or position[2], class)
  end


  ---@generic Class: AnyPositionClass
  ---@param x double|integer
  ---@param y double|integer
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(x: double, y: double): MapPositionClass
  Position.construct = function(x, y, class)
    assert(x and y, "PositionClass.construct: x and y must be numbers")
    return new(x, y, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param x double|integer
  ---@param y double|integer
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(x: double, y: double): MapPositionClass
  Position.construct_safe = function(x, y, class)
    return new(x, y, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param class Class
  ---@return Class
  ---@nodiscard
  ---@overload fun(): MapPositionClass
  Position.zero = function(class)
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
  Position.copy = function(position, class)
    class = class and class or Position[position.__class]
    assert(class, "Position.copy: position must be a MapPosition, ChunkPosition, TilePosition, or PixelPosition")
    return new(position.x, position.y, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param position AnyPosition
  ---@param class Class
  ---@return Class
  ---@overload fun(position: AnyPosition): MapPositionClass
  Position.load = function(position, class)
    class = class or Position.MapPositionClass
    return setmetatable(position, class)
  end

  ---@generic Class: AnyPositionClass
  ---@param position AnyPosition
  ---@param class Class
  ---@return Class
  ---@overload fun(self: Position, position: AnyPosition): MapPositionClass
  local __call = function(_, position, class)
    return Position.load(position, class)
  end

  setmetatable(Position, { __call = __call })

end
-- ============================================================================

return Position

---@class Position
---@field Area Area?
---@operator call(AnyPosition):AnyPositionClass

---@alias AnyVector MapVector|ChunkVector|TileVector|PixelVector
---@alias AnySimplePosition MapPosition|ChunkPosition|TilePosition|PixelPosition
---@alias AnyPositionClass MapPositionClass|ChunkPositionClass|TilePositionClass|PixelPositionClass
---@alias AnyPosition AnyPositionClass|AnySimplePosition
---@alias AnyPosOrVec AnyPosition|AnyVector
