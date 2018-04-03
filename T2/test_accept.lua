local socket = require "socket"

local server=assert(socket.bind("*",123456))


local ip,porta = server:getsockname()
server:settimeout(10)
local clients = {}
for i=1,3 do
	clients[#clients+1], status =server:accept()
end
for i,n in pairs(clients) do
	print("client = "..tostring(n))
end
