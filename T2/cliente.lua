local luarpc = require "luarpc"


print("digite ip")

local ip = io.read()

print ("digite porta")
local porta = io.read()

local p1 = luarpc.createProxy ("0.0.0.0", porta, "exinterface")
--local p2 = luarpc.createProxy (ip, porta, "exinterface")
--local r, s = p1:foo(3, 5)
--local t = p2:boo(10)
local a,b = p1:foo("3.3","miau",10)
print("p1:foo(3,5) = "..tostring(a)..", "..tostring(b))
a,b = p1:foo(2,3)
print("p1:foo(2,3) = "..tostring(a)..", "..tostring(b))
a = p1:boo(16)
print("p1:boo(16) = "..tostring(a))
a = p1:moo(20)
print("p1:moo(20) = "..tostring(a))

--[[
print("\n#####IN cliente.lua#######")
print("Cria um client conectado a serv1")
print("\n#####ENDIN cliente.lua#######")
local p1 = luarpc.createProxy(serv1.ip,serv1.port,"exinterface")

print("\n#####IN cliente.lua#######")
print("->p1 = "..tostring(p1))
print("p1:foo(1,2) = "..tostring(p1:foo(1,2) ))
print("\n#####ENDIN cliente.lua#######")
--]]
