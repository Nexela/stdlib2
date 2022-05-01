local Color

local col_mt

local function new()
end

local function as_color(col)
end

function Color.new()

    return new()
end

function Color.load(col)
    return setmetatable(col, col_mt)
end

return Color
