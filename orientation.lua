---Functions for working with orientations.
---@class Orientation: RealOrientation
local Orientation = {}

Orientation.north     = defines.direction.north / 8 --[[@as RealOrientation]]
Orientation.east      = defines.direction.east / 8 --[[@as RealOrientation]]
Orientation.west      = defines.direction.west / 8 --[[@as RealOrientation]]
Orientation.south     = defines.direction.south / 8 --[[@as RealOrientation]]
Orientation.northeast = defines.direction.northeast / 8 --[[@as RealOrientation]]
Orientation.northwest = defines.direction.northwest / 8 --[[@as RealOrientation]]
Orientation.southeast = defines.direction.southeast / 8 --[[@as RealOrientation]]
Orientation.southwest = defines.direction.southwest / 8 --[[@as RealOrientation]]

local floor = math.floor

---Returns a 4way or 8way direction from an orientation.
---@param orientation RealOrientation
---@param eight_way boolean
---@return defines.direction
---@nodiscard
function Orientation.to_direction(orientation, eight_way)
  local ways = eight_way and 8 or 4
  local mod = eight_way and 1 or 2
  return floor(orientation * ways + 0.5) % ways * mod --[[@as defines.direction]]
end

---Returns the opposite orientation.
---@param orientation RealOrientation
---@return RealOrientation
---@nodiscard
function Orientation.opposite(orientation)
  return (orientation + 0.5) % 1.0
end

---Add two orientations together.
---@param orientation1 RealOrientation
---@param orientation2 RealOrientation
---@return RealOrientation
---@nodiscard
function Orientation.add(orientation1, orientation2)
  return (orientation1 + orientation2) % 1.0
end

---Multiply two orientations together.
---@param orientation1 RealOrientation
---@param orientation2 RealOrientation
---@return RealOrientation
---@nodiscard
function Orientation.multiply(orientation1, orientation2)
  return (orientation1 * orientation2) % 1.0
end

return Orientation
