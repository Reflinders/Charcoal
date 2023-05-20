--/ ... Charcoal; a clean-up class
-- V.1.0; Last updated 5/19
-- / ...

local Charcoal = {}; Charcoal.__index = Charcoal
export type Charchoal = typeof(setmetatable({}, Charcoal)) & {
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
	--/ ...
	if typeOf == 'table' then
		if itemToHandle.Destroy then
			itemToHandle:Destroy()
		elseif itemToHandle.Disconnect then
			itemToHandle:Disconnect(); items[index] = nil
		elseif itemToHandle.__char then
			for _b, x in pairs(itemToHandle) do
				local valid = {
					Instance = true,
					table = true,
					['function'] = true,
					[rblxCo] = true
				}
				if valid[typeof(x)] then
					self:Handle(x)
				else
					itemToHandle[_b] = nil
				end
			end
		end
	elseif typeOf == 'Instance' then
		itemToHandle:Destroy()
	elseif typeOf == 'function' then
		itemToHandle(); items[index] = nil
	elseif typeOf == rblxCo then
		itemToHandle:Disconnect()
	end
end
function Charcoal:Add(...) : number -- returns numid
	local ids = {}
	for _, item in ipairs({...}) do
		assert(item ~= nil, "Charchoal: Error-- Item is nil")
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
function Charcoal:Destroy() -- completely destroy 
	self:Scorch(); self = nil
end
function Charcoal.new() : Charchoal
	return setmetatable({
		_items = {}
	}  :: Charchoal, Charcoal)	
end
--/ ...
return Charcoal
