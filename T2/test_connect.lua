--Cliente, Fé no pai que esse programa sai

local socket = require ("socket")
local clients = {}
for i=1,3 do
	clients[#clients+1] = socket.connect('localhost',57920)
end
for i,n in pairs(clients) do
	print("client = "..tostring(n))
end
