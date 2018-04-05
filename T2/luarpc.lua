--M (o módulo) é a tabela que será retornada ao chamar require "luarpc"
local M = {}
--tem que ver se esse local socket n deve ser declarado como M.socket ou algo do tipo (pra ter alguma persistência depois do return M)
local socket = require "socket"
local ri = require "readinterface"

--armazenará as corrotinas criadas por createServant(), para que possam ser enxergadas por waitIncoming()
M.threads = {}
local function servant(server)
--código do servidor
	--inicializa o servant, ele deve rodar uma vez antes de dormir (para ocorrer a inicialização)
	--para cada função em object
	print("Corrotina servant inicializada")
	--[=[
	for name,funct in pairs(object) do
		--confere se funct é uma função
		if type(funct)~="function" then
			--trata o caso em que não é uma função
			--[[
			string = tostring(funct)
			funct = function() return string end
			]]
		end
	end
	]=]
	--loop da escuta de mensagens
	local clients = {}
	local conectado = 0
	coroutine.yield()
	print("Servant começou loop")
	while true do
		print("corrotina começa a aguardar cliente")
		repeat
			--aceita conexão com cliente
			conectado = server:accept() 
			if conectado ~= nil then
				--se houve conexão, armazena o cliente
				clients[#clients+1] = conectado
				clients[#clients]:settimeout(0)
				print("corrotina aceitou cliente "..tostring(conectado))
			end
		until conectado == nil
		print("Servant começa a escutar mensagens")
		for index,cli in pairs(clients) do
			local msg, status, partial = cli:receive()
			if status == "timeout" then
				print("Servant não escutou nada de "..tostring(cli))
				--se não foi recebido nada
			elseif status == "closed" then
				--se a conexão foi fechada, retira o cliente do array
				--clients[i]:close()--se foi fechado não precisa fechar -_-
				print("cliente "..tostring(cli).." foi fechado")
				clients[i] = nil
			else
				print("mensagem recebida de "..tostring(cli))
				print(msg)
				--[[trata a msg]]
			end
		end
		print("Servant vai ceder controle")
		coroutine.yield()
		print("Servant recebeu controle")
	end
end

function M.createServant(object,interface)
	
	--[[if address is '*', the system binds to all local interfaces using the INADDR_ANY constant. If port is 0, the system automatically chooses an ephemeral port.
	encontrei esse trecho na descrição de master:bind(), que é usado por socket.bind(), aqui:
	http://w3.impa.br/~diego/software/luasocket/tcp.html
	]]
	--Acho que devemos usar 0 senão, pelo que entendi, o servidor iria se conectar a todas as portas.
	local server=assert(socket.bind(0,123456))
	--[[descobrir qual porta o sistema operacional escolheu para nós, e vamos retornar, para poderem se conectar a tal porta]]
	local l_ip,l_porta = server:getsockname()
	server:settimeout(0)
	--t_interface é a tabela lida do arquivo interface
	local t_interface = ri.readinterface(interface)
	print("t_interface = "..tostring(t_interface))
	
	--corrotina do servidor 
	local co = coroutine.create(function() servant(server) end)
	if co~=nil then
		print("Corrotina servant criada")
		--insere a corrotina criada na tabela "global"
		table.insert(M.threads,co)
		return {ip = l_ip,porta = l_porta}
	else --trata o caso da corrotina não ser criada
		print("Corrotina servant não foi criada")
		--fecha o servidor criado
		server:close()
	end	
	
end

function M.createProxy(ip, porta, interface)
	--vai retornar um "objeto" que terá índices correspondentes a cada função na interface.

	local cliente = socket.connect(ip,porta)
	local t_interface = ri.readinterface(interface)
	local proxy = {}
	for name, details in t_interface.methods do
		
	end
	--será q dá pra usar metatable?
	--[[
	ex.foo = function(...) <-- ESSA É A SOLUÇÃO PRA GENTE! FUNÇÕES VARIÁDICAS!!!
		for i,n in ipairs{...} do
			--o tratamento dos argumentos, gerado com base na interface passada
		end	
	end
	]]
end

function M.waitIncoming()

end

return M
