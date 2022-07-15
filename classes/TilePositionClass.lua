---@class TilePositionClass: TilePosition
local TilePositionClass = {}
local Position = require("__stdlib2__/classes/PositionClass")

-- ============================================================================
do ---@block TilePosition
  for key, func in pairs(Position) do
    if key:find("^__") then
      TilePositionClass[key] = func
    end
  end
  TilePositionClass.__index = function(self, key) return TilePositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil end
  TilePositionClass.__class = "TilePositionClass"
end

return TilePositionClass

---@class TileVector
---@field [1] integer
---@field [2] integer
