local luarpc = require "luarpc"


print("digite ip")

local ip = io.read()

print ("digite porta")
local porta = io.read()

local p1 = luarpc.createProxy (ip, porta, "exinterface")
--local p2 = luarpc.createProxy (ip, porta, "exinterface")
--local r, s = p1:foo(3, 5)
--local t = p2:boo(10)

print(p1:foo(3,5))


