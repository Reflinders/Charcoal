# Charcoal
A cleaner class; similar to Maid, but with several modifications. 

Charcoal supports the following types: tables with a Destroy or Disconnect method, coroutines/threads, functions, Instances, and RBXConnections; however, do note that tables without a Destroy or Disconnect method can be auto-cleaned by Charcoal if they have the property `__char` set to true.

Here's an example of Charcoal in use:
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
