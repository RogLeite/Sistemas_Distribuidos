local luarpc = require "luarpc"
local socket = require "socket"
local t = {}
local clients = {}
t.corr1 = function()
	local c = assert(socket.connect(0,0))
	print("\t\tcorr1")
	coroutine.yield(c:getsockname())
end
t.corr2 = function()
	local c = assert(socket.connect(0,0))
	print("\t\tcorr2")
	coroutine.yield(c:getsockname())
	print("\t\tcorr2")
end
t.corr3 = function()
	local c = assert(socket.connect(0,0))
	print("\t\tcorr3")
	coroutine.yield(c:getsockname())
	print("\t\tcorr3")
	coroutine.yield(function(t) return table.insert(t,clients[3]) end)
	print("\t\tcorr3")
end
t.corr5 = function()
	local c = assert(socket.connect(0,0))
	print("\t\tcorr5")
	coroutine.yield(c:getsockname())
	print("\t\tcorr5")
	coroutine.yield(function(t) return table.insert(t,clients[5]) end)
	print("\t\tcorr5")
	coroutine.yield(function(t) return table.insert(t,clients[5]) end)
	print("\t\tcorr5")
	coroutine.yield(function(t) return table.insert(t,clients[5]) end)
	print("\t\tcorr5")
end
for i,n in pairs(t) do
	table.insert(luarpc.threads,coroutine.create(n))
	table.insert(clients,socket.connect(coroutine.resume(luarpc.threads[#luarpc.threads])))
end
luarpc.waitIncoming()
