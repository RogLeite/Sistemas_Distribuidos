--Servidor, Fé em Deus que vai da certo

--importanto socket
local socket = require ("socket")


--Criando socket TCP e ligando ao local host em qualquer porta.

local server=assert(socket.bind("*",123456))
-- Timeout de aguardar conexão
server:settimeout(5)
--descobrir qual porta o sistema operacional escolheu para nós
local ip,porta = server:getsockname()

-- print uma mensagem informando oq aconteceu

print("Por favor, conecte local host na porta ", porta)
print("Após a conexão, você tem 10 segundos para inserir uma linha")

--loop para esperar por clientes

while 1 do
	--esperando uma conexão com qualquer cliente
	local  client, status =server:accept()
	--se nenhum cliente conecta
	if status == "timeout" then
		print("status ==  "..status)
		break
	end
	print('Alguem se conectou!')
	-- não bloquear a linha de espera do cliente
	client:settimeout(2)
	--recebendo dados
	local line,err, partial = client:receive()
	print("err "..(err or "nil"))
	print("Recebeu "..(line or partial))
	-- se não tiver erro, envia de volta ao cliente
	if not err then 
		client:send((line or partial).. "tai \n")
	elseif err == "timeout" then
		print("err ==  "..err)
		client:close()
		break
	end
	--fechando o objeto após terminar com o cliente
	client:close()
end
print("Fim do loop")
