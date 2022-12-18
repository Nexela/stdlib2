--- @class Position
--- @field [MapPositionClass] MapPositionClass
--- @field [ChunkPositionClass] ChunkPositionClass
--- @field [TilePositionClass] TilePositionClass
--- @field [PixelPositionClass] PixelPositionClass
local Position = {}
__POSITION_DEBUG__ = __POSITION_DEBUG__ or nil

local ERROR = require("__stdlib2__/config").error

local PositionClass = require("__stdlib2__/classes/PositionClass")
PositionClass.Position = Position
PositionClass.MapPosition = require("__stdlib2__/classes/MapPositionClass")
PositionClass.ChunkPosition = require("__stdlib2__/classes/ChunkPositionClass")
PositionClass.TilePosition = require("__stdlib2__/classes/TilePositionClass")
PositionClass.PixelPosition = require("__stdlib2__/classes/PixelPositionClass")

Position.MapPosition = PositionClass.MapPosition
Position.ChunkPosition = PositionClass.ChunkPosition
Position.TilePosition = PositionClass.TilePosition
Position.PixelPosition = PositionClass.PixelPosition
Position[PositionClass.MapPosition] = PositionClass.MapPosition
Position[PositionClass.ChunkPosition] = PositionClass.ChunkPosition
Position[PositionClass.TilePosition] = PositionClass.TilePosition
Position[PositionClass.PixelPosition] = PositionClass.PixelPosition

local math_floor = math.floor
local assert = assert
local type = type

--- @generic Class: AnyPositionClass
--- @param x double|integer
--- @param y double|integer
--- @param class Class
--- @return Class
--- @nodiscard
--- @overload fun(x: double, y: double): MapPositionClass
local function new(x, y, class)
  class = class or Position.MapPosition
  return setmetatable({ x = x, y = y }, class)
end

do --- @block Position Constructors

  --- @generic num: double|integer|float
  --- @param pos AnyPosOrVec|number
  --- @return number, number
  --- @nodiscard
  function Position:as_tuple_any(pos)
    if type(pos) == "number" then return pos, pos end
    return pos.x or pos[1], pos.y or pos[2]
  end

  --- @generic num: double|integer|float
  --- @param pos AnyPosOrVec
  --- @return number, number
  --- @nodiscard
  function Position:as_tuple(pos)
    return pos.x or pos[1], pos.y or pos[2]
  end

  --- @generic Class: AnyPositionClass
  --- @param position? AnyPosOrVec
  --- @param class Class
  --- @return Class
  --- @nodiscard
  --- @overload fun(position?: AnyPosOrVec): MapPositionClass
  function Position:new(position, class)
    assert(self == Position, ERROR.called_without_self)
    if not position then return self:zero(class) end
    assert(type(position) == "table" and (position.x or position[1]) and (position.y or position[2]), ERROR.not_position_table)
    local x, y = position.x or position[1], position.y or position[2] --- @type number, number
    if class == self.ChunkPosition or class == self.TilePosition then
      assert(math_floor(x) == x and math_floor(y) == y, ERROR.invalid_values_integers)
    else
      if class then assert(Position[class], ERROR.not_position_class) end
      assert(type(x) == "number" and type(y) == "number", ERROR.invalid_values_numbers)
    end
    return new(x, y, class)
  end

  --- @generic Class: AnyPositionClass
  --- @param position? AnyPosOrVec
  --- @param class Class
  --- @return Class
  --- @nodiscard
  --- @overload fun(position?: AnyPosOrVec): MapPositionClass
  function Position:new_unsafe(position, class)
    if not position then return self:zero(class) end
    return new(position.x or position[1], position.y or position[2], class)
  end

  --- @generic Class: AnyPositionClass
  --- @param x double|integer
  --- @param y double|integer
  --- @param class Class
  --- @return Class
  --- @nodiscard
  --- @overload fun(x: double, y: double): MapPositionClass
  function Position:construct(x, y, class)
    if class == self.ChunkPosition or class == self.TilePosition then
      assert(math_floor(x) == x and math_floor(y) == y, ERROR.not_integers)
    else
      if class then assert(Position[class], ERROR.not_position_class) end
      assert(type(x) == "number" and type(y) == "number", ERROR.not_numbers)
    end
    return new(x, y, class)
  end

  --- @generic Class: AnyPositionClass
  --- @param x double|integer
  --- @param y double|integer
  --- @param class Class
  --- @return Class
  --- @nodiscard
  --- @overload fun(x: double, y: double): MapPositionClass
  function Position:construct_unsafe(x, y, class)
    return new(x, y, class)
  end

  --- @generic Class: AnyPositionClass
  --- @param class Class
  --- @return Class
  --- @nodiscard
  --- @overload fun(): MapPositionClass
  function Position:zero(class)
    return new(0, 0, class)
  end

  --- @generic Class: AnyPositionClass
  --- @param position AnyPositionClass
  --- @param class Class
  --- @return Class
  --- @nodiscard
  --- @overload fun(position: MapPositionClass): MapPositionClass
  --- @overload fun(position: ChunkPositionClass): ChunkPositionClass
  --- @overload fun(position: TilePositionClass): TilePositionClass
  --- @overload fun(position: PixelPositionClass): PixelPositionClass
  function Position:copy(position, class)
    class = class and assert(Position[class], ERROR.not_position_class) or assert(Position[position.Class], ERROR.not_position_class)
    return new(position.x, position.y, class)
  end

  --- @generic Class: AnyPositionClass
  --- @param position AnyPosition
  --- @param class Class
  --- @return Class
  --- @overload fun(position: AnyPosition): MapPositionClass
  function Position:load(position, class)
    class = class or self.MapPosition
    return setmetatable(position, class)
  end

  --- @generic Class: AnyPositionClass
  --- @param position AnyPosition
  --- @param class Class
  --- @return Class
  --- @overload fun(self: Position, position: AnyPosition): MapPositionClass
  local __call = function(_, position, class)
    return setmetatable(position, class or Position.MapPosition)
  end

  setmetatable(Position, { __call = __call })

end

return Position

--- @class Position
--- @field Area Area?
--- @operator call(AnyPosition):AnyPositionClass

--- @alias AnySimplePosition MapPosition.0|ChunkPosition.0|TilePosition.0|PixelPosition.0|Vector.0
--- @alias AnyPositionClass MapPositionClass|ChunkPositionClass|TilePositionClass|PixelPositionClass
--- @alias AnyVector MapPosition.1|ChunkPosition.1|TilePosition.1|PixelPosition.1|Vector.1|TileVector.1

--- @alias AnyPosition AnyPositionClass|AnySimplePosition
--- @alias AnyPosOrVec AnyPosition|AnyVector
--- @alias AnyIntPos ChunkPosition.0|TilePosition.0|TileVector.0|ChunkPositionClass|TilePositionClass
--- @alias AnyIntVec ChunkPosition.1|TilePosition.1|TileVector.1
--- @alias AnyIntPosOrVec ChunkPosition|TilePosition|TileVector|ChunkPositionClass|TilePositionClass

--- @alias TileVector TileVector.0|TileVector.1
--- @class TileVector.0
--- @field x integer
--- @field y integer
--- @class TileVector.1
--- @field [1] integer
--- @field [2] integer
