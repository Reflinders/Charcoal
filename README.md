# Charcoal
A cleaner class; similar to Maid, but with several modifications. 

Usage Example:
```lua
  local Charcoal = require(CharcoalModule).new()
  local Event = script.BindableEvent.Event
  local newPart = Instance.new('Part', workspace)
  --/ ...
  local connectionA = Event:Connect(function()
    -- random code
  end)
  local connectionB = Event:Connect(function()
    warn("...")
  end)
  --
  Charcoal:Add(newPart, connectionA, connectionB) -- able to add multiple items in one call
  --
  Charcoal:Scorch() -- destroys all items under charcoal-so basically newPart, connectionA, and connectionB
```
