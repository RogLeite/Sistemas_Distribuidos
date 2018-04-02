--[[
	Testa se (e como) o parâmetro 0 pra socket.bind() funciona comparado ao parâmetro "*"
]]

local socket = require "socket"
local server=assert(socket.bind("*",123456))
--local server=assert(socket.bind(0,123456))
local l_ip,l_porta = server:getsockname()
print("ip = "..l_ip)
print("porta = "..l_porta)
