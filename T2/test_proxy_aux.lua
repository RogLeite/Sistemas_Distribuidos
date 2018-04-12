
local socket = require "socket"
local function servant(server)
	local conectado, status = server:accept()
	conectado:settimeout(1)
	for i=1,10 do
		print("\n In coroutine servant:")
	
		local msg,status = nil,nil
		repeat
			msg,status = conectado:receive()
			print("---->msg = "..(msg or "recebeu nil"))
			
		until status == "timeout" or status == "closed"
		conectado:send("3\nalo alo\n")
	end
end

-- cria servidores:

local server=assert(socket.bind(0,0))
--[[descobrir qual porta o sistema operacional escolheu para nós, e vamos retornar, para poderem se conectar a tal porta]]
local l_ip,l_porta = server:getsockname()

--server:settimeout(0)
print("Conecte o cliente no IP "..l_ip.." e porta: ---------------------------------------- " .. l_porta)

--corrotina do servidor 
local co = coroutine.create(function() servant(server) end)
if co ~= nil then
		coroutine.resume(co)
		os.execute("sleep "..tonumber(5))
else --trata o caso da corrotina não ser criada
	print("Corrotina servant não foi criada")
	--fecha o servidor criado
	server:close()
end	
	

