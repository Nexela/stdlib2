require("spec.runner")()
local Area = require("__stdlib2__/area")
local zero
local zeroOri

describe("Area", function()
  before_each(function()
    zero = { left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 } }
    zeroOri = { left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 }, orientation = 0.5 }
  end)

  describe("Area:new", function()
    describe("should", function()
      it("create from 0 parameters", function()
        assert.same(Area:new(), zero)
      end)

      it("create from table parameter", function()
        assert.not_equal(zero, Area:new(zero))
        assert.same(zero, Area:new { left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 } })
        assert.same(zero, Area:new { left_top = { 0, 0 }, right_bottom = { 0, 0 } })
        assert.same(zeroOri, Area:new { { 0, 0 }, { 0, 0 }, .5 })
      end)

      pending("create from a string parameter", function()
        assert.same(zero, Area:new("{left_top = {x = 0, y = 0}, right_bottom = {x = 0, y = 0}}"))
        assert.same(zero, Area:new("{left_top = {0, 0}, right_bottom = {0, 0}}"))
        assert.same(zeroOri, Area:new("{{0, 0}, {0, 0}, .5}"))
      end)

      it("create from a number parameter", function()
        assert.same(zero, Area:construct(0, 0, 0, 0))
        assert.same(zeroOri, Area:construct(0, 0, 0, 0, .5))
      end)

      it("error", function()
        ---@diagnostic disable: discard-returns, redundant-parameter
        assert.has_error(function() Area:new {} end)
        assert.has_error(function() Area:new { {}, {} } end)
        assert.has_error(function() Area:new(0) end)
        assert.has_error(function() Area:new(0, nil, nil, nil, .5) end)
        ---@diagnostic enable: discard-returns
      end)
    end)
  end)

  describe("__call", function()

  end)

  describe("tostring", function()
    it("should print a string", function()
      assert.same("{ left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 } }", Area:new(zero):to_string())
      assert.same("{ left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 }, orientation = 0.5 }", Area:new(zeroOri):to_string())
    end)
  end)

  describe("pack", function()
    it("should pack into an array", function()
      assert.same({ 0, 0, 0, 0 }, Area:new(zero):pack())
    end)
  end)

  describe("metamethods", function()
    it("__tostring", function()
      assert.same("{ left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 } }", tostring(Area:new(zero)))
      assert.same("{ left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 }, orientation = 0.5 }", tostring(Area:new(zeroOri)))
    end)
    it("__concat", function()
      assert.same("Over Here! { left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 } }", "Over Here! " .. Area:new(zero))
      assert.same("Over Here! { left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 }, orientation = 0.5 }", "Over Here! " .. Area:new(zeroOri))
    end)
  end)
end)
