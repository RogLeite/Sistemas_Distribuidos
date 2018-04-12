local luarpc = require "luarpc"
local socket = require "socket"




print("digite ip")

local ip = io.read()

print ("digite porta")
local porta = io.read()
local p1 = luarpc.createProxy(ip,porta,"exinterface")

print("#####IN test_proxy.lua#######")
print("p1 = "..tostring(p1))
p1:foo(1,2)
--[[
print("\n#################################\n\tp1:foo(1,2) = "..tostring(p1:foo(1,2)).."\n#################################\n")
print("#####ENDIN test_proxy.lua#######")
--]]
