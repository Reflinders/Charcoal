--/ ... Charcoal; a clean-up class
-- Made by @Reflinders on github
-- V.1.0.2; Last updated 6/17 
-- 
-- / ...

local Charcoal = {}; Charcoal.__index = Charcoal
export type Cleaner = typeof(setmetatable({}, Charcoal)) & {
	_items : {[number]:any?}
}
--/ ...
function Charcoal:__newindex(index : number?, newValue : any)
	local items, oldValue = self._items, self[index]
	if oldValue then
		self:Handle(oldValue)
	end
	items[if typeof(index) == 'number' then index else #items + 1] = newValue
end
--/ ...
function Charcoal:Handle(itemToHandle : any, items : {}, index : number)
	local rblxCo = "RBXScriptConnection"
	local typeOf = typeof(itemToHandle)
	local methods
	--/ ...
	methods = {
		['table'] = function(item)
			if item.Destroy then
				item:Destroy()
			elseif item.Disconnect then
				item:Disconnect(); items[index] = nil
			elseif item.__char then
				for subIndex, subItem in pairs(item) do
					if methods[typeof(subItem)] then
						self:Handle(subItem, item, subIndex)
					else
						item[subIndex] = nil
					end
				end
			end
		end;
		['Instance'] = function(item)
			item:Destroy()
		end;
		['function'] = function(item)
			item(); items[index] = nil
		end;
		[rblxCo] = function(item)
			item:Disconnect()
		end;
		['thread'] = function(item)
			local success = pcall(coroutine.close, item)
			if not success then
				pcall(task.cancel, item)
			end
		end,
	}
	local methodAvailable = methods[typeof(itemToHandle)]; if methodAvailable then
		methodAvailable(itemToHandle)
	end
end
function Charcoal:Construct(constructor : ()->(), ...) : {}|number
	local newObject = constructor(...)
	local index = self:Add(newObject)
	return newObject, index
end
function Charcoal:Add(...) : number -- returns numid
	local ids = {}
	for _, item in ipairs({...}) do
		assert(item ~= nil, "Charcoal: Error-- Item is nil")
		local ind = #self._items + 1; if typeof(item) == 'table' and not item.__char and not item.Destroy then
			warn("Charcoal: attempt to add object(table) without a .Destroy method or __char")	
		end
		self._items[ind] = item
		ids[#ids + 1] = ind
	end
	return unpack(ids)
end
function Charcoal:Scorch() -- destroy all items
	local rblxCo = "RBXScriptConnection"
	local items = self._items; for index, item in pairs(items) do
		if typeof(item) == rblxCo then
			item:Disconnect(); items[index] = nil
		end 
	end
	--/ ...
	local index, item = next(items); while item ~= nil do
		self:Handle(item, items, index)
		--/ ...
		items[index] = nil; index, item = next(items)
	end
end
--/ ...
function Charcoal:IsA(type : string) : boolean 
	return (type:lower() == 'charcoal')
end 
function Charcoal:Destroy() -- scorch
	self:Scorch()
end
function Charcoal.new() : Cleaner
	return setmetatable({
		_items = {}
	}, Charcoal) :: Cleaner
end
--/ ...
return Charcoal
