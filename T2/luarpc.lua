--M (o módulo) é a tabela que será retornada ao chamar require "luarpc"
local M = {}
--tem que ver se esse local socket n deve ser declarado como M.socket ou algo do tipo (pra ter alguma persistência depois do return M)
local socket = require "socket"
local ri = require "readinterface"
local std_values = {
	string = " ",
	char = " ",
	double = 0 
}
--define a string que substituirá "\n" no encoding
local thesmile = "\\:-)\\"

--se não formos testar, fica mais fácil de nos livrarmos dos prints trocando testing para false [[MICA]]
local testing = false
local print = print
if not testing then
	print = function() end
end


--encode e decode retornam a string "nil" caso a conversão não seja possível
local function encode(tipo,valor)
	if tipo == "char" or tipo == "string" then
		valor = string.gsub(valor,"\n",thesmile)
	elseif tipo == "number" then
		--se resulttype é do tipo number, 
		valor = tostring(valor)
	end
	return (valor or "nil") .."\n"
end
local function decode(tipo,valor)
	if tipo == "char" or tipo == "string" then
		--troca thesmile por \n
		valor = "\""..string.gsub(valor,thesmile,"\n").."\""
	elseif tipo == "number" then
		--converte a string para um número
		valor = tonumber(valor)
	end
	return valor or "\"nil\""
end


--armazenará as corrotinas criadas por createServant(), para que possam ser enxergadas por waitIncoming()
M.threads = {}

local function servant(server,interface,object)
--código do servidor
	print("Corrotina servant inicializada")
	
	--loop da escuta de mensagens
	local clients = {}
	local conectado = 0
	--"yielda" true para waitIncoming ter confirmação de que a corrotina ainda está executando
	coroutine.yield(true)
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
				--verifica se mensagem é nome de função declarada
				if object[msg]~=nil then
					--recebe a quantidade de parâmetros especificada pela interface e armazena-os em l_args
					local l_args = {}
					
					--recebe args do proxy------------------------------
					for i,n in pairs(interface.methods[msg].args)do
						--recebe um argumento do cliente, mas pula os args out
						if n.direction ~= "out" then
							repeat
								local param, l_status = cli:receive()
							until l_status ~= "timeout"
							--não recebeu a quantidade esperada de parâmetros
							if l_status == "closed" then
							--não vai poder realizar a operação, o proxy fechou
							else
								table.insert(l_args,decode(param,n.type))
							end
						end
					end
					--fim recebe args do proxy-------------------------
					
					
					--chama a função object[funcname]
					local params_concat = table.concat(l_args,", ")
					--[[o uso de load() aqui é para transformar a string params_concat em código executável como chamada de função (tendo os parâmetros como parâmetros)]]
					local l_foo = load("local obj,funcname = ... return {obj[funcname]("..params_concat..")}")
					local returns = l_foo(object,funcname)


					--devolver returns para o proxy------------------------------
					--discrimina result
					local result = table.remove(returns,1)
					result = encode(interface.methods[funcname].resulttype,result or std_values[interface.methods[funcname].resulttype])
					---[[
					cli:send(result)
					--]]
					--devolve demais argumentos de returns
					for i,n in pairs(interface.methods[msg].args)do
						--devolve um argumento pro cliente, mas pula os args in
						if n.direction ~= "in" then
							local ret = table.remove(returns,1)
							local return_msg = encode(n.type,ret or std_values[n.type])
							cli:send(return_msg)
						end
					end
					--fim de devolver returns pra proxy-------------------------
				end
				print("mensagem recebida de "..tostring(cli))
				print(msg)
				--[[MICA]]
			end
		end
		print("Servant vai ceder controle")
		--"yielda" true para waitIncoming ter confirmação de que a corrotina ainda está executando
		coroutine.yield(clients)
		print("Servant recebeu controle")
	end
end
function M.createServant(object,interface)
	
	--[[if address is '*', the system binds to all local interfaces using the INADDR_ANY constant. If port is 0, the system automatically chooses an ephemeral port.
	encontrei esse trecho na descrição de master:bind(), que é usado por socket.bind(), aqui:
	http://w3.impa.br/~diego/software/luasocket/tcp.html
	]]
	--Acho que devemos usar 0 senão, pelo que entendi, o servidor iria se conectar a todas as portas.
	local server=assert(socket.bind(0,0))
	--[[descobrir qual porta o sistema operacional escolheu para nós, e vamos retornar, para poderem se conectar a tal porta]]
	local l_ip,l_porta = server:getsockname()
	server:settimeout(0)
	--t_interface é a tabela lida do arquivo interface
	local t_interface = ri.readinterface(interface)
	print("t_interface = "..tostring(t_interface))
	
	--corrotina do servidor 
	local co = coroutine.create(function() servant(server,t_interface,object) end)
	if co~=nil then
		print("Corrotina servant criada")
		--deixa a corrotina fazer sua inicialização
		coroutine.resume(co)
		--insere a corrotina criada na tabela "global"
		table.insert(M.threads,co)
		return {ip = l_ip,porta = l_porta}
	else --trata o caso da corrotina não ser criada
		print("Corrotina servant não foi criada")
		--fecha o servidor criado
		server:close()
	end	
	
end

local function send_call(proxy,funcname,...)
	--os argumentos de índice i >= 2 são os parâmetros da função
	if type(proxy)~="table" then
		print("Incorrect call (try using ':' instead of '.')")
	else
		--[[
			funcname é onde está o nome da função chamada
			proxy.interface é onde está especificada a interface
			proxy.interface.methods[funcname] acessa a especificação dos parâmetros para a função chamada
			proxy.client é o cliente para usar :send() e :receive()
		]]--[[MICA]]
		local args = {...}
		
		--Laço de envio dos parâmetros---------------------------
		for i,n in pairs(proxy.interface.methods[funcname].args) do
			if n.direction ~= "out" then
				local arg =  table.remove(args,1)
				if arg then
				--Trata discrepância do tipo recebido e tipo especificado
					if n.type ~= type(arg) or not(n.type == "double" and type(arg) == "number")then
						if n.type == "string" then
							arg = tostring(arg)
						elseif n.type == "char"then
							arg = tostring(arg)
							if #arg > 1 then
								arg = string.sub(arg,1,1)
							end
						elseif n.type == "double" then
							local convert = tonumber(arg)
							if convert == nil then
								return "__ERRORPC: Argumento inválido - Não foi possível realizar a conversão"
							else
								arg = convert
							end
						end
					end
				else
				--arg == nil, foram passados menos argumentos que o específicado
					arg = std_values[n.type]
				end
				local msg = encode(n.type,arg)
				
				--ENVIA PARÂMETRO----------------
				proxy.client:send(msg)
				---------------------------------
				
			end
		end
		--fim do laço de envio dos parâmetros---------------------
		
		local returns = {}
		--Recebimento do retorno----------------------------------
		for i,n in pairs(proxy.interface.methods[funcname].args) do
			--[[EDIT]]
			if n.direction ~= "in" then
				local msg, status, partial = proxy.client:receive()
				if status == "timeout" or status == "closed" then
					
					local l_error = "__ERRORPC: connection "..status..". received only "..tostring(#returns).." results"
					table.insert(returns,l_error,1)
					break
					
				else
					table.insert(returns,decode(n.type,msg))
				end
			end
		end
		--Fim do recebimento do retorno---------------------------
		
		--Retorna os argumentos-------------------
		local returns_concat = table.concat(returns,", ")
		local loaded = load("return "..returns_concat)
		return loaded()
	end	
end

local function trata_indice_desconhecido(proxy,funcname)
	--se a função especificada existe na interface, retorna a função que enviará a mensagem
	if proxy.interface.methods[funcname] then
		return function(p,...) return send_call(p,funcname,...) end
	else
		return function() return "__ERRORPC: Função não especificada na interface" end
	end


end

--Declaração da metatabela dos proxys---------------------------------------
local mt_proxy = {}
mt_proxy.__index = trata_indice_desconhecido
mt_proxy.__newindex = function (t,k,v) return "Não é permitido alterar o proxy!" end
mt_proxy.__metatable = "Não é permitido o acesso à metatabela"
--fimda declaração da metatabela dos proxys---------------------------------


function M.createProxy(ip, porta, interface)
	local cliente = socket.connect(ip,porta)
	local t_interface = ri.readinterface(interface)
	local proxy = {}
	proxy.interface = t_interface
	proxy.client = cliente
	setmetatable(proxy,mt_proxy)
	return proxy
end

function M.waitIncoming()
	local i = 1
	local timedout = {}

	while true do
		print("Chegou ao fim do array das threads?")
		if M.threads[i]==nil then
			print("\tsim")
			print("Não tem mais thread no array?")
			if M.threads[1] == nil then break end
			print("sim")
			i = 1
			timedout = {}
		end
		--res será true se a corrotina ainda estiver executando
		print("Recomeça "..tostring(M.threads[i]))
		local status,res = coroutine.resume(M.threads[i])
		print("\tstatus = "..tostring(status))
		print("\tres = "..tostring(res))
		--a thread terminou sua tarefa?
		if not res then
			print("Thread terminou a sua tarefa")
			table.remove(M.threads, i)
		else
			
			i = i + 1
			timedout[#timedout+1] = res
			print("todas as threads estão bloqueadas?")
			if #timedout == #(M.threads) then
				print("\tsim")
				os.execute("sleep " .. tonumber(20))
				--Trabalhos Futuros
				--socket.select(timedout)
			end 
		end
	end
end

return M
