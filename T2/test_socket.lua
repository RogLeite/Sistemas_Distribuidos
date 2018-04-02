--[[
	Testa se (e como) o parâmetro 0 pra socket.bind() funciona comparado ao parâmetro "*"
]]

local socket = require "socket"
local server1=assert(socket.bind("*",123456))
local ip1,porta1 = server1:getsockname()
print("ip1 = "..ip1)
print("porta1 = "..porta1)
local server2=assert(socket.bind(0,123457))
local ip2,porta2 = server2:getsockname()
print("ip2 = "..ip2)
print("porta2 = "..porta2)
