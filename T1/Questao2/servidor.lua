--Servidor, Fé em Deus que vai da certo

--importanto socket
local socket = require ("socket")
local kstring = "como vamos fazer uma string de 1kB? Vamor usar um for? tava pensando em algo do tipo:kstring = {} for i=1,999 do kstring[#kstring] = tostring(i%10)end kstring[#kstring] = '\\n' kstring = table.concat(kstring)..\\n \n"

--Criando socket TCP e ligando ao local host em qualquer porta.

local server=assert(socket.bind("*",123456))
-- Timeout de aguardar conexão
server:settimeout(5)
--descobrir qual porta o sistema operacional escolheu para nós
local ip,porta = server:getsockname()

-- print uma mensagem informando oq aconteceu

print("Por favor, conecte local host na porta ", porta)
print("Após a conexão, você tem 10 segundos para inserir uma linha")

--marca inicio
starttime = socket.gettime()

--espera por cliente
local  client, status = server:accept()
-- não bloquear a linha de espera do cliente
client:settimeout(2)
while 1 do
	--recebendo dados
	local line,err, partial = client:receive()
	-- se não tiver erro, envia de volta ao cliente
	if not err then 
		client:send(kstring)
	elseif err == "timeout" then
		break
	end
end

--fechando o objeto após terminar com o cliente
client:close()

--marca fim
endtime = socket.gettime()

--calcula duração do loop
timediff = endtime-starttime

--os dois segundos subtraídos servem para compensar a espera realizada pelo servidor
print("Fim do loop\n\t durou: "..(timediff-2).."s")
