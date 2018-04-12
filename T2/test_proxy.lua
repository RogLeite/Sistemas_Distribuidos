local luarpc = require "luarpc"
local socket = require "socket"





local function servant(server)
	print("\n In coroutine servant:")
	local msg,status = nil,nil
	repeat
		msg,status = server:receive()
		print("---->msg = ")
	until status == "timeout"

end


local server=assert(socket.bind(0,0))
--[[descobrir qual porta o sistema operacional escolheu para nós, e vamos retornar, para poderem se conectar a tal porta]]
local l_ip,l_porta = server:getsockname()

server:settimeout(0)
--corrotina do servidor 
local co = coroutine.create(function() servant(server) end)
if co ~= nil then

else --trata o caso da corrotina não ser criada
	print("Corrotina servant não foi criada")
	--fecha o servidor criado
	server:close()
end	
	


local p1 = luarpc.createProxy(l_ip,l_porta,"exinterface")

print("#####IN test_proxy.lua#######")
print("p1 = "..tostring(p1))
print("\n#################################\n\tp1:foo(1,2) = "..tostring(p1:foo(1,2)).."\n#################################\n")
print("#####ENDIN test_proxy.lua#######")


