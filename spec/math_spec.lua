require("spec/runner")()

local math = require("__stdlib2__/math")

describe("Math", function()
  it("should clamp", function()
    assert.equals(1, math.clamp(1.25))
    assert.equals(0, math.clamp(-1.25))
    assert.equals(4, math.clamp(4, 1, 5))
    assert.equals(4, math.clamp(5, 1, 4))
    assert.equals(2, math.clamp(1, 2, 4))
  end)

  it("should round to a divisor", function()
    assert.near(6.5, math.round(6.51, .1), .001)
    assert.near(6.6, math.round(6.56, .1), .001)
  end)

  it("should floor to a divisor", function()
    assert.equals(6.5, math.floored(6.51, .1))
    assert.equals(6.5, math.floored(6.55, .1))
  end)

  it("should ceil to a divisor", function()
    assert.near(6.6, math.ceiled(6.51, .1), .001)
    assert.near(6.6, math.ceiled(6.55, .1), .001)
  end)

  it("should round", function()
    assert.equals(9, math.round(9.4))
    assert.equals(10, math.round(9.5))
  end)

  it("should sum", function()
    assert.equals(10, math.sum { 2, 5, 3 })
    assert.equals(20, math.sum { 2, 5, 3 } + math.sum { 2, 5, 3 })
  end)

  it("should arithmetic_mean/avg/average", function()
    assert.equals(5, math.mean { 0, 10 })
    assert.equals(5, math.mean { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
  end)

  it("should return the maximum", function()
    assert.equals(9, math.maximum { 8, 4, 7, 9 })
  end)

  it("should return the minimum", function()
    assert.equals(4, math.minimum { 8, 4, 7, 9 })
  end)

  it("should return a range", function()
    assert.equals(5, math.range { 8, 4, 7, 9 })
  end)

  it("should return the sign multiplier", function()
    assert.equals(1, math.sign(1))
    assert.equals(-1, math.sign(-1))
    assert.equals(0, math.sign(0))
    assert.equals(-0, math.sign(0))
  end)

  it("should lerp", function()
    assert.equals(5, math.lerp(0, 10, 0.5))
    assert.equals(10, math.lerp(0, 10, 1))
    assert.equals(0, math.lerp(0, 10, 0))
  end)

end)
