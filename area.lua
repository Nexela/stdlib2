local Area

local area_mt

local function new()
end

local function as_area(area)
end

function Area.new()

    return new()
end

function Area.load(area)
    return setmetatable(area, area_mt)
end

return Area
