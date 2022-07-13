--- @alias PackedBoundingBox {[1]: Vector, [2]: Vector, [3]:float?}
--- @class stdlib.AreaClass
--- @overload fun(): stdlib.Area
--- @overload fun(pos: any): stdlib.Area
--- @overload fun(ltx: double, lty: double, rbx: double, rby: double, ori?: float): stdlib.Area
local AreaClass = {}

local Position = require('__stdlib2__.position')
local setmetatable = setmetatable
local abs = math.abs

--- @class stdlib.Area: BoundingBox
--- @field left_top Position
--- @field right_bottom Position
local Area = {}
local area_mt

--- @param ltx double
--- @param lty double
--- @param rbx double
--- @param rby double
--- @param ori? double
--- @param metatable? table
--- @return stdlib.Area
local function new(ltx, lty, rbx, rby, ori, metatable)
    local left_top = Position.new(ltx, lty)
    local right_bottom = Position.new(rbx, rby)
    return setmetatable({ left_top = left_top, right_bottom = right_bottom, orientation = ori }, metatable or area_mt)
end

local function as_area(area)
    if getmetatable(area) == area_mt then return area end
    local typeof = type(area)
    if typeof == table then
        local lt, rb = area.left_top, area.right_bottom
        if lt and rb and lt.x and lt.y and rb.x and rb.y then return area end
        lt, rb = area[1], area[2]
        if lt and rb then
            if lt.x and lt.y and rb.x and rb.y then return { left_top = lt, right_bottom = rb, orientation = area[3] } end
            if lt[1] and lt[2] and rb[1] and rb[2] then
                return { left_top = { x = lt[1], y = lt[2] }, right_bottom = { x = rb[1], y = rb[2] }, orientation = area[3] }
            end
        end
        error('Not convertible to area')
    elseif typeof == 'number' then
        return { left_top = { x = area, y = area }, right_bottom = { x = area, y = area } }
    else
        error('Not convertibe to area')
    end
end

do --[[Conversions]]
    function Area:to_chunk_area()
    end
    function Area:as_chunk_area()
    end
end

do -- Areas
    --- @return stdlib.Area
    function Area:update()
    end
    function Area:copy()
        return AreaClass.from_area(self)
    end
    function Area:normalize()
    end
    function Area:round()
    end
    function Area:ceil()
    end
    function Area:floor()
    end
    function Area:shrink()
    end
    function Area:expand()
    end
    function Area:adjust()
    end
    function Area:offset()
    end
    function Area:translate()
    end
    function Area:rotate()
    end
    function Area:to_surface_size()
    end
end

do -- Positions
    function Area:center()
        local dx = self.right_bottom.x - self.left_top.x
        local dy = self.right_bottom.y - self.left_top.y
        local x, y = self.left_top.x + (dx / 2), self.left_top.y + (dy / 2)
        return Position.from_xy(x, y)
    end

    function Area:right_top()
        return Position.from_xy(self.right_bottom.x, self.left_top.y)
    end

    function Area:left_bottom()
        return Position.from_xy(self.left_top, self.right_bottom.y)
    end
end

do -- numbers

    function Area:width()
        return abs(self.left_top.x - self.right_bottom.x)
    end

    function Area:height()
        return abs(self.left_top.y - self.right_bottom.y)
    end

    --- @return number, number
    function Area:dimensions()
        return self:width(), self:height()
    end

    function Area:perimeter()
        return (self:width() * 2) + (self:height() * 2)
    end

    function Area:size()
        return self:width() * self:height()
    end
end

do -- Booleans

    function Area:inside()
    end

    function Area:contains()
    end

    function Area:empty()
        return self:size() == 0
    end
end

do -- other

    function Area:tostring()
        local lt, rb = tostring(self.left_top), tostring(self.right_bottom)
        local ori = self.orientation and (', orientation = ' .. self.orientation) or ''
        return '{left_top = ' .. lt .. ', right_bottom = ' .. rb .. ori .. '}'
    end

    --- @return PackedBoundingBox
    --- @nodiscard
    function Area:pack()
        return { self.left_top:pack(), self.right_bottom:pack(), self.orientation }
    end
end

do -- metatable stuff
    area_mt = { __index = Area, __tostring = Area.tostring, __concat = require('__stdlib2__.misc').concat }
end

do -- Constructor stuff
    --- @return stdlib.Area
    function AreaClass.load(area)
        Position.load(area.left_top)
        Position.load(area.right_bottom)
        return setmetatable(area, area_mt)
    end

    -- function AreaClass.from_chunk()
    -- end
    -- function AreaClass.from_pixel()
    -- end

    --- @param area stdlib.Area|BoundingBox
    --- @return stdlib.Area
    function AreaClass.from_area(area)
        local left_top = Position.from_position(area.left_top)
        local right_bottom = Position.from_position(area.right_bottom)
        return setmetatable({ left_top = left_top, right_bottom = right_bottom, orientation = area.orientation }, area_mt)
    end

    --- @param array PackedBoundingBox
    --- @return stdlib.Area
    function AreaClass.from_array(array)
        local left_top = Position.from_vector(array[1])
        local right_bottom = Position.from_vector(array[2])
        return setmetatable({ left_top = left_top, right_bottom = right_bottom, orientation = array[3] }, area_mt)
    end
    AreaClass.unpack = AreaClass.from_array

    --- @param area_string string
    --- @return stdlib.Area
    function AreaClass.from_string(area_string)
        return AreaClass.new(load('return ' .. area_string)())
    end

    --- @overload fun(): stdlib.Area
    --- @overload fun(ltx:double, lty:double, rbx:double, rby:double, ori?:float): stdlib.Area
    --- @overload fun(area: any): stdlib.Area
    --- @nodiscard
    function AreaClass.new(ltx, lty, rbx, rby, ori)
        if not ltx then return new(0, 0, 0, 0, ori) end

        local typeof = type(ltx)
        if typeof == 'table' then
            local area = ltx ---@type stdlib.Area|BoundingBox|PackedBoundingBox
            local left_top = Position.from_table(area.left_top or area[1])
            local right_bottom = Position.from_table(area.right_bottom or area[2])
            ori = area.orientation or area[3]
            return setmetatable({ left_top = left_top, right_bottom = right_bottom, orientation = ori }, area_mt)
        end
        ---@cast ltx double
        if typeof == 'number' then return new(ltx, lty, rbx, rby, ori) end
        if typeof == 'string' then return AreaClass.from_string(ltx) end
        error('Not a bounding box or convertible to a bounding box')
    end

    --- Return mutable Area or new Area if not an Area
    --- @overload fun(_: stdlib.AreaClass, ltx: double, lty: double, rbx: double, rby: double, ori?: float): stdlib.Area
    local function __call(_, ltx, lty, rbx, rby, ori)
        if not ltx then return new(0, 0, 0, 0, ori) end

        local metatable = getmetatable(ltx)
        if metatable then if metatable == area_mt then return ltx end end

        local typeof = type(ltx)
        if typeof == 'table' then
            local area = ltx ---@type BoundingBox
            if area.left_top and area.right_bottom then
                area.left_top = Position(area.left_top)
                area.right_bottom = Position(area.right_bottom)
                return setmetatable(area, area_mt)
            end
            if area[1] and area[2] then return AreaClass.new(area) end
            error('Not a bounding box type')
        end
        ---@cast ltx double
        if typeof == 'number' then return new(ltx, lty, rbx, rby, ori) end
        if typeof == 'string' then return AreaClass.from_string(ltx) end
        error('Not a bounding box type or convertible to a bounding box type')
    end
    setmetatable(AreaClass, { __call = __call })

    return AreaClass
end
