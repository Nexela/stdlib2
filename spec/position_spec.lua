require("spec.runner")()
local P = require("__stdlib2__/area").Position

describe("MapPositionClass", function()
  randomize(false)
  it("should be a class", function()
    assert.is_true(type(P.Map) == "table")
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
end)
