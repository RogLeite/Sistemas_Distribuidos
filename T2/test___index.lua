
function trata_chamada(proxy,...)
	print("\tproxy = "..tostring(proxy))
	print("\tproxy.funcname = "..tostring(proxy.funcname))
	for i,n in pairs({...}) do
		print("\t...["..tostring(i).."] = ("..tostring(type(n))..")"..tostring(n))
	end 
end
function test_function(proxy,...)
	print("proxy = "..tostring(proxy))
	local iteratable = {...}
	for i,n in pairs(iteratable) do
		print("...["..tostring(i).."] = ("..tostring(type(n))..")"..tostring(n))
	end
	proxy.funcname = iteratable[1]
	return trata_chamada
end

my_table = {funcname = 0}
my_metatable = {}
my_metatable.__index = test_function
print("my_table = "..tostring(my_table))
setmetatable(my_table,my_metatable)
--[[
print("\nteste com chamada my_table.hey(1,2)")
local hey = my_table.hey(1,2)
--]]
print("\nteste com chamada my_table:hey(1,2)")
local hey = my_table:hey(1,2)
