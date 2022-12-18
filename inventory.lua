--- @class Inventory
local Inventory = {}

--- Given a function, apply it to each slot in the given inventory.
--- Passes the index of a slot as the second argument to the given function.
---<p>Iteration is aborted if the applied function returns true for any element during iteration.
--- @param inventory LuaInventory
--- @param start_index integer
--- @param func fun(stack:LuaItemStack, index:integer, ...?): boolean
--- @param ...? any Additional arguments passed to the callback function.
--- @return LuaItemStack? #The LuaItemStack where the iteration was aborted or nil if not aborted.
--- @return integer
function Inventory.each(inventory, start_index, func, ...)
  local index
  local inventory_size = #inventory
  start_index = (start_index <= #inventory) and start_index or 1
  for i = start_index, #inventory do
    if func(inventory[i], i, ...) then
      index = i
      break
    end
  end
  return index and inventory[index], index and index
end

--- Given a function, apply it to each slot in the given inventory.
--- Passes the index of a slot as the second argument to the given function.
---<p>Iteration is aborted if the applied function returns true for any element during iteration.
---<p>Iteration is performed from last to first in order to support dynamically sized inventories.
--- @param inventory LuaInventory
--- @param start_index? integer
--- @param func fun(stack:LuaItemStack, index:integer, ...?): boolean
--- @param ...? any Additional arguments passed to the callback function.
--- @return LuaItemStack? #The LuaItemStack where the iteration was aborted or nil if not aborted.
--- @return integer
function Inventory.each_reverse(inventory, start_index, func, ...)
  local index
  local inventory_size = #inventory
  start_index = (start_index <= #inventory) and start_index or #inventory
  for i = start_index, 1, -1 do
    if func(inventory[i], i, ...) then
      index = i
      break
    end
  end
  return index and inventory[index], index and index
end

return Inventory
