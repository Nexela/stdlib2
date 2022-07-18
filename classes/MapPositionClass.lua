---@class MapPositionClass: PositionClass, MapPosition.0
---@field new fun(self: MapPositionClass, position: AnyPosOrVec): MapPositionClass
---@field construct fun(self: MapPositionClass, x: double, y: double): MapPositionClass
local MapPositionClass = {}
MapPositionClass.Class = MapPositionClass
MapPositionClass.__class = "MapPosition"
local PositionClass = require("__stdlib2__/classes/PositionClass")
local ERROR = require("__stdlib2__/config").error

local math_floor = math.floor
local table_concat = table.concat

-- ============================================================================
do ---@block MapPosition

  ---@param surface_name? string
  ---@nodiscard
  function PositionClass:to_gps_tag(surface_name)
    return table_concat { "[gps=", self.x, ",", self.y, surface_name and ("," .. surface_name) or "", "]" }
  end

  ---@return ChunkPositionClass
  function MapPositionClass:to_chunk_position()
    local chunk_pos = PositionClass.copy_as(self, PositionClass.ChunkPosition)
    chunk_pos.x, chunk_pos.y = math_floor(chunk_pos.x / 32), math_floor(chunk_pos.y / 32)
    return chunk_pos
  end

  ---@return TilePositionClass
  function MapPositionClass:to_tile_position()
    local tile_pos = PositionClass.copy_as(self, PositionClass.TilePosition)
    tile_pos.x, tile_pos.y = math_floor(tile_pos.x), math_floor(tile_pos.y)
    return tile_pos
  end

  ---@return PixelPositionClass
  function MapPositionClass:to_pixel_position()
    local pixel_pos = PositionClass.copy_as(self, PositionClass.PixelPosition)
    pixel_pos.x, pixel_pos.y = pixel_pos.x * 32, pixel_pos.y * 32
    return pixel_pos
  end

  ---Expands from the center outwards towards the vector
  ---@param vector? AnyPosOrVec|number
  ---@return AreaClass
  function MapPositionClass:to_area(vector)
    if not PositionClass.Area then error(ERROR.no_area) end
    return PositionClass.Area:from_position(self, vector)
  end

  ---Expands from the position outwards towards the vector
  ---@param vector? AnyPosOrVec|number
  ---@return AreaClass
  function MapPositionClass:to_area_left_top(vector)
    if not PositionClass.Area then error(ERROR.no_area) end
    return PositionClass.Area:from_left_top(self, vector)
  end

  --- Turn a position into a chunks area
  ---@return AreaClass
  function MapPositionClass:to_chunk_area()
    if not PositionClass.Area then error(ERROR.no_area) end
    local ltx, lty = self.x, self.y
    ltx, lty = ltx - ltx % 32, lty - lty % 32
    local rbx, rby = ltx + 32, lty + 32
    return PositionClass.Area:construct(ltx, lty, rbx, rby)
  end

  ---@return AreaClass
  function MapPositionClass:to_chunk_tile_area()
    if not PositionClass.Area then error(ERROR.no_area) end
    local ltx, lty = self.x, self.y
    ltx, lty = ltx - ltx % 32, lty - lty % 32
    local rbx, rby = ltx + 31, lty + 31
    return PositionClass.Area:construct(ltx, lty, rbx, rby)
  end

end
-- ============================================================================
do ---@block Metamethods


  MapPositionClass.__index = function(self, key)
    return MapPositionClass[key] or PositionClass[key] or (key == 1 and self.x) or (key == 2 and self.y) or nil
  end

  for key, f in pairs(PositionClass) --[[@as fun():string, function]]do
    if key:find("^__") and not MapPositionClass[key] then
      MapPositionClass[key] = f ---@diagnostic disable-line: no-unknown
    end
  end

end
-- ============================================================================
return MapPositionClass

---@class MapPositionClass
---@operator call(MapPositionClass):MapPositionClass
---@operator add (double|AnyPosOrVec):MapPositionClass
---@operator unm (MapPositionClass):MapPositionClass
---@operator mul (double|AnyPosOrVec):MapPositionClass
---@operator sub (double|AnyPosOrVec):MapPositionClass
---@operator div (double|AnyPosOrVec):MapPositionClass
---@operator mod (MapPositionClass):MapPositionClass
