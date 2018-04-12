local luarpc = require "luarpc"

--[[

print("digite ip")

local ip = io.read()

--]]
print ("Digite porta1")
local porta1 = io.read()
print ("Digite porta2")
local porta2 = io.read()
local p1 = luarpc.createProxy ("0.0.0.0", porta1, "exinterface")
local p2 = luarpc.createProxy ("0.0.0.0", porta2, "exinterface")
local a,b = p1:foo("3.3","miau",10)
print("p1:foo(3,5) = "..tostring(a)..", "..tostring(b))
a,b = p1:foo(2,3)
print("p1:foo(2,3) = "..tostring(a)..", "..tostring(b))
a = p2:boo(16)
print("p2:boo(16) = "..tostring(a))
a = p1:moo(20)
print("p1:moo(20) = "..tostring(a))
a,b = p2:coo("ai\no","\n")
print("p2:coo('ai\\no','\\n') = "..a..", "..b)
