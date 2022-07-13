--- @class PositionClass
--- @overload fun(): Position
--- @overload fun(pos: any): Position
--- @overload fun(x: double, y: double): Position
local PositionClass = {}

--- @alias POSITION Position|MapPosition|ChunkPos|ChunkPosition|PixelPos|TilePos|TilePosition|Vector

local floor, ceil, abs, atan2, deg, acos = math.floor, math.ceil, math.abs, math.atan2, math.deg, math.acos
local pi = math.pi
local setmetatable, assert = setmetatable, assert

local meta = {}

--- @class Position: MapPosition
local Position = {}
local position_mt

--- @class ChunkPos: ChunkPosition
local ChunkPos = {}
local chunk_mt

--- @class PixelPos: MapPosition
--- @field x double
--- @field y double
local PixelPos = {}
local pixel_mt

--- @class TilePos: TilePosition
local TilePos = {}
local tile_mt

--- @param x double
--- @param y double
--- @param metatable? table
--- @return Position
local function new(x, y, metatable)
    return setmetatable({ x = x, y = y }, metatable or position_mt)
end



do -- meta
    meta.concat = require('__stdlib2__.misc').concat

    meta.eq = function(this, other)
        return this.x == other.x and this.y == other.y
    end
end

do -- generic

end

do -- Position

    local function tile_center(pos)
        local x, y
        local ceil_x = ceil(pos.x)
        local ceil_y = ceil(pos.y)
        x = pos.x >= 0 and floor(pos.x) + 0.5 or (ceil_x == pos.x and ceil_x + 0.5 or ceil_x - 0.5)
        y = pos.y >= 0 and floor(pos.y) + 0.5 or (ceil_y == pos.y and ceil_y + 0.5 or ceil_y - 0.5)
        return x, y
    end

    --- @return ChunkPos
    function Position:to_chunk_position()
        return new(floor(self.x / 32), floor(self.y / 32), chunk_mt)
    end

    --- @return ChunkPos
    function Position:as_chunk_position()
        return setmetatable(self, chunk_mt)
    end

    --- @return PixelPos
    function Position:to_pixel_position()
        return new(self.x / 32, self.y / 32, pixel_mt)
    end

    --- @return PixelPos
    function Position:as_pixel_position()
        return setmetatable(self, pixel_mt)
    end

    --- @return TilePos
    function Position:to_tile_position()
        return new(floor(self.x), floor(self.y), tile_mt)
    end

    --- @return TilePos
    function Position:as_tile_position()
        return setmetatable(self, tile_mt)
    end

    function Position:expand()
    end

    function Position:to_area()
    end

    function Position:to_chunk_area()
    end

    function Position:to_tile_area()
    end

    --- @param x double
    --- @param y double
    function Position:update(x, y)
        self.x, self.y = x, y
        return self
    end

    function Position:copy()
        return setmetatable({ x = self.x, y = self.y }, getmetatable(self))
    end

    function Position:normalize()
        return new((self.x * 0.00390625) / 0.00390625, (self.y * 0.00390625) / 0.00390625, getmetatable(self))
    end

    function Position:normalized()
        return self:update((self.x * 0.00390625) / 0.00390625, (self.y * 0.00390625) / 0.00390625)
    end

    function Position:floor()
        return new(floor(self.x), floor(self.y))
    end

    function Position:floored()
        return self:update(floor(self.x), floor(self.y))
    end

    function Position:ceil()
        return new(ceil(self.x), ceil(self.y))
    end

    function Position:ceiled()
        return self:update(ceil(self.x), ceil(self.y))
    end

    function Position:add(other)
        other = as_position(other)
        return new(self.x + other.x, self.y + other.y)
    end

    function Position:added(other)
        other = as_position(other)
        return self:update(self.x + other.x, self.y + other.y)
    end

    function Position:subtract(other)
        other = as_position(other)
        return new(self.x - other.x, self.y - other.y)
    end

    function Position:subtracted(other)
        other = as_position(other)
        return self:update(self.x - other.x, self.y - other.y)
    end

    function Position:center()
        return new(tile_center(self))
    end

    function Position:centered()
        return self:update(tile_center(self))
    end

    function Position:round()
    end

    function Position:rounded()
    end

    function Position:lerp()
    end

    function Position:lerped()
    end

    function Position:translate()
    end

    function Position:translated()
    end

    function Position:random()
    end

    function Position:randomed()
    end

    function Position:offset_from()
    end

    function Position:incrementer()
    end

    local dirs = defines.direction
    --- @return defines.direction
    function Position:direction_to(other)
        local dx = self.x - other.x
        local dy = self.y - other.y
        if dx == 0 then return dy > 0 and dirs.north or dirs.south --[[@as defines.direction]] end
        if dy == 0 then return dx > 0 and dirs.west or dirs.east --[[@as defines.direction]] end

        local adx, ady = abs(dx), abs(dy)
        if adx > ady then return dx > 0 and dirs.north or dirs.south --[[@as defines.direction]] end
        return dy > 0 and dirs.west or dirs.east --[[@as defines.direction]]
    end

    --- @return RealOrientation
    function Position:orientation_to(other)
        return (1 - (self:atan2(other) / pi)) / 2
    end

    function Position:distance(other)
        local axbx = self.x - other.x
        local ayby = self.y - other.y
        return (axbx * axbx + ayby * ayby) ^ 0.5
    end

    --- @return Vector
    function Position:pack()
        return { self.x, self.y }
    end

    function Position:inside(area)
        local lt = area.left_top
        local rb = area.right_bottom
        return self.x >= lt.x and self.y >= lt.y and self.x <= rb.x and self.y <= rb.y
    end

    function Position:equals(other)
        other = as_position(other)
        return self.x == other.x and self.y == other.y
    end

    function Position:atan2(other)
        return atan2(other.x - self.x, other.y - self.y)
    end

    function Position:angle(other)
        local dist = self:distance(other)
        return dist ~= 0 and deg(acos((self.x * other.x + self.y * other.y) / dist)) or 0
    end

    function Position:tostring()
        return '{x = ' .. self.x .. ', ' .. 'y = ' .. self.y .. '}'
    end

    position_mt = { __index = Position, __tostring = Position.tostring, __concat = meta.concat, __eq = meta.eq }
end

do -- Tile

    --- @return Position
    function TilePos:to_position()
        return new(self.x --[[@as  double]], self.y --[[@as double]], position_mt)
    end

    --- @return Position
    function TilePos:as_position()
        return setmetatable(self, position_mt) --[[@as Position]]
    end

    TilePos.to_chunk_position = Position.to_chunk_position ----@type fun(self: TilePos): ChunkPos
    TilePos.as_chunk_position = Position.as_chunk_position ----@type fun(self: TilePos): ChunkPos
    TilePos.to_pixel_position = Position.to_pixel_position ----@type fun(self: TilePos): PixelPos
    TilePos.as_pixel_position = Position.as_pixel_position ----@type fun(self: TilePos): PixelPos

    TilePos.update = Position.update ----@type fun(self: TilePos, x: double, y: double): TilePos
    TilePos.normalized = Position.normalized ---@type fun(self: TilePos): TilePos

    tile_mt = { __index = TilePos, __tostring = Position.tostring, __concat = meta.concat, __eq = meta.eq }
end

do -- Metamethod stuff
    pixel_mt = { __index = PixelPos, __tostring = Position.tostring, __concat = meta.concat, __eq = meta.eq }
    chunk_mt = { __index = ChunkPos, __tostring = Position.tostring, __concat = meta.concat, __eq = meta.eq }
end

do -- Constructor stuff
    --- @return Position
    function PositionClass.load(pos)
        return setmetatable(pos, position_mt)
    end

    --- @param x double
    --- @param y double
    --- @return Position
    function PositionClass.from_xy(x, y)
        assert(x and y, 'Invalid x or y position')
        return setmetatable({ x = x, y = y }, position_mt)
    end

    --- @param chunk_pos ChunkPos|ChunkPosition
    --- @return ChunkPos
    function PositionClass.from_chunk(chunk_pos)
        local x, y = (floor(chunk_pos.x or chunk_pos[1]) * 32), (floor(chunk_pos.y or chunk_pos[2]) * 32)
        assert(x and y, 'Invalid chunk position')
        return setmetatable({ x = x, y = y }, position_mt)
    end

    --- @param pixel_pos PixelPos
    --- @return PixelPos
    function PositionClass.from_pixel(pixel_pos)
        local x, y = (pixel_pos.x or pixel_pos[1]) / 32, (pixel_pos.y or pixel_pos[2]) / 32
        assert(x and y, 'Invalid pixel position')
        return setmetatable({ x = x, y = y }, position_mt)
    end

    --- @param pos Position|MapPosition|Vector
    --- @return Position
    function PositionClass.from_position(pos)
        local x, y = pos.x or pos[1], pos.y or pos[2]
        assert(x and y, 'Invalid position')
        return setmetatable({ x = x, y = y }, position_mt)
    end
    PositionClass.from_tile = PositionClass.from_position
    PositionClass.from_vector = PositionClass.from_position
    PositionClass.unpack = PositionClass.from_position
    PositionClass.from_table = PositionClass.from_position

    --- @param pos_string string
    --- @return Position
    function PositionClass.from_string(pos_string)
        return PositionClass.new(load('return ' .. pos_string)())
    end

    --- @overload fun(): Position
    --- @overload fun(x:double, y:double): Position
    --- @overload fun(pos: MapPosition|Vector): Position
    --- @nodiscard
    function PositionClass.new(x, y)
        if not x then return setmetatable({ x = 0, y = 0 }, position_mt) end

        local typeof = type(x)
        if typeof == 'table' then
            local pos = x ---@type MapPosition
            if pos.x then return PositionClass.from_position(pos) end
            if pos[1] then return PositionClass.from_vector(pos) end
            error('Invalid position, expected {x = numx, y = numy} or {numx, numy}')
        end
        ---@cast x double
        if typeof == 'number' then return PositionClass.from_xy(x, y) end
        if typeof == 'string' then return PositionClass.from_string(x) end
        error('Arguments can not be converted to position')
    end

    --- Return mutable MapPosition or new MapPosition if not a MapPosition
    --- @overload fun(_:stdlib.AreaClass, x: double, y:double)
    local function __call(_, x, y)
        if not x then return setmetatable({ x = 0, y = 0 }, position_mt) end

        local metatable = getmetatable(x)
        if metatable then
            if metatable == position_mt then return x end
            if metatable == chunk_mt then return PositionClass.from_chunk(x) end
            if metatable == pixel_mt then return PositionClass.from_pixel(x) end
        end

        local typeof = type(x)
        if typeof == 'table' then
            local pos = x --- @type MapPosition|Vector
            if pos.x and pos.y then return PositionClass.load(pos) end
            if pos[1] and pos[2] then return PositionClass.from_vector(pos) end
            error('Invalid position')
        end
        ---@cast x double
        if typeof == 'number' then return PositionClass.from_xy(x, y) end
        if typeof == 'string' then return PositionClass.from_string(x) end
        error('Invalid arguments')
    end
    setmetatable(PositionClass, { __call = __call })

    return PositionClass
end
