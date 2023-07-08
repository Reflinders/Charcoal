--/ ... Charcoal; a clean-up class
-- Made by @Reflinders on github
-- V.1.0.3b; Last updated 6/18
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
		self:Handle(oldValue, self._items, index)
	end
	items[if typeof(index) == 'number' then index else #items + 1] = newValue
end
--/ ...
function Charcoal:Handle(itemToHandle:any?, items:{}?, index:number|string?)
	local rblxCo = "RBXScriptConnection"
	local typeOf = typeof(itemToHandle)
	local methods; methods = {
		['table'] = function(item)
			local isChecking = (index == '__charcoalCheck')
			if item.Destroy then
				if isChecking then
					return true
				end
				item:Destroy()
			elseif item.Disconnect then
				if isChecking then
					return true
				end
				item:Disconnect(); items[index] = nil
			elseif item.__char then
				if isChecking then
					return true
				end
				for subIndex, subItem in pairs(item) do
					if methods[typeof(subItem)] then
						self:Handle(subItem, item, subIndex)
					else
						item[subIndex] = nil
					end
				end
			elseif item.__charPromise then
				item:cancel()
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
		return methodAvailable(itemToHandle)
	end
end
--/ ... Additive Methods
function Charcoal:Construct(constructor : ()->(), ...) : {}|number
	local newObject = constructor(...)
	local index = self:Add(newObject)
	return newObject, index
end
function Charcoal:Add(...) : number -- returns numid
	local ids = {}
	for _, item in ipairs({...}) do
		assert(item ~= nil, "Charcoal: Error-- Item is nil")
		local ind = #self._items + 1; if (typeof(item) == 'table') then
			if not self:Handle(item, {}, '__charcoalCheck') then
				warn("Charcoal: attempt to add object(table) without a usable method (.Destroy, __char, .Disconnect, etc)")	
			end
		end
		self._items[ind] = item
		ids[#ids + 1] = ind
	end
	return unpack(ids)
end
function Charcoal:AddPromise(promise) -- only supports a single promise as of now, returns the same promise
	local ind = #self._items + 1
	promise.__charPromise = true
	self._items[ind] = promise
	return promise
end
--/ ... Destructive Methods
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
		items[index] = nil; index, item = next(items, index)
	end
end
function Charcoal:Destroy() -- alias for scorch
	self:Scorch()
end
function Charcoal:Trail(itemLooking:any?) : number -- finds and removes an item; returns the index
	for index, itemWithin in pairs(self._items) do
		if itemWithin == itemLooking then
			self._items[index] = nil
			return index
		end
	end
end
--/ ... Primary
function Charcoal:IsA(type : string) : boolean 
	return (type:lower() == 'charcoal')
end 

function Charcoal.new() : Cleaner
	return setmetatable({
		_items = {}
	}, Charcoal) :: Cleaner
end
--/ ...
return Charcoal
