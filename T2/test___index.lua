
function trata_chamada(...)
	for i,n in pairs({...}) do
		print("\t...["..tostring(i).."] = ("..tostring(type(n))..")"..tostring(n))
	end 
end
function test_function(...)
	for i,n in pairs({...}) do
		print("...["..tostring(i).."] = ("..tostring(type(n))..")"..tostring(n))
	end
	return trata_chamada
end

my_table = {}
my_metatable = {}
my_metatable.__index = test_function
print("my_table = "..tostring(my_table))
setmetatable(my_table,my_metatable)
print("\nteste com chamada my_table.hey(1,2)")
local hey = my_table.hey(1,2)
print("\nteste com chamada my_table:hey(1,2)")
local hey = my_table:hey(1,2)
