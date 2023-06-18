# Charcoal
A cleaner class; similar to Maid, but focused on flexibility and utility. 

Charcoal supports the following types: tables with a Destroy or Disconnect method, coroutines/threads, functions, Instances, Promises, and RBXConnections; however, do note that tables without a Destroy or Disconnect method can be auto-cleaned by Charcoal if they have the property `__char` set to true.

Here's an example of Charcoal in use:
```lua
  local Charcoal = charcoalModule.new()
  local Event = script.BindableEvent.Event
  local newPart = Instance.new('Part', workspace)
  -- events
  local connectionA = Event:Connect(function()
    -- random code
  end)
  local connectionB = Event:Connect(function()
    warn("...")
  end)
  -- showcase of instance/event destruction and construction
  local secondCharcoal = Charcoal:Construct(charcoalModule.new) -- able to construct items and attach them to the charcoal
  Charcoal:Add(newPart, connectionA, connectionB) -- able to add multiple items in one call
  -- promises
  Charcoal:AddPromise(Promise.new(function(a, b) -- compatibility with promises; note that AddPromise returns the same promise
    warn('hi')
  end)
  -- threads
  local coroutineNew = coroutine.create(function()
  end)
  coroutine.resume(coroutineNew)
  Charcoal:Add(coroutineNew) -- compatibility with threads
  -- main destruction method
  Charcoal:Scorch() -- destroys all items under charcoal-so basically newPart, connectionA, and connectionB, secondCharcoal, the thread, and the promise
```
