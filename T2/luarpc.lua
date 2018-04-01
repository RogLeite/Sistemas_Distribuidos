--M (o módulo) é a tabela que será retornada ao chamar require "luarpc"
local M = {}
--tem que ver se esse local socket n deve ser declarado como M.socket ou algo do tipo (pra ter alguma persistência depois do return M)
local socket = require "socket"
local readinterface = require "readinterface"

--armazenará as corrotinas criadas por createServant(), para que possam ser enxergadas por waitIncoming()
M.threads = {}


function M.createServant(object,interface)
	
	--[[if address is '*', the system binds to all local interfaces using the INADDR_ANY constant. If port is 0, the system automatically chooses an ephemeral port.
	encontrei esse trecho na descrição de master:bind(), que é usado por socket.bind(), aqui:
	http://w3.impa.br/~diego/software/luasocket/tcp.html
	]]
	--Acho que devemos usar 0 senão, pelo que entendi, o servidor iria se conectar a todas as portas.
	local server=assert(socket.bind(0,123456))
	--[[descobrir qual porta o sistema operacional escolheu para nós, e vamos retornar, para poderem se conectar a tal porta]]
	local l_ip,l_porta = server:getsockname()
	
	--corrotina do servidor 
	local co = coroutine.create(function ()
	--código do servidor
		--inicializa o servant, ele deve rodar uma vez antes de dormir (para ocorrer a inicialização)
		--para cada função em object
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
		server:settimeout(0)
		--loop da escuta de mensagens
		while true do --[[podemos pensar em pôr uma condição de término]]
		
		end
	)
	--insere a corrotina criada na tabela "global"
	table.insert(M.threads,co)
	return {,ip = l_ip,porta = l_porta}
end

function M.createProxy(ip, porta, interface)
	--vai retornar um "objeto" que terá índices correspondentes a cada função na interface.
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
