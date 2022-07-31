require("spec/runner")()
local table = require("stdlib2/table")
local spy = require("luassert.spy")

describe("Table Spec", function()
  describe("table.map", function()
    it("should map an empty table to an empty table", function()
      assert.same({}, table.map({}, function(v) return v end))
    end)

    it("should map values", function()
      assert.same({ 10, 20, 30, 40 }, table.map({ 1, 2, 3, 4 }, function(v) return v * 10 end))
    end)

    it("should pass the key and additional arguments", function()
      local fun = function(v, k, arg1) return v * k + arg1 end
      assert.same({ 2, 5, 10, 17 }, table.map({ 1, 2, 3, 4 }, fun, 1))
    end)
  end)

  describe("table.filter", function()
    it("should return an empty table for always false filters", function()
      assert.same({}, table.filter({ 1, 2, 3, 4, 5 }, function() return false end))
    end)

    it("should filter even values as an array", function()
      assert.same({ 2, 4 }, table.filter({ 1, 2, 3, 4, 5 }, function(v) return v % 2 == 0 end, true))
    end)

    it("should filter even values", function()
      assert.same({ [2] = 2, [4] = 4 }, table.filter({ 1, 2, 3, 4, 5 }, function(v) return v % 2 == 0 end))
    end)

    it("should preserve key-value pairs in associative tables", function()
      local tbl = { foo = "bar", baz = "buz", qaz = "quz" }
      assert.same({ qaz = "quz" }, table.filter(tbl, function(v) return v == "quz" end))
    end)

    it("should pass the key and additional arguments", function()
      local fun = function(_, k, arg1) return k % 2 == arg1 end

      assert.same({ 2, 4 }, table.filter({ 1, 2, 3, 4 }, fun, true, 0))
    end)
  end)

  describe("table.for_each", function()
    it("should apply the function to each value", function()
      local obj = { foo = function() end }
      local s = spy.on(obj, "foo")
      table.for_each({ 3 }, obj.foo)
      assert.spy(s).was_called_with(3, 1)

      table.for_each({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, obj.foo)
      assert.spy(s).was.called(10)
    end)

    it("should abort if the function returns true", function()
      local obj = { foo = function(v) return v >= 7 end }
      local s = spy.on(obj, "foo")

      table.for_each({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, obj.foo)
      assert.spy(s).was.called(7)
    end)

    it("should pass the key and additional arguments", function()
      local obj = { foo = function() end }
      local s = spy.on(obj, "foo")
      table.for_each({ 3 }, obj.foo, "bar", "baz")
      assert.spy(s).was_called_with(3, 1, "bar", "baz")
    end)
  end)

  describe("table.slice", function()
    local base = { 10, 20, 30, 40, 50 }

    it("should slice an array from start to #array", function()
      assert.same({ 20, 30, 40, 50 }, table.slice(base, 2))
      assert.same(4, #table.slice(base, 2))
    end)

    it("should slice an array from start to stop", function()
      assert.same({ 20, 30, 40 }, table.slice(base, 2, 4))
      assert.same(3, #table.slice(base, 2, 4))
    end)

    it("should slice an array from start to -stop from end", function()
      assert.same({ 20, 30 }, table.slice(base, 2, -2))
      assert.same(2, #table.slice(base, 2, -2))
    end)

    it("should return an empty array if start is > stop or #tbl", function()
      assert.same({}, table.slice(base, 7, -2))
    end)
  end)

  describe("table.array_merge", function()
    it("should merge arrays", function()
      local tblA = { "foo", "bar", "baz" }
      local tblB = { "quz", "buz" }

      local r = table.array_merge { tblA, tblB }
      assert.equals("foo", r[1])
      assert.equals("bar", r[2])
      assert.equals("baz", r[3])
      assert.equals("quz", r[4])
      assert.equals("buz", r[5])
    end)
  end)

  describe("table.deep_copy", function()
    it("copies tables in tables", function()
      local t = { a = { "foo" }, b = { { bar = 0 } } }
      local copy = table.deep_copy(t)
      assert.same(t, copy)
      t.a[1] = "bar"
      assert.equals("foo", copy.a[1])
    end)

    it("does not copy tables with key __self or metatables", function()
      local mt = {}
      local t = { a = { "foo" }, b = { { bar = 0 } }, entity = { __self = "something", position = { x = 0, y = 1 } } }
      setmetatable(t, mt)
      local copy = table.deep_copy(t)
      assert.equals(t.entity, copy.entity)
      assert.equals(mt, getmetatable(copy))
      t.entity.position.x = 3
      assert.equals(3, copy.entity.position.x)
    end)

    it("copies tables as indices", function()
      local t = {}
      local k = {}
      t[k] = "foo"

      local copy = table.deep_copy(t)
      local i, v = next(copy)
      assert.same(k, i)
      assert.not_equal(k, i)
      assert.equal("foo", v)
    end)

    it("should work with self references", function()
      local t = { a = { "something" } }
      t.mt = t.a

      local copy = table.deep_copy(t)
      assert.same(t, copy)
      assert.equals(copy.mt, copy.a)
      assert.same(t.mt, copy.mt)

      t.a[2] = "something new"
      assert.equals("something new", t.mt[2])
      assert.falsy(copy.a[2])
    end)
  end)

  describe("table.deep_compare", function()
    it("compares arrays", function()
      assert.truthy(table.deep_compare({ 1, 2, 3 }, { 1, 2, 3 }))
      assert.falsy(table.deep_compare({ 1, 2, 3 }, { 1, 2, 3, 4 }))
      assert.falsy(table.deep_compare({ 1, 2, 3 }, { 9, 9, 9 }))
      assert.truthy(table.deep_compare({ 1, "two", 3 }, { 1, "two", 3 }))
      assert.falsy(table.deep_compare({ 1, "two", 3 }, { 1, true, 3 }))
      assert.falsy(table.deep_compare({ 1, "two", 3 }, { 1, "two", 3, "four" }))
      assert.falsy(table.deep_compare({ 1, "two", 3 }, { 9, 9, "nine" }))
    end)

    it("compares nested arrays", function()
      assert.truthy(table.deep_compare({ { 1 }, { 2 }, { 3 } }, { { 1 }, { 2 }, { 3 } }))
      assert.falsy(table.deep_compare({ { 1 }, { 2 }, { 3 } }, { { 1, 2 }, { 3 } }))
      assert.falsy(table.deep_compare({ { 1 }, { 2 }, { 3 } }, { { 9 }, { 9 }, { 9 } }))
      assert.truthy(table.deep_compare({ { 1 }, { "two", 3 } }, { { 1 }, { "two", 3 } }))
      assert.falsy(table.deep_compare({ { 1, "two" }, { 3 } }, { { 1, true }, { 3 } }))
      assert.falsy(table.deep_compare({ 1, { "two" }, 3 }, { 1, { "two" }, 3, { "four" } }))
      assert.falsy(table.deep_compare({ { 1, "two", 3 } }, { { { { 9 }, 9 }, "nine" } }))
    end)

    it("compares tables", function()
      assert.truthy(table.deep_compare({ a = 1, b = 2, c = 3 }, { a = 1, b = 2, c = 3 }))
      assert.falsy(table.deep_compare({ a = 1, b = 2, c = 3 }, { a = 1, b = 2, c = 3, d = 4 }))
      assert.falsy(table.deep_compare({ a = 1, b = 2, c = 3 }, { a = 9, b = 9, c = 9 }))
      assert.truthy(table.deep_compare({ [1] = 1, bravo = "two", [true] = 3 }, { [1] = 1, bravo = "two", [true] = 3 }))
      assert.falsy(table.deep_compare({ [1] = 1, bravo = "two", [true] = 3 }, { [1] = 1, bravo = "two", ["true"] = 3 }))
      assert.falsy(table.deep_compare({ [1] = 1, bravo = "two", [true] = 3 }, { [1] = 1, bravo = "two", [true] = 3, d = 4 }))
      assert.falsy(table.deep_compare({ [1] = 1, bravo = "two", [true] = 3 }, { [1] = 9, bravo = "nine", [true] = 9 }))
    end)

    it("compares nested tables", function()
      assert.truthy(table.deep_compare({ a = { b = 2, c = 3 } }, { a = { b = 2, c = 3 } }))
      assert.falsy(table.deep_compare({ a = { b = 2, c = 3 } }, { a = { b = 2, c = 3 }, d = 4 }))
      assert.falsy(table.deep_compare({ a = { b = 2, c = 3 } }, { a = { b = 2, c = { d = 3 } } }))
      assert.falsy(table.deep_compare({ a = { b = 2, c = 3 } }, { a = { b = 9, c = 9 } }))
      assert.truthy(table.deep_compare({ [1] = 1, bravo = { c = "two", [true] = { 3 } } }, { [1] = 1, bravo = { c = "two", [true] = { 3 } } }))
      assert.falsy(table.deep_compare({ [1] = 1, bravo = { c = "two", [true] = { 3 } } }, { [1] = 1, bravo = { c = { "two" }, ["true"] = 3 } }))
      assert.falsy(table.deep_compare({ [1] = 1, bravo = { c = "two", [true] = { 3 } } }, { [1] = 1, bravo = { c = "two", [true] = { 3 } }, d = 4 }))
      assert.falsy(table.deep_compare({ [1] = 1, bravo = { c = "two", [true] = { 3 } } }, { [1] = 9, bravo = { c = "nine", [true] = { 9 } } }))
    end)

    it("compares empty tables", function()
      assert.truthy(table.deep_compare({}, {}))
      assert.falsy(table.deep_compare({}, { 1 }))
      assert.falsy(table.deep_compare({}, { { { 1, "a" }, "b" } }))
    end)
  end)

  describe("table.array_copy", function() end)
  describe("table.deep_merge", function() end)
  describe("table.for_n_of", function() end)
  describe("table.get_or_insert", function() end)
  describe("table.unique_insert", function() end)
  describe("table.invert", function() end)
  describe("table.partial_sort", function() end)
  describe("table.reduce", function() end)
  describe("table.retrieve", function() end)
  describe("table.shallow_copy", function() end)
  describe("table.shallow_merge", function() end)
  describe("table.splice", function() end)
end)
