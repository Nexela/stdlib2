--- @class Surface
local Surface = {}

--- Gets the area which covers the entirety of a given surface.
--- @param surface LuaSurface
--- @return BoundingBox
function Surface.get_surface_bounds(surface)
  local x1, y1, x2, y2 = 0, 0, 0, 0

  for chunk in surface.get_chunks() do
    if chunk.x < x1 then
      x1 = chunk.x
    elseif chunk.x > x2 then
      x2 = chunk.x
    end
    if chunk.y < y1 then
      y1 = chunk.y
    elseif chunk.y > y2 then
      y2 = chunk.y
    end
  end
  local lt = { x = x1 * 32, y = y1 * 32 }
  local rb = { x = x2 * 32, y = y2 * 32 }
  return { left_top = lt, right_bottom = rb }
end

--- Sets the daytime transition thresholds on a given surface.
--- @param surface LuaSurface The surface for which to set the thresholds.
--- @param morning float Daytime to begin transition from dark to light.
--- @param dawn float Daytime to finish transition from dark to light.
--- @param dusk float Daytime to begin transition from light to dark.
--- @param evening float Daytime to finish transition from light to dark.
--- @peturn boolean true if the thresholds were set, false if there was an error.
function Surface.set_daytime_thresholds(surface, morning, dawn, dusk, evening)
  return pcall(
    function()
      surface.dusk = 0
      surface.evening = .0000000001
      surface.morning = .0000000002
      surface.dawn = dawn
      surface.morning = morning
      surface.evening = evening
      surface.dusk = dusk
    end
  )
end

return Surface
