require("spec.runner")()
local P = require("__stdlib2__/area").Position --- @diagnostic disable-line: unused-local

describe("PositionClass", function()
  it("should be a class", function()
    assert.is_true(type(P.MapPosition) == "table")
  end)

  describe(".center", function()
    it("should return the center of the tile", function()
      local p = P:construct(1, 1):center()
      assert.is_true(type(p) == "table")
      assert.is_true(p.x == 1.5 and p.y == 1.5)
    end)
  end)

  describe(".floor", function()
    it("should return the floor of the tile", function()
      local p = P:construct(1.5, 1.5):floor()
      assert.is_true(type(p) == "table")
      assert.is_true(p.x == 1 and p.y == 1)
    end)
  end)

  describe(".ceil", function()
    it("should return the ceil of the tile", function()
      local p = P:construct(1.5, 1.5):ceil()
      assert.is_true(type(p) == "table")
      assert.is_true(p.x == 2 and p.y == 2)
    end)

    it("should ceil to x decimal places", function()
      local p = P:construct(1.5542, 2.552)
      assert.is_true(p:ceil(.01) == P:construct(1.56, 2.56))
    end)
  end)

  describe("Area	table: 0x557905101550", function() end)
  describe("ChunkPosition	table: 0x557905190d40", function() end)
  describe("MapPosition	table: 0x55790518e090", function() end)
  describe("PixelPosition	table: 0x55790513e070", function() end)
  describe("TilePosition	table: 0x557905158fc0", function() end)
  describe("__add", function() end)
  describe("__call", function() end)
  describe("__concat", function() end)
  describe("__div", function() end)
  describe("__eq", function() end)
  describe("__mod", function() end)
  describe("__mul", function() end)
  describe("__newindex", function() end)
  describe("__sub", function() end)
  describe("__tostring", function() end)
  describe("__unm", function() end)
  describe("abs", function() end)
  describe("add", function() end)
  describe("angle", function() end)
  describe("as_chunk_position", function() end)
  describe("as_map_position", function() end)
  describe("as_pixel_position", function() end)
  describe("as_tile_position", function() end)
  describe("as_tuple", function() end)
  describe("as_tuple_any", function() end)
  describe("atan2", function() end)
  describe("ceil", function() end)
  describe("center", function() end)
  describe("construct", function() end)
  describe("construct_as", function() end)
  describe("copy", function() end)
  describe("copy_as", function() end)
  describe("cross", function() end)
  describe("direction_to", function() end)
  describe("distance", function() end)
  describe("distance_squared", function() end)
  describe("divide", function() end)
  describe("dot", function() end)
  describe("equals", function() end)
  describe("flip", function() end)
  describe("flip_x", function() end)
  describe("flip_y", function() end)
  describe("floor", function() end)
  describe("inside", function() end)
  describe("is_zero", function() end)
  describe("len", function() end)
  describe("len_squared", function() end)
  describe("lerp", function() end)
  describe("manhattan_distance", function() end)
  describe("modulo", function() end)
  describe("multiply", function() end)
  describe("new", function() end)
  describe("new_as", function() end)
  describe("normalize", function() end)
  describe("orientation_to", function() end)
  describe("pack", function() end)
  describe("round", function() end)
  describe("subtract", function() end)
  describe("swap", function() end)
  describe("to_gps_tag", function() end)
  describe("to_string", function() end)
  describe("to_string_tuple", function() end)
  describe("to_string_vector", function() end)
  describe("translate", function() end)
  describe("trim", function() end)
  describe("unpack", function() end)
  describe("update", function() end)
end)
