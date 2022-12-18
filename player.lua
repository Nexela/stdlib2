--- @class Player
local Player = {}

--- @param event EventData.on_player_created
local function on_player_created(event)
  global._players = global._players or {}
  local index = event.player_index
  local player = game.get_player(event.player_index)
  if not player then return end

  local pdata = {
    index = index,
    name = player.name,
    created = game.tick
  }

end

function Player.get_player(player_index)
  return game.get_player(player_index), global._players[player_index] or on_player_created { player_index = player_index }
end

function Player.get_pdata(player_index)
  return global._players[player_index] or on_player_created { player_index = player_index }
end

function Player.get_last_player()
  return game.get_player(global._last_player)
end

function Player.set_last_player(player_index)
  global._last_player = player_index
end

Player.Events = {}
Player.CoreEvents = {}

Player.Events[defines.events.on_player_created] = on_player_created

--- @param event EventData.on_player_removed
Player.Events[defines.events.on_player_removed] = function(event)
  global._players[event.player_index] = nil
  global._last_player = nil
end

--- @param event EventData.on_player_joined_game
Player.Events[defines.events.on_player_joined_game] = function(event)
  global._last_player = nil
end

--- @param event EventData.on_player_left_game
Player.Events[defines.events.on_player_left_game] = function(event)
  global._last_player = nil
end

--- @param event EventData.on_player_changed_force
Player.Events[defines.events.on_player_changed_force] = function(event)
end

Player.CoreEvents["on_init"] = function(event)
  global._players = {}
  for _, player in pairs(game.players) do
    Player.Events.on_player_created { player_index = player.index }
  end
end

return Player
