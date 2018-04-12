
local socket = require "socket"
local function servant(server)
	for i=1,10 do
		print("\n In coroutine servant:")
	
		local msg,status = nil,nil
		repeat
			msg,status = server:receive()
			print("---->msg = ")
		until status == "timeout"
	end
end

-- cria servidores:

local server=assert(socket.bind(0,0))
--[[descobrir qual porta o sistema operacional escolheu para nós, e vamos retornar, para poderem se conectar a tal porta]]
local l_ip,l_porta = server:getsockname()

server:settimeout(0)
print("Conecte o cliente no IP "..l_ip.." e porta: ---------------------------------------- " .. l_porta)

--corrotina do servidor 
local co = coroutine.create(function() servant(server) end)
if co ~= nil then

	os.execute("sleep "..tonumber(20))
	for i=1,10 do
		os.execute("sleep "..tonumber(5))
		coroutine.resume(co)
	end
else --trata o caso da corrotina não ser criada
	print("Corrotina servant não foi criada")
	--fecha o servidor criado
	server:close()
end	
	

