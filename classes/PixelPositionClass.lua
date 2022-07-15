---@class PixelPositionClass: PixelPosition
local PixelPositionClass = {}
local Position = require("__stdlib2__/classes/PositionClass")

-- ============================================================================
do ---@block PixelPosition
  for key, func in pairs(Position) do
    if key:find("^__") then
      PixelPositionClass[key] = func
    end
  end
  PixelPositionClass.__index = function(self, key) return PixelPositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  PixelPositionClass.__class = "PixelPositionClass"
end

return PixelPositionClass

---@class PixelPosition
---@field x double
---@field y double
---@field [1] double
---@field [2] double

---@class PixelVector
---@field [1] double
---@field [2] double
