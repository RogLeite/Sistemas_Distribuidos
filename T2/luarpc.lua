--[[
----------------Dupla----------------
Maria Micaele Vieira Chaves
Rodrigo Leite da Silva

]]--


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
local unsmile = "\\%:%-%)\\"
--se não formos testar, fica mais fácil de nos livrarmos dos prints trocando testing para false [[MICA]]
local testing = false
local print = print
local printmaster = print
if not testing then
	--printmaster = function() end
	print = function() end
end


--encode e decode retornam a string "nil" caso a conversão não seja possível
local function encode(tipo,valor)
	print("In encode:\n")
	print("valor = "..(valor or "hey, received nil"))
	if tipo == "char" or tipo == "string" then
		valor = string.gsub(valor,"\n",thesmile)
		print("\ttipo == char ou string, valor codificado = "..valor)
	elseif tipo == "double" then
		--se resulttype é do tipo number, 
		valor = tostring(valor)
		print("\ttipo == double, valor codificado = "..tostring(valor))
	end
	return (valor or "nil") .."\n"
end
local function decode(tipo,valor)
	print("In decode:\n")
	print("valor = "..(valor or "hey, received nil"))
	if tipo == "char" or tipo == "string" then
		--troca thesmile por \n
		valor = "\""..string.gsub(valor,unsmile,"\n").."\""
		print("\ttipo == char ou string, valor decodificado = "..valor)
	elseif tipo == "double" then
		--converte a string para um número
		valor = tonumber(valor)
		print("\ttipo == double, valor decodificado = "..tostring(valor))
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
				conectado:settimeout(0)
				table.insert(clients,conectado)
				print("corrotina aceitou cliente "..tostring(conectado))
			end
		until conectado == nil
		print("Servant começa a escutar mensagens")
		for index,cli in pairs(clients) do
			local funcname, status, partial = cli:receive()
				print("mensagem recebida de "..tostring(cli))
				print("->funcname = "..tostring(funcname))
				--[[MICA]]
			if status == "timeout" then
				--se não foi recebido nada
				print("Servant não escutou nada de "..tostring(cli))
			elseif status == "closed" then
				--se a conexão foi fechada, retira o cliente do array
				--clients[i]:close()--se foi fechado não precisa fechar -_-
				print("cliente "..tostring(cli).." foi fechado")
				table.remove(clients,i)
			else
				--verifica se mensagem é nome de função declarada
				if object[funcname]~=nil then
					--recebe a quantidade de parâmetros especificada pela interface e armazena-os em l_args
					local l_args = {}
					
					--recebe args do proxy------------------------------
					for i,n in pairs(interface.methods[funcname].args)do
						--recebe um argumento do cliente, mas pula os args out
						if n.direction ~= "out" then
							local param, l_status = nil,nil
							repeat
								param, l_status = cli:receive()
								print("------param = "..tostring(param).." ------")
								print("------type(param) = "..tostring(type(param)).." ------")
								print("------l_status = "..tostring(l_status).." ------")
							until l_status ~= "timeout" or l_status == nil
							--não recebeu a quantidade esperada de parâmetros
							if l_status == "closed" then
							--não vai poder realizar a operação, o proxy fechou
							else
								table.insert(l_args,decode(n.type, param))
								print("--->l_args[#l_args] = "..tostring(l_args[#l_args]))
								print("--->type(l_args[#l_args]) = "..tostring(type(l_args[#l_args])))
							end
						end
					end
					print("-->Servant terminou de receber argumentos")
					--fim recebe args do proxy-------------------------
					
					

					--chama a função object[funcname]------------------------------
					
					
					local returns = {object[funcname](table.unpack(l_args))}
					
					--fim de chamada da função------------------------------------
					
					--[=[
					--chama a função object[funcname]------------------------------
					local params_concat = table.concat(l_args,", ")
					print("-->params_concat = "..params_concat)
					--[[o uso de load() aqui é para transformar a string params_concat em código executável como chamada de função (tendo os parâmetros como parâmetros)]]
					local l_foo = load("local obj,funcname = ... return {obj[funcname]("..params_concat..")}")
					local returns = l_foo(object,funcname)
					print("-->table.concat(returns,' \\n\\ ') = "..table.concat(returns,' \\n\\ '))
					--fim de chamada da função------------------------------------
					--]=]

					--devolver returns para o proxy------------------------------
					if interface.methods[funcname].resulttype~="void" then
						--discrimina result
						local result = table.remove(returns,1)
						print("-->result = "..tostring(result))
						result = encode(interface.methods[funcname].resulttype,result or std_values[interface.methods[funcname].resulttype])
						---[[
						cli:send(result)
						--]]
					end
					--devolve demais argumentos de returns
					print("-->table.concat(returns,' \\n\\ ') = "..table.concat(returns,' \\n\\ '))
					
					---[[
					for i,n in pairs(interface.methods[funcname].args)do
						--devolve um argumento pro cliente, mas pula os args in
						if n.direction ~= "in" then
							local ret = table.remove(returns,1)
							--pode não ser o comportamento desejado mas garante que é retornado o número certo de argumentos
							--[=[[[EDIT]]algo pra se cuidar é decidir o que fazer se é retornada uma quantidade menor que a esperada de argumentos --]=]
							local return_msg = encode(n.type,ret)
							cli:send(return_msg)
						end
					end
					--]]
					--fim de devolver returns pra proxy-------------------------
				end
			end
		end
		print("Servant vai ceder controle")
		--"yielda" true para waitIncoming ter confirmação de que a corrotina ainda está executando
		coroutine.yield(function(t) 
				print("######IN coroutine.yield#####")
				print("\t#t = "..#t)
				print("\t#clients = "..#clients)
			 	for i,n in pairs(clients) do
			 		--print("clients["..i.."] = "..tostring(n))
			 		table.insert(t,n)
			 	end
				print("\t#t = "..#t)
				--for i,n in pairs(t)do print("\t\tt["..i.."] = "..n) end
				print("######ENDIN coroutine.yield#####")
			 	return t
			 end)
		print("Servant recebeu controle")
	end
end
function M.createServant(object,interface)
	
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
		
		--retorna uma tabela com as entradas ip e port
		return {ip = l_ip,port = l_porta}
		
		
	else --trata o caso da corrotina não ser criada
		print("Corrotina servant não foi criada")
		--fecha o servidor criado
		server:close()
	end	
	
end

local function send_call(proxy,funcname,...)
local returns = {}

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
		
		
		proxy.client:send(encode("string",funcname))
		--Laço de envio dos parâmetros---------------------------
		for i,n in pairs(proxy.interface.methods[funcname].args) do
			if n.direction ~= "out" then
				local arg =  table.remove(args,1)
				if arg then
				--Trata discrepância do tipo recebido e tipo especificado
					if n.type ~= type(arg) or not(n.type == "double" and type(arg) == "number")then
						if n.type == "string" then
							arg = tostring(arg)
						elseif n.type == "char" then
							arg = tostring(arg)
							if #arg > 1 then
								arg = string.sub(arg,1,1)
							end
						elseif n.type == "double" then
							local convert = tonumber(arg)
							if convert == nil then
								table.insert(returns,"__ERRORPC: Argumento inválido - Não foi possível realizar a conversão")
								arg=std_values[n.type]
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
		
		
		--Recebimento do retorno----------------------------------
		if proxy.interface.methods[funcname].resulttype ~= "void" then
			local msg, status, partial = proxy.client:receive()
			table.insert(returns,decode(proxy.interface.methods[funcname].resulttype,msg))
		end
		for i,n in pairs(proxy.interface.methods[funcname].args) do
			if n.direction ~= "in" then
				local msg, status, partial = proxy.client:receive()
				if status == "timeout" or status == "closed" then
					
					local l_error = "__ERRORPC: connection "..status..". received only "..tostring(#returns).." results"
					table.insert(returns,1,"\""..l_error.."\"")
					break
					
				else
					table.insert(returns,decode(n.type,msg))
				end
			end
		end
		--Fim do recebimento do retorno---------------------------
		
		--Retorna os argumentos-------------------
		return table.unpack(returns)
		--[=[
		--Retorna os argumentos-------------------
		local returns_concat = table.concat(returns,", ")
		print("returns_concat = "..returns_concat)
		local loaded = load("return "..returns_concat)
		return loaded()
		--]=]
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
	local sockets = {}
	while true do
		print("Chegou ao fim do array das threads?")
		if M.threads[i]==nil then
			print("\tsim")
			print("Não tem mais thread no array?")
			if M.threads[1] == nil then break end
			i = 1
			timedout = {}
			sockets = {}
		end
		--res será true se a corrotina ainda estiver executando
		print("Recomeça "..tostring(M.threads[i]))
		local status,res = coroutine.resume(M.threads[i])
		print("\tstatus = "..tostring(status))
		printmaster("\tres = "..tostring(res))
		sockets = res(sockets)
		--a thread terminou sua tarefa?
		if not res then
			print("Thread terminou a sua tarefa")
			table.remove(M.threads, i)
		else
			
			timedout[#timedout+1] = M.threads[i]
			i = i + 1
			print("todas as threads estão bloqueadas?")
			if #timedout == #(M.threads) then
				print("\tsim||#sockets = "..#sockets)
				if #sockets < 1 then
					print("\twaitIncoming vai dormir")
					os.execute("sleep "..tonumber(1))
				else
					print("\twaitIncoming vai usar select")
					socket.select(sockets)
				end
			end 
		end
	end
end

return M
