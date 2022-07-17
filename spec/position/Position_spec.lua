require("spec.runner")()
local P ---@type Position ---@diagnostic disable-line: unused-local

describe("Position", function()
  before_each(function()
    P = require("__stdlib2__/position")
  end)

  after_each(function()
    package.loaded["__stdlib2__/position"] = nil
    package.loaded["__stdlib2__/area"] = nil
    package.loaded["__stdlib2__/position/classes/TilePositionClass"] = nil
    package.loaded["__stdlib2__/position/classes/ChunkPositionClass"] = nil
    package.loaded["__stdlib2__/position/classes/PixelPositionClass"] = nil
    package.loaded["__stdlib2__/position/classes/MapPositionClass"] = nil
    package.loaded["__stdlib2__/position/classes/PositionClass"] = nil
  end)

  describe("Area	table", function()
    it("Does not have Area", function()
      assert.is_nil(P.Area)
    end)

    it("Does have an Area when area is loaded", function()
      require("__stdlib2__/area")
      assert.is_not_nil(P.Area)
    end)
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
      assert.returned_arguments(2, P.as_tuple{1, 2}--[[@as function]])
    end)

    it("returns a tuple from a table", function()
      assert.returned_arguments(2, P.as_tuple{x = 1, y = 2}--[[@as function]])
      -- assert(assert.all_of(P.as_tuple{1,3}))
    end)

  end)

  describe("as_tuple_any", function() end)
  describe("construct", function() end)
  describe("construct_unsafe", function() end)
  describe("copy", function() end)
  describe("load", function() end)
  describe("new", function() end)
  describe("new_unsafe", function() end)
  describe("zero", function() end)
end)
