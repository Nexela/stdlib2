--- @class stdlib.position_class
--- @overload fun(pos: any): stdlib.Position
--- @overload fun(x: double, y?: double): stdlib.Position
local Position = {}

local floor = math.floor

--- @class stdlib.Position: MapPosition
local position = {}
local position_mt

--- @class stdlib.ChunkPosition: ChunkPosition
local chunk = { update = position.update, normalize = position.normalize, normalized = position.normalized }
local chunk_mt

--- @class PixelPosition
--- @field x double
--- @field y double
--- @class stdlib.PixelPosition: MapPosition
local pixel = { update = position.update, normalize = position.normalize, normalized = position.normalized }
local pixel_mt

--- @param x double
--- @param y double
--- @param metatable? table
local function new(x, y, metatable)
    return setmetatable({ x = x, y = y }, metatable or position_mt)
end

local function as_position(pos)
    if pos.x and pos.y then return pos end
    if pos[1] and pos[2] then return { x = pos[1], y = pos[2] } end
    return Position.new(pos)
end

function position:update(x, y)
    self.x = x
    self.y = y
    return self
end

function position:copy()
    return setmetatable({x = self.x, y = self.y}, getmetatable(self))
end

--- @return stdlib.ChunkPosition
function position:to_chunk()
    return new(floor(self.x / 32), floor(self.y / 32), chunk_mt)
end

--- @return stdlib.ChunkPosition
function position:as_chunk()
    return new(self.x, self.y, chunk_mt)
end

--- @return stdlib.PixelPosition
function position:to_pixel()
    return new(self.x / 32, self.y / 32, pixel_mt)
end

--- @return stdlib.PixelPosition
function position:as_pixel()
    return new(self.x, self.y, pixel_mt)
end

function position:normalize()
    return new((self.x * 0.00390625) / 0.00390625, (self.y * 0.00390625) / 0.00390625, getmetatable(self))
end

function position:normalized()
    self.x = (self.x * 0.00390625) / 0.00390625
    self.y = (self.y * 0.00390625) / 0.00390625
    return self
end

function position:floor() end
function position:floored() end
function position:ceil() end
function position:ceiled() end
function position:add() end
function position:subtract() end
function position:distance() end
function position:tile_pos() end
function position:lerp() end
function position:offset_from() end
function position:translate() end
function position:random() end


function position:direction_to() end
function position:orientation_to() end

function position:expand() end
function position:to_area() end
function position:to_chunk_area() end
function position:to_tile_area() end
function position:incrementer() end

function position:pack() end
function position:unpack() end

function position:inside() end
function position:equals() end


function position:atan2() end
function position:angle() end

function position:tostring()
    return 'x = ' .. self.x .. ', ' .. 'y = ' .. self.y
end

do -- Metamethod stuff
    pixel_mt = { __index = pixel, __tostring = position.tostring }
    position_mt = { __index = position, __tostring = position.tostring }
    chunk_mt = { __index = chunk, __tostring = position.tostring }
end

do -- Constructor stuff
    --- @return stdlib.Position
    function Position.load(pos)
        return setmetatable(pos, position_mt)
    end

    --- @param pos_string string
    --- @return stdlib.Position
    function Position.from_string(pos_string)
        return Position.new(load('return ' .. pos_string)())
    end

    --- @param chunk_pos stdlib.ChunkPosition|ChunkPosition
    --- @return stdlib.ChunkPosition
    function Position.from_chunk(chunk_pos)
        local x, y = (floor(chunk_pos.x) * 32), (floor(chunk_pos.y) * 32)
        return new(x, y)
    end

    --- @param pixel_pos stdlib.PixelPosition|PixelPosition
    --- @return stdlib.PixelPosition
    function Position.from_pixel(pixel_pos)
        local x = pixel_pos.x / 32
        local y = pixel_pos.y / 32
        return new(x, y)
    end

    --- @param x double
    --- @param y double
    --- @return stdlib.Position
    --- @overload fun(pos: table): stdlib.Position
    function Position.new(x, y)
        if not x then return new(0, 0) end

        local typeof = type(x)
        if typeof == 'table' then
            local pos = x ---@type MapPosition
            x, y = pos.x or pos[1], pos.y or pos[2]
            assert(x and y)
            return new(x, y)
        end
        if typeof == 'number' then return new(x, y or 0) end
        --- @cast x string
        if typeof == 'string' then return Position.from_string(x) end
    end

    --- Return mutable MapPosition or new MapPosition if not a MapPosition
    --- @return stdlib.Position
    local function __call(_, x, y)
        if not x then return new(0, 0, position_mt) end

        local metatable = getmetatable(x)
        if metatable then
            if metatable == position_mt then return x end
            if metatable == chunk_mt then return Position.from_chunk(x) end
            if metatable == pixel_mt then return Position.from_pixel(x) end
        end
        local typeof = type(x)
        if typeof == 'table' then
            if x.x and x.y then return setmetatable(x, position_mt) end
            if x[1] and x[2] then return new(x, y, position_mt) end
        end
        if typeof == 'number' then return new(x, x or y, position_mt) end
        if typeof == 'string' then return Position.from_string(x) end
        return Position.new(x, y)
    end
    setmetatable(Position, { __call = __call })

    local a = Position()
    print(a)

    return Position
end
