local luarpc = require "luarpc"
local socket = require "socket"
local t = {}
t.corr1 = function()
	local c = assert(socket.connect("*",123456))
	print("\t\tcorr1")
end
t.corr2 = function()
	local c = assert(socket.connect("*",123456))
	print("\t\tcorr2")
	coroutine.yield(c)
	print("\t\tcorr2")
end
t.corr3 = function()
	local c = assert(socket.connect("*",123456))
	print("\t\tcorr3")
	coroutine.yield(c)
	print("\t\tcorr3")
	coroutine.yield(c)
	print("\t\tcorr3")
end
t.corr5 = function()
	local c = assert(socket.connect("*",123456))
	print("\t\tcorr5")
	coroutine.yield(c)
	print("\t\tcorr5")
	coroutine.yield(c)
	print("\t\tcorr5")
	coroutine.yield(c)
	print("\t\tcorr5")
	coroutine.yield(c)
	print("\t\tcorr5")
end
for i,n in pairs(t) do
	table.insert(luarpc.threads,coroutine.create(n))
end
luarpc.waitIncoming()
