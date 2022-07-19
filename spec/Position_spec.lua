require("spec.runner")()
---@diagnostic disable: discard-returns, unused-local
local match = require("luassert.match") ---@type assert.match
local mock = require("luassert.mock") ---@type assert.mock
local spy = require("luassert.spy") ---@type assert.spy

describe("Position loads correctly", function()
  after_each(function()
    package.loaded["__stdlib2__/position"] = nil
    package.loaded["__stdlib2__/area"] = nil
    package.loaded["__stdlib2__/classes/TilePositionClass"] = nil
    package.loaded["__stdlib2__/classes/ChunkPositionClass"] = nil
    package.loaded["__stdlib2__/classes/PixelPositionClass"] = nil
    package.loaded["__stdlib2__/classes/MapPositionClass"] = nil
    package.loaded["__stdlib2__/classes/PositionClass"] = nil
  end)

  it("Does not have Area", function()
    local P2 = require("__stdlib2__/position")
    assert.is_nil(P2.Area)
  end)

  it("Does have an Area when area is loaded", function()
    local P2 = require("__stdlib2__/area").Position
    assert.is_not_nil(P2.Area)
  end)

  it("Does not have Area", function()
    local P2 = require("__stdlib2__/position")
    assert.is_nil(P2.Area)
  end)
end)

describe("Position", function()
  local ERROR = require("__stdlib2__/config").error
  local P = require("__stdlib2__/position")
  local new_spy = spy.on(P, "new")

  before_each(function()
    new_spy:clear()
  end)

  describe("ChunkPosition table", function()
    it("Has a ChunkPosition Table", function()
      assert.is_not_nil(P.ChunkPosition)
      assert.is_equal(P.ChunkPosition, require("__stdlib2__/classes/ChunkPositionClass"))
    end)
  end)

  describe("MapPosition table", function()
    it("Has a MapPosition Table", function()
      assert.is_not_nil(P.MapPosition)
      assert.is_equal(P.MapPosition, require("__stdlib2__/classes/MapPositionClass"))
    end)
  end)

  describe("PixelPosition table", function()
    it("Has a PixelPosition Table", function()
      assert.is_not_nil(P.PixelPosition)
      assert.is_equal(P.PixelPosition, require("__stdlib2__/classes/PixelPositionClass"))
    end)
  end)

  describe("TilePosition	table", function()
    it("Has a TilePosition Table", function()
      assert.is_not_nil(P.TilePosition)
      assert.is_equal(P.TilePosition, require("__stdlib2__/classes/TilePositionClass"))
    end)
  end)

  describe("as_tuple", function()
    it("returns a tuple from a vector", function()
      assert.returned_arguments(2, P:as_tuple { 1, 2 }--[[@as function]] )
    end)

    it("returns a tuple from a table", function()
      assert.returned_arguments(2, P:as_tuple { x = 1, y = 2 }--[[@as function]] )
      local s = spy.on(P, "as_tuple")
      P:as_tuple { x = 1, y = 2 }
      assert.spy(s).was_called(1)
      assert.spy(s).returned_with(1, 2)
      assert.spy(s).was_called_with(P, match.is_table())
    end)
  end)

  describe("load", function()
    it("loads into the same table", function()
      local pos = { x = 1, y = 2 }
      assert.is_rawequal(pos, P:load(pos))
      assert.equal(P.MapPosition, getmetatable(pos))
    end)
    it("call loads into the same table", function()
      local pos = { x = 1, y = 2 }
      assert.is_rawequal(pos, P(pos))
      assert.equal(P.MapPosition, getmetatable(pos))
    end)
  end)

  describe("new", function()
    it("returns a MapPosition", function()
      local position = P:new { 1, 2 }
      assert.is_same({ x = 1, y = 2 }, position)
      assert.is_equal(P.MapPosition, position.Class)
      assert.is_equal(P.MapPosition, getmetatable(position))
      assert.is_equal("MapPosition", position.__class)
      assert.spy(new_spy).was_called(1)
      assert.spy(new_spy).was_called_with(P, match.is_table())

      assert.has_error(function() P:new("string") end, ERROR.not_position_table)
      assert.has_error(function() P:new {} end, ERROR.not_position_table)
      assert.has_error(function() P:new { x = 1, z = 2 } end, ERROR.not_position_table)
      assert.has_error(function() P:new { x = "1", y = 2 } end, ERROR.invalid_values_numbers)
      assert.spy(new_spy).was_called(5)
    end)

    it("errors when not called with self", function()
      assert.has_error(function() P.new { 1, 2 } end, ERROR.called_without_self)
      assert.has_no_error(function() P.new(P, { 1, 2 }) end)
      assert.spy(new_spy).was_called(2)
    end)

    it("errors on bad class", function()
      assert.has_error(function() P:new({ x = 1, y = 2 }, {}) end, ERROR.not_position_class)
      assert.has_error(function() P:new({ x = 1, y = 2 }, { __class = "fail" }) end, ERROR.not_position_class)
    end)

    it("returns a ChunkPosition", function()
      local position = P:new({ 1, 2 }, P.ChunkPosition)
      assert.is_same({ x = 1, y = 2 }, position)
      assert.is_equal(P.ChunkPosition, position.Class)
      assert.is_equal(P.ChunkPosition, getmetatable(position))
      assert.is_equal("ChunkPosition", position.__class)

      assert.has_error(function() P:new("string", P.ChunkPosition) end, ERROR.not_position_table)
      assert.has_error(function() P:new({}, P.ChunkPosition) end, ERROR.not_position_table)
      assert.has_error(function() P:new({ x = 1, z = 2 }, P.ChunkPosition) end, ERROR.not_position_table)

      assert.has_error(function() P:new({ x = 1, y = 2.5 }, P.ChunkPosition) end, ERROR.invalid_values_integers)
    end)
  end)

  describe("zero", function()
    it("returns a zero vector", function()
      assert.is_same({ x = 0, y = 0 }, P:zero())
    end)

    it("is a new zero vector every time", function()
      local zero = P:zero()
      assert.is_same({ x = 0, y = 0 }, zero)
      assert.not_rawequal(zero, P:zero())
    end)
  end)

  describe("new_unsafe", function() end)
  describe("as_tuple_any", function() end)
end)
