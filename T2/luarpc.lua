--M (o módulo) é a tabela que será retornada ao chamar require "luarpc"
local M = {}
--tem que ver se esse local socket n deve ser declarado como M.socket ou algo do tipo (pra ter alguma persistência depois do return M)
local socket = require "socket"
local ri = require "readinterface"

--se não formos testar, fica mais fácil de nos livrarmos dos prints trocando testing para false [[MICA]]
local testing = true
local print = print
if not testing then
	print = function() end
end
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
				--se não foi recebido nada
				print("Servant não escutou nada de "..tostring(cli))
			elseif status == "closed" then
				--se a conexão foi fechada, retira o cliente do array
				--clients[i]:close()--se foi fechado não precisa fechar -_-
				print("cliente "..tostring(cli).." foi fechado")
				clients[i] = nil
			else
				print("mensagem recebida de "..tostring(cli))
				print(msg)
				--[[trata a msg]]
				--[[MICA]]
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

local function send_call(...)
	local prox = ...[1]
	--os argumentos de índice i >= 2 são os parâmetros da função
	if type(prox)~="table" then
		print("Incorrect call (try using ':' instead of '.')")
	else
		--[[
			prox.interface é onde está especificada a interface
			prox.client é o cliente para usar :send() e :receive()
		]]--[[MICA]]
	
	end	
end

local function trata_indice_desconhecido(...)
-- primeiro argumento de ... é a tabela de qual se originou a chamada
	local t = ...[1]
	local i = ...[2]
	--se a função especificada existe na interface, retorna a função que enviará a mensagem
	if t.interface.methods[i] then
		return send_call
	else
		return function() print("not a specified function") end
	end


end

local mt_proxy = {}
mt_proxy.__index = trata_indice_desconhecido
mt_proxy.__metatable = "Não é permitido o acesso à metatabela"
function M.createProxy(ip, porta, interface)
	--vai retornar um "objeto" que terá índices correspondentes a cada função na interface.

	local cliente = socket.connect(ip,porta)
	local t_interface = ri.readinterface(interface)
	local proxy = {}
	proxy.interface = t_interface
	proxy.client = cliente
	setmetatable(proxy,mt_proxy)
	--será q dá pra usar metatable? --DÁ!
	
	--[[
	for name, details in t_interface.methods do
		
	end
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
